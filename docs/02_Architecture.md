# FreshKeeper 技术架构文档

> Version: v1.0
>
> 状态: Draft
>
> 最后更新: 2026-07-19

---

## 1. 技术栈

| 层面 | 选型 | 说明 |
|------|------|------|
| 框架 | Flutter 3.x | 双端（Android + iOS） |
| 语言 | Dart 3.x | 完整空安全 |
| 状态管理 | Riverpod 2.x | 编译安全，隐式依赖注入 |
| 本地数据库 | Drift (Moor) | SQLite 封装，类型安全，生成器支持 |
| 本地通知 | flutter_local_notifications | 跨平台本地通知 |
| 后台任务 | workmanager | Android 定时检查，iOS 后台刷新 |
| 路由 | go_router | 声明式路由，支持深度链接 |
| 最低版本 | Android 8+ / iOS 15+ | |

---

## 2. 架构总览

### 2.1 分层架构

采用 Clean Architecture 三层结构，每层只依赖内层：

```
┌───────────────────────────────────────────────┐
│               Presentation                     │
│   (features / pages / widgets / providers)     │
│                                                │
│   ┌─────────────────────────────────────────┐  │
│   │            Domain                        │  │
│   │  (entities / usecases / repositories)   │  │
│   │                                         │  │
│   │  ┌───────────────────────────────────┐  │  │
│   │  │            Data                   │  │  │
│   │  │  (database / datasources /        │  │  │
│   │  │   models / repositories_impl)     │  │  │
│   │  └───────────────────────────────────┘  │  │
│   └─────────────────────────────────────────┘  │
└───────────────────────────────────────────────┘
```

**依赖规则：**

- Presentation → 仅依赖 Domain 层
- Domain → 不依赖任何外部库
- Data → 实现 Domain 层定义的接口

### 2.2 数据流方向

```
 User Action
     │
     ▼
┌──────────────┐
│  Provider    │  Riverpod StateNotifier / AsyncNotifier
│  (features)  │
└──────┬───────┘
       │  calls
       ▼
┌──────────────┐
│  UseCase     │  业务逻辑（单一职责）
│  (domain)    │
└──────┬───────┘
       │  calls
       ▼
┌──────────────┐
│  Repository  │  抽象接口（domain）
│  interface   │
└──────┬───────┘
       │  implemented by
       ▼
┌──────────────┐
│  Repository  │  具体实现（data）
│  Impl        │
└──────┬───────┘
       │  calls
       ▼
┌──────────────┐
│  DAO         │  Drift 生成的查询层
│  (database)  │
└──────┬───────┘
       │  reads/writes
       ▼
┌──────────────┐
│  SQLite DB   │  本地数据库文件
└──────────────┘
```

数据返回路径相同：DB → DAO → Repository → UseCase → Provider → UI。

---

## 3. 目录结构

```
lib/
├── main.dart                           # 入口，ProviderScope 包裹
│
├── app/
│   ├── app.dart                        # MaterialApp.router 配置
│   └── router.dart                     # GoRouter 路由定义
│
├── core/
│   ├── constants/
│   │   ├── app_constants.dart          # 全局常量（默认提醒天数等）
│   │   └── preset_foods.dart           # 预置食材列表 + emoji 映射
│   ├── theme/
│   │   └── app_theme.dart              # 主题色、字体、组件默认样式
│   ├── enums/
│   │   └── food_status.dart            # normal / expiring / expired / consumed / discarded
│   ├── utils/
│   │   ├── date_utils.dart             # 日期计算：剩余天数、过期判断
│   │   └── food_emoji.dart             # 食材名称 → emoji 映射函数
│   └── extensions/
│       └── date_extensions.dart        # DateTime 扩展方法
│
├── data/
│   ├── database/
│   │   ├── app_database.dart           # @DriftDatabase 声明
│   │   ├── app_database.g.dart         # 生成代码
│   │   ├── tables/
│   │   │   └── food_item_table.dart    # 食材表定义
│   │   └── daos/
│   │       └── food_item_dao.dart      # 查询方法：增删改查+排序
│   ├── models/
│   │   ├── food_item_model.dart        # Drift 行数据映射类
│   │   └── food_category.dart          # 食材分类枚举
│   └── repositories/
│       └── food_repository_impl.dart   # Repository 接口实现
│
├── domain/
│   ├── entities/
│   │   └── food_item.dart              # 纯 Dart 领域实体
│   ├── repositories/
│   │   └── food_repository.dart        # 抽象接口定义
│   └── usecases/
│       ├── get_food_items.dart         # 获取全部食材（排序）
│       ├── get_expiring_items.dart     # 获取即将过期食材
│       ├── add_food_item.dart          # 新增食材
│       ├── update_food_status.dart     # 标记已吃/已丢弃
│       └── update_expiry_date.dart     # 修改过期日期
│
├── features/
│   ├── home/
│   │   ├── providers/
│   │   │   └── home_providers.dart     # foodItemListProvider 等
│   │   ├── pages/
│   │   │   └── home_page.dart          # 首页 UI
│   │   └── widgets/
│   │       ├── today_section.dart      # "今天吃这些" 顶栏
│   │       ├── food_group_section.dart # 分组列表（今天/即将/其它）
│   │       ├── food_card.dart          # 单张食材卡片
│   │       └── empty_state.dart        # 空冰箱引导
│   │
│   ├── add_food/
│   │   ├── providers/
│   │   │   └── add_food_providers.dart # 录入状态管理
│   │   ├── pages/
│   │   │   └── add_food_page.dart      # 录入页 UI
│   │   └── widgets/
│   │       ├── food_tag_grid.dart      # 常见食材标签网格
│   │       ├── search_bar.dart         # 搜索过滤
│   │       └── expiry_quick_buttons.dart # 3/7/14/30 天快捷按钮
│   │
│   ├── detail/
│   │   ├── providers/
│   │   │   └── detail_providers.dart   # 单个食材状态
│   │   ├── pages/
│   │   │   └── detail_page.dart        # 详情页 UI
│   │   └── widgets/
│   │       ├── food_emoji_display.dart  # Emoji 大图展示
│   │       └── action_buttons.dart     # 已吃掉/已扔掉按钮
│   │
│   └── settings/
│       ├── providers/
│       │   └── settings_providers.dart # 设置状态管理
│       ├── pages/
│       │   └── settings_page.dart      # 设置页 UI
│       └── widgets/
│           └── setting_tile.dart       # 设置行组件
│
├── notification/
│   ├── notification_service.dart       # 初始化 + 发送本地通知
│   ├── notification_providers.dart     # 通知相关 Provider
│   └── background_check.dart           # WorkManager 后台检查任务
│
└── providers/
    └── app_providers.dart              # 全局 Provider：数据库、Repository
```

---

## 4. 数据流

### 4.1 UI → Data（写入流程）

以"新增食材"为例：

```
┌──────────────┐
│  AddFoodPage │  用户填写食材名 + 过期日期 → 点击保存
└──────┬───────┘
       │  ref.read(addFoodItemProvider.notifier).add(name, date)
       ▼
┌──────────────────┐
│  addFoodItemProvider │  Riverpod AsyncNotifier
│  (features/add)  │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  AddFoodItem     │  UseCase: 校验参数 → 构建实体 → 调用 Repository
│  (domain)        │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  FoodRepository  │  抽象接口：Future<int> add(FoodItem item)
│  (interface)     │
└──────┬───────────┘
       │
       ▼
┌──────────────────────┐
│  FoodRepositoryImpl  │  转换实体为模型 → 调用 DAO
│  (data)              │
└──────┬───────────────┘
       │
       ▼
┌──────────────────┐
│  FoodItemDao     │  Drift DAO: into(foodItems).insert(model)
│  (database)      │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  SQLite          │  写入 food_items 表
└──────────────────┘
```

### 4.2 Data → UI（读取流程）

以"首页加载食材列表"为例：

```
┌──────────────────┐
│  SQLite          │  food_items 表
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  FoodItemDao     │  SELECT * FROM food_items ORDER BY expiry_date ASC
│  (database)      │
└──────┬───────────┘
       │ 返回 List<FoodItemModel>
       ▼
┌──────────────────────┐
│  FoodRepositoryImpl  │  转换为 List<FoodItem>
│  (data)              │
└──────┬───────────────┘
       │
       ▼
┌──────────────────┐
│  GetFoodItems    │  UseCase: 调用 repository, 排序分组
│  (domain)        │
└──────┬───────────┘
       │
       ▼
┌──────────────────┐
│  homeProvider    │  Riverpod: 异步获取 → AsyncValue<List<FoodItem>>
│  (features/home) │
└──────┬───────────┘
       │  ref.watch(homeProvider) → UI rebuild
       ▼
┌──────────────┐
│  HomePage     │  渲染卡片列表
└──────────────┘
```

### 4.3 响应式更新

当数据发生变更（新增、删除、修改状态）时，Riverpod 通过 `ref.invalidate()` 或状态更新触发 UI 重建：

```
User Action → Provider state update → ref.watch → UI rebuild
```

具体机制：

- 写入操作完成后，Provider 调用 `ref.invalidate(foodItemListProvider)`
- 依赖 `foodItemListProvider` 的所有下游 Provider 自动重新获取数据
- 首页 UI 自动刷新

---

## 5. State Flow

### 5.1 Provider 层级

```
appProviders (全局)
├── databaseProvider          → AppDatabase 单例
├── foodItemDaoProvider       → FoodItemDao
├── foodRepositoryProvider    → FoodRepository (impl)
│
├── settingsProvider          → SharedPreferences (提醒时间, 提前天数)
│
├── foodItemListProvider      → AsyncValue<List<FoodItem>>  (数据源)
│   ├── homeTodayProvider     → 过滤出今天过期的食材
│   ├── homeExpiringProvider  → 过滤出 1-3 天内过期的食材
│   ├── homeOtherProvider     → 过滤出 3 天以上的食材
│   └── expiringCountProvider → 即将过期数量（用于通知判断）
│
├── addFoodItemProvider       → AsyncNotifier, 新增操作
├── foodDetailProvider(id)    → AsyncValue<FoodItem> 单个食材
├── updateStatusProvider      → AsyncNotifier, 更新状态操作
│
└── notificationProvider      → 通知权限、开关状态
```

### 5.2 状态类型

每个 Provider 的异步状态遵循 Riverpod 的 AsyncValue 三态：

```dart
AsyncValue<T>  {
  data: T         // 成功，持有数据
  loading: true   // 加载中
  error: Error    // 错误，持有异常
}
```

在 UI 层统一处理：

```dart
ref.watch(foodItemListProvider).when(
  data: (items) => FoodListView(items: items),
  loading: () => const Center(child: CircularProgressIndicator()),
  error: (e, _) => ErrorView(message: e.toString()),
);
```

### 5.3 食材状态自动流转

食材状态由 `FoodStatus` 枚举定义，通过定时任务自动流转：

```
                     ┌──────────┐
                     │  录入    │
                     └────┬─────┘
                          │ status = normal
                          ▼
                     ┌──────────┐
                     │  normal  │  expiryDate - now > 3 天
                     └────┬─────┘
                          │ 每日零点检查
                          ▼
                     ┌──────────┐
                     │ expiring │  1 天 < expiryDate - now <= 3 天
                     └────┬─────┘
                          │ 每日零点检查
                          ▼
                     ┌──────────┐
                     │ expired  │  expiryDate <= now
                     └────┬─────┘
                          │ 用户操作
                ┌─────────┼──────────┐
                │         │          │
                ▼         ▼          ▼
           ┌────────┐ ┌────────┐  ┌────────┐
           │consumed│ │discard │  │ 修改   │
           └────────┘ └────────┘  │日期    │
                                   └────┬───┘
                                        │
                                        ▼
                                    ┌──────────┐
                                    │ 重新计算  │
                                    └──────────┘
```

状态自动检查在以下时机触发：

- App 启动时（`main.dart` 初始化）
- 每日定时通知检查时（后台任务）
- 首页下拉刷新时

---

## 6. Repository

### 6.1 抽象接口（Domain）

```dart
// domain/repositories/food_repository.dart

abstract class FoodRepository {
  Future<List<FoodItem>> getAllFoodItems();
  Future<List<FoodItem>> getExpiringItems(int withinDays);
  Future<List<FoodItem>> getExpiredItems();
  Future<FoodItem?> getFoodItemById(int id);
  Future<int> addFoodItem(FoodItem item);
  Future<void> updateFoodStatus(int id, FoodStatus status);
  Future<void> updateExpiryDate(int id, DateTime newDate);
  Future<void> deleteFoodItem(int id);
}
```

### 6.2 具体实现（Data）

```dart
// data/repositories/food_repository_impl.dart

class FoodRepositoryImpl implements FoodRepository {
  final FoodItemDao _dao;

  FoodRepositoryImpl(this._dao);

  @override
  Future<List<FoodItem>> getAllFoodItems() async {
    final models = await _dao.getAllFoodItems();
    return models.map(_toEntity).toList();
  }

  // ... 其他方法类似

  FoodItem _toEntity(FoodItemModel model) => FoodItem(
    id: model.id,
    name: model.name,
    category: model.category,
    emoji: model.emoji,
    expiryDate: model.expiryDate,
    createdAt: model.createdAt,
    status: FoodStatus.values[model.statusIndex],
  );

  FoodItemModel _toModel(FoodItem entity) => FoodItemModel(
    id: entity.id,
    name: entity.name,
    category: entity.category,
    emoji: entity.emoji,
    expiryDate: entity.expiryDate,
    createdAt: entity.createdAt,
    statusIndex: entity.status.index,
  );
}
```

### 6.3 依赖注入（Riverpod）

```dart
// providers/app_providers.dart

final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

final foodItemDaoProvider = Provider<FoodItemDao>((ref) {
  return ref.watch(databaseProvider).foodItemDao;
});

final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(foodItemDaoProvider));
});
```

---

## 7. UseCase

### 7.1 设计原则

- 每个 UseCase 只有一个 `call()` 方法
- UseCase 是纯 Dart 类，不含任何 Flutter 依赖
- UseCase 可组合（一个 UseCase 内部调用另一个 UseCase）
- UseCase 接收 Domain Entity，返回 Domain Entity

### 7.2 UseCase 列表

```
domain/usecases/
├── get_food_items.dart          # 获取全部食材（按过期日期升序）
├── get_expiring_items.dart      # 获取 N 天内过期的食材
├── add_food_item.dart           # 新增食材，含参数校验
├── update_food_status.dart      # 修改食材状态（消耗/丢弃）
└── update_expiry_date.dart      # 修改过期日期，触发重新计算
```

### 7.3 示例实现

```dart
// domain/usecases/add_food_item.dart

class AddFoodItem {
  final FoodRepository _repository;

  AddFoodItem(this._repository);

  Future<FoodItem> call({
    required String name,
    required String category,
    required String emoji,
    required DateTime expiryDate,
  }) async {
    // 参数校验
    if (name.trim().isEmpty) {
      throw ArgumentError('食材名称不能为空');
    }
    if (expiryDate.isBefore(DateTime.now().subtract(const Duration(days: 1)))) {
      throw ArgumentError('过期日期不能早于今天');
    }

    final item = FoodItem(
      name: name.trim(),
      category: category,
      emoji: emoji,
      expiryDate: expiryDate,
      createdAt: DateTime.now(),
      status: FoodStatus.normal,
    );

    final id = await _repository.addFoodItem(item);
    return item.copyWith(id: id);
  }
}
```

```dart
// domain/usecases/get_expiring_items.dart

class GetExpiringItems {
  final FoodRepository _repository;

  GetExpiringItems(this._repository);

  Future<List<FoodItem>> call({int withinDays = 3}) async {
    final items = await _repository.getAllFoodItems();
    final now = DateTime.now();

    return items.where((item) {
      if (item.status == FoodStatus.consumed ||
          item.status == FoodStatus.discarded) {
        return false;
      }
      final daysUntilExpiry = item.expiryDate.difference(now).inDays;
      return daysUntilExpiry >= 0 && daysUntilExpiry <= withinDays;
    }).toList()
      ..sort((a, b) => a.expiryDate.compareTo(b.expiryDate));
  }
}
```

---

## 8. Provider

### 8.1 Provider 分类

| 类型 | 用途 | 数量 |
|------|------|------|
| `Provider<T>` | 注入单例依赖（数据库、DAO、Repository） | 3 |
| `FutureProvider<T>` | 一次性异步数据（食材列表） | 1 |
| `AsyncNotifierProvider<T>` | 可修改的异步状态（新增、更新操作） | 3 |
| `StateNotifierProvider<T>` | 可修改的同步状态（设置项） | 1 |

### 8.2 核心 Provider 定义

```dart
// providers/app_providers.dart — 全局依赖注入
final databaseProvider = Provider<AppDatabase>((ref) => AppDatabase());
final foodItemDaoProvider = Provider<FoodItemDao>((ref) {
  return ref.watch(databaseProvider).foodItemDao;
});
final foodRepositoryProvider = Provider<FoodRepository>((ref) {
  return FoodRepositoryImpl(ref.watch(foodItemDaoProvider));
});
```

```dart
// features/home/providers/home_providers.dart — 首页数据

final foodItemListProvider = FutureProvider<List<FoodItem>>((ref) async {
  final repo = ref.watch(foodRepositoryProvider);
  return repo.getAllFoodItems();
});

final todayExpiredProvider = Provider<List<FoodItem>>((ref) {
  final items = ref.watch(foodItemListProvider).valueOrNull ?? [];
  final today = DateTime.now();
  return items.where((item) =>
    item.status.isActive &&
    item.expiryDate.year == today.year &&
    item.expiryDate.month == today.month &&
    item.expiryDate.day == today.day
  ).toList();
});

final expiringSoonProvider = Provider<List<FoodItem>>((ref) {
  final items = ref.watch(foodItemListProvider).valueOrNull ?? [];
  final now = DateTime.now();
  return items.where((item) {
    if (!item.status.isActive) return false;
    final diff = item.expiryDate.difference(now).inDays;
    return diff > 0 && diff <= 3;
  }).toList();
});
```

```dart
// features/add_food/providers/add_food_providers.dart — 新增流程

class AddFoodItemNotifier extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> addFood(FoodItem item) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final useCase = AddFoodItem(ref.read(foodRepositoryProvider));
      await useCase.call(
        name: item.name,
        category: item.category,
        emoji: item.emoji,
        expiryDate: item.expiryDate,
      );
      ref.invalidate(foodItemListProvider);
    });
  }
}

final addFoodItemProvider = AsyncNotifierProvider<AddFoodItemNotifier, void>(
  AddFoodItemNotifier.new,
);
```

---

## 9. 数据库

### 9.1 Drift 表定义

```dart
// data/database/tables/food_item_table.dart

import 'package:drift/drift.dart';

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get category => text()();
  TextColumn get emoji => text()();
  DateTimeColumn get expiryDate => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  IntColumn get statusIndex => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
```

### 9.2 表结构

| 字段 | 类型 | 说明 |
|------|------|------|
| id | INTEGER (PK, AUTOINCREMENT) | 主键 |
| name | TEXT | 食材名称，如"牛奶" |
| category | TEXT | 分类，如"乳制品" |
| emoji | TEXT | 对应 emoji，如"🥛" |
| expiry_date | TEXT (ISO 8601) | 过期日期，不含时间 |
| created_at | TEXT (ISO 8601) | 录入时间 |
| status_index | INTEGER | 状态枚举索引：0=normal, 1=expiring, 2=expired, 3=consumed, 4=discarded |

### 9.3 DAO 定义

```dart
// data/database/daos/food_item_dao.dart

import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/food_item_table.dart';

part 'food_item_dao.g.dart';

@DriftAccessor(tables: [FoodItems])
class FoodItemDao extends DatabaseAccessor<AppDatabase> with _$FoodItemDaoMixin {
  FoodItemDao(AppDatabase db) : super(db);

  // 查询全部，按过期日期升序
  Future<List<FoodItemModel>> getAllFoodItems() {
    return (select(foodItems)
      ..orderBy([(f) => OrderingTerm(expression: f.expiryDate)])
    ).get();
  }

  // 查询单个
  Future<FoodItemModel?> getFoodItemById(int id) {
    return (select(foodItems)..where((f) => f.id.equals(id))).getSingleOrNull();
  }

  // 新增
  Future<int> insertFoodItem(FoodItemsCompanion entry) {
    return into(foodItems).insert(entry);
  }

  // 更新状态
  Future<void> updateStatus(int id, int newStatusIndex) {
    return (update(foodItems)..where((f) => f.id.equals(id)))
      .write(FoodItemsCompanion(statusIndex: Value(newStatusIndex)));
  }

  // 更新过期日期
  Future<void> updateExpiryDate(int id, DateTime newDate) {
    return (update(foodItems)..where((f) => f.id.equals(id)))
      .write(FoodItemsCompanion(expiryDate: Value(newDate)));
  }

  // 删除
  Future<void> deleteFoodItem(int id) {
    return (delete(foodItems)..where((f) => f.id.equals(id))).go();
  }
}
```

### 9.4 数据库初始化

```dart
// data/database/app_database.dart

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import 'tables/food_item_table.dart';
import 'daos/food_item_dao.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [FoodItems], daos: [FoodItemDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'freshkeeper.db'));
    return NativeDatabase(file);
  });
}
```

### 9.5 数据库版本迁移策略

| 版本 | 变更 | 迁移操作 |
|------|------|----------|
| 1 | 初始版本 | 创建 food_items 表 |

MVP 期间不引入数据库迁移；后续版本通过 `MigrationStrategy` 管理。

---

## 10. 通知

### 10.1 整体设计

```
┌───────────────────────┐
│     App 启动          │
│  main.dart 初始化     │
└───────┬───────────────┘
        │
        ▼
┌───────────────────────┐
│  NotificationService  │
│  ┌─────────────────┐  │
│  │ 初始化插件       │  │  flutter_local_notifications
│  │ 请求权限         │  │  Android: POST_NOTIFICATIONS
│  └────────┬────────┘  │
│           │           │
│  ┌────────▼────────┐  │
│  │ 注册定时检查     │  │  WorkManager (Android)
│  │                 │  │  BGTaskScheduler (iOS)
│  └─────────────────┘  │
└───────────────────────┘
        │
        ▼
┌───────────────────────┐          ┌───────────────────┐
│ 定时检查触发          │─────────→│ 读取数据库        │
│ (每日用户设定时间)     │          │ 查询过期/即将过期  │
└───────────────────────┘          └────────┬──────────┘
                                             │
                                             ▼
                                    ┌───────────────────┐
                                    │ 是否有需要通知的   │
                                    │ 食材？            │
                                    └───────┬───────────┘
                                            │
                              ┌─────────────┴─────────────┐
                              │ 否                        │ 是
                              ▼                           ▼
                     ┌─────────────┐           ┌───────────────────┐
                     │ 不发送通知   │           │ 构建通知内容       │
                     └─────────────┘           │ 发送本地通知       │
                                                └───────────────────┘
```

### 10.2 通知分类

| 通知类型 | 触发条件 | 通知内容 |
|----------|----------|----------|
| today_expired | 存在今日过期的食材 | "🥬 牛奶、菠菜今天过期，今天吃掉它们吧" |
| expiring_soon | 存在 1-3 天内过期的食材 | "🥬 你有 3 样食材即将过期" |
| mixed | 同时满足上述两者 | "🥬 牛奶今天过期，还有 2 样食材即将过期" |

### 10.3 去重逻辑

- 每天同一类型通知只发送一次
- 通知发送后记录时间戳到 SharedPreferences
- 如果用户当天已打开 App，不发送通知
- App 启动时不发送通知（首页已展示信息）

### 10.4 后台任务实现

```dart
// notification/background_check.dart

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // 1. 初始化数据库
    final db = AppDatabase();
    final dao = FoodItemDao(db);
    final repo = FoodRepositoryImpl(dao);

    // 2. 查询过期/即将过期食材
    final items = await repo.getAllFoodItems();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final expired = items.where((item) =>
      item.status.isActive &&
      item.expiryDate.isBefore(today.add(const Duration(days: 1)))
    ).toList();

    final expiring = items.where((item) {
      if (!item.status.isActive) return false;
      final diff = item.expiryDate.difference(today).inDays;
      return diff > 0 && diff <= 3;
    }).toList();

    // 3. 有食材需要提醒才发送
    if (expired.isNotEmpty || expiring.isNotEmpty) {
      final service = NotificationService();
      await service.sendDailyReminder(expired, expiring);
    }

    await db.close();
    return Future.value(true);
  });
}
```

### 10.5 NotificationService 接口

```dart
// notification/notification_service.dart

class NotificationService {
  /// 初始化通知渠道、请求权限
  Future<void> initialize();

  /// 发送每日汇总提醒
  Future<void> sendDailyReminder(
    List<FoodItem> expired,
    List<FoodItem> expiring,
  );

  /// 发送测试通知（用于调试）
  Future<void> sendTestNotification();

  /// 取消所有待发送通知
  Future<void> cancelAll();
}
```

---

## 11. 路由设计

### 11.1 路由表

```dart
// app/router.dart

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/add',
        builder: (context, state) => const AddFoodPage(),
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          final id = int.parse(state.pathParameters['id']!);
          return DetailPage(foodId: id);
        },
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
```

### 11.2 导航关系

```
/ (HomePage)
├── → /add                           (FAB 按钮)
├── → /detail/:id                    (点击食材卡片)
└── → /settings                      (点击设置齿轮)
/add → /                             (保存成功 / 返回)
/detail/:id → /                      (操作完成 / 返回)
```

---

## 12. 依赖关系汇总

```
main.dart
  └── ProviderScope
        └── App (MaterialApp.router)
              ├── routerProvider → GoRouter
              │
              ├── databaseProvider → AppDatabase
              │     └── foodItemDaoProvider → FoodItemDao
              │           └── foodRepositoryProvider → FoodRepository
              │                 ├── GetFoodItems UseCase
              │                 ├── AddFoodItem UseCase
              │                 ├── UpdateFoodStatus UseCase
              │                 └── ...
              │
              ├── foodItemListProvider → AsyncValue<List<FoodItem>>
              │     ├── todayExpiredProvider
              │     ├── expiringSoonProvider
              │     └── expiringCountProvider
              │
              ├── addFoodItemProvider → AsyncNotifier
              ├── foodDetailProvider(id) → AsyncValue<FoodItem>
              ├── updateStatusProvider → AsyncNotifier
              │
              ├── settingsProvider → SettingsState
              │
              └── notificationProvider → NotificationState
```

---

## 13. 关键决策记录

| 决策 | 选项 | 选择 | 理由 |
|------|------|------|------|
| 状态管理 | Riverpod / Bloc / GetX | Riverpod | 编译安全，无 BuildContext 依赖，测试友好 |
| 数据库 | Drift / Hive / sqflite | Drift | 类型安全，SQL 灵活，关系查询简单 |
| 状态自动流转 | Drift 触发器 / 应用层定时 | 应用层定时 | 更可控，易调试，不增加数据库复杂度 |
| 后台任务 | WorkManager / android_alarm_manager | WorkManager | 现代 Android API，iOS 兼容性好 |
| 路由 | Navigator 2.0 / GoRouter | GoRouter | 声明式，URL 映射清晰 |
| 实体映射 | 手写 / MapStruct / 代码生成 | 手写（小项目） | App 简单，手写更可控，无额外代码生成 |
| 食材 emoji | 硬编码映射 / API / 本地库 | 硬编码映射 | 30+ 条映射，离线可用，零依赖 |
