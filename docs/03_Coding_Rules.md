# FreshKeeper 编码规范

> Version: v1.0
>
> 状态: Draft
>
> 最后更新: 2026-07-19

---

## 1. Flutter 编码规范

### 1.1 语言要求

- 使用 Dart 3.x，启用完整空安全（sound null safety）
- 启用 `strict-casts`、`strict-inference`、`strict-raw-types` 分析规则
- 禁止使用 `dynamic` 类型，业务代码中所有类型必须显式声明
- 禁止使用 `late` 关键字，除非绝对必要且已注释说明理由
- 禁止使用 `as` 强制类型转换，改用类型守卫或模式匹配

### 1.2 代码风格

- 遵循 Dart 官方风格指南：`dart format` 自动格式化
- 单行不超过 80 个字符
- 使用 `const` 构造函数，只要编译期可确定就加
- 避免链式调用层级超过 3 层（嵌套 builder、嵌套 widget 等）
- 避免在 build 方法中执行任何 IO、数据库查询或耗时操作
- 禁止在 Widget 中直接 new 实例；所有依赖通过 Riverpod 注入

### 1.3 导入顺序

导入按以下分组排序，每组之间空一行：

```
1. dart: 开头的 SDK 库
2. package: 开头的第三方库
3. package: 开头的项目内部库（使用相对导入）
4. relative 导入（../
```

每组内部按字母序排列。禁止使用 `package:` 导入同模块文件，同模块内使用相对导入。

```
// ✅ 正确
import "dart:async";

import "package:drift/drift.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";

import "package:freshkeeper/core/constants/app_constants.dart";
import "package:freshkeeper/domain/entities/food_item.dart";

import "../widgets/food_card.dart";

// ❌ 错误
import "food_card.dart";                // 缺少相对路径
import "package:freshkeeper/features/home/widgets/food_card.dart"; // 同模块内用 import
```

---

## 2. 命名规范

### 2.1 文件命名

| 类型 | 规则 | 示例 |
|------|------|------|
| Dart 文件 | snake_case，全部小写，下划线分隔 | `food_item.dart` |
| 测试文件 | `_test.dart` 后缀 | `food_item_test.dart` |
| Widget 文件 | 使用对应 widget 的 snake_case | `food_card.dart` |
| Provider 文件 | `_providers.dart` 后缀 | `home_providers.dart` |
| 数据库文件 | `_table.dart` / `_dao.dart` 后缀 | `food_item_table.dart` / `food_item_dao.dart` |
| Markdown 文档 | 两位数字前缀 + 英文大写 | `00_Product_Vision.md` |

### 2.2 类命名

| 类型 | 规则 | 示例 |
|------|------|------|
| Widget | UpperCamelCase，名词性 | `FoodCard`、`HomePage` |
| Provider (类型) | UpperCamelCase + Provider 后缀 | `foodItemListProvider` |
| UseCase | UpperCamelCase，动名词 | `AddFoodItem`、`GetFoodItems` |
| Repository (接口) | UpperCamelCase | `FoodRepository` |
| Repository (实现) | UpperCamelCase + Impl 后缀 | `FoodRepositoryImpl` |
| Model/Entity | UpperCamelCase | `FoodItem`、`FoodItemModel` |
| DAO | UpperCamelCase + Dao 后缀 | `FoodItemDao` |
| Service | UpperCamelCase + Service 后缀 | `NotificationService` |
| Enum | UpperCamelCase | `FoodStatus`、`FoodCategory` |

### 2.3 变量命名

| 类型 | 规则 | 示例 |
|------|------|------|
| 局部变量 | lowerCamelCase | `final itemCount` |
| 私有成员 | lowerCamelCase，前置 `_` | `_items`、`_loadData` |
| 常量 | lowerCamelCase（遵循 Dart 规范） | `defaultExpiryDays`、`maxItems` |
| 枚举值 | lowerCamelCase | `FoodStatus.normal` |
| 布尔变量 | 使用 `is` / `has` / `should` 前缀 | `isExpired`、`hasNotification` |

### 2.4 方法命名

- 使用动词开头：`getAllFoodItems()`、`addFood()`、`updateStatus()`
- 事件回调使用 `on` 前缀：`onTap`、`onDelete`、`onStatusChanged`
- 私有方法使用 `_` 前缀：`_buildHeader()`、`_filterExpired()`

---

## 3. 目录规范

### 3.1 目录结构规则

```
lib/
├── app/               # App 级别配置
├── core/              # 全局共享
├── data/              # 数据层
├── domain/            # 领域层
├── features/          # 功能模块
├── notification/      # 通知服务
└── providers/         # 全局 Provider
```

### 3.2 目录职责

| 目录 | 可包含 | 禁止包含 |
|------|--------|----------|
| `app/` | MaterialApp 配置、路由定义 | 业务逻辑、UI 页面组件 |
| `core/` | 常量、主题、工具函数、枚举、扩展方法 | 业务逻辑、数据库访问 |
| `data/` | 数据库、DAO、Repository 实现、Model | Widget、页面、Provider |
| `domain/` | Entity、Repository 接口、UseCase | Flutter 依赖、UI 代码 |
| `features/` | 页面、Widget、Provider | 数据库访问、Repository 实现 |
| `notification/` | 通知服务、后台任务 | UI 组件、业务实体 |
| `providers/` | 全局 Provider（注入依赖） | 页面组件、业务逻辑 |

### 3.3 模块内目录结构

每个 feature 模块内部使用固定结构：

```
features/home/
├── providers/    # 本模块的 Riverpod Provider
├── pages/        # 完整页面（一个文件一个页面）
└── widgets/      # 页面内复用的 Widget 组件
```

规则：

- `providers/` 文件只包含 Provider 定义，不包含 UI 代码
- `pages/` 文件只包含 Page Widget，一个文件一个页面
- `widgets/` 文件只包含可复用小组件，每个组件一个文件
- 模块间禁止相互引用 providers 或 widgets；共享逻辑提升到 `core/` 或通过 `domain` 层协调

---

## 4. Widget 规范

### 4.1 Widget 拆分原则

- 每个 Widget 文件不超过 150 行（含空行）
- 超过 150 行的页面必须拆分为子 Widget
- 一个 Widget 只做一件事
- build 方法中禁止嵌套超过 6 层
- 列表项、卡片等可复用组件必须抽取为独立 Widget 文件

### 4.2 Stateless vs Stateful

| 情况 | 使用 |
|------|------|
| 只依赖外部数据展示 | StatelessWidget |
| 需要管理本地动画/焦点/文本编辑 | StatefulWidget |
| 需要响应状态变更 | 使用 Riverpod 的 ConsumerWidget / ConsumerStatefulWidget |
| 动画控制 | StatefulWidget + AnimationController |

规则：

- 优先使用 `ConsumerWidget` 替代 `StatelessWidget`
- 优先使用 `ConsumerStatefulWidget` 替代 `StatefulWidget`
- 避免在 Widget 内直接管理业务状态；业务状态交给 Riverpod

### 4.3 Widget 构造函数

- 所有可复用 Widget 必须使用 `const` 构造函数
- Widget 参数使用 `required` 关键字声明必填参数
- 可选参数放在最后
- 回调参数类型必须显式声明，禁止使用 `Function`

```
// ✅ 正确
class FoodCard extends ConsumerWidget {
  const FoodCard({
    super.key,
    required this.foodName,
    required this.expiryDate,
    this.onTap,
  });

  final String foodName;
  final DateTime expiryDate;
  final VoidCallback? onTap;
  // ...
}
```

### 4.4 Build 方法规则

- build 方法必须保持纯净：不做 IO、不发起网络请求、不执行数据库查询
- build 方法中只能读取 Provider 状态，不能写入
- 条件渲染使用条件表达式，禁止在 build 中创建新列表或执行复杂计算
- 耗时计算提前在 Provider 或 UseCase 中完成

---

## 5. Riverpod 规范

### 5.1 Provider 定义规则

- 每个 Provider 必须声明明确的返回类型，禁止使用 `var` 或 `dynamic`
- Provider 定义放在独立的 `_providers.dart` 文件中
- 全局级 Provider 放在 `lib/providers/app_providers.dart`
- 功能模块级 Provider 放在对应 `features/*/providers/` 目录下
- 一个文件内不超过 3 个 Provider 定义

### 5.2 Provider 类型选择

| 场景 | 使用的 Provider 类型 |
|------|---------------------|
| 注入单例依赖 | `Provider<T>` |
| 读取只读异步数据 | `FutureProvider<T>` |
| 读取流式数据（如数据库监听） | `StreamProvider<T>` |
| 可修改的异步状态（新增、删除、更新） | `AsyncNotifierProvider` |
| 可修改的同步状态（设置项） | `NotifierProvider` |
| 从其他 Provider 派生计算 | `Provider<T>`（派生） |

### 5.3 Provider 依赖规则

- Provider 之间通过 `ref.watch()` / `ref.read()` 组合
- 上层 Provider 只能用 `ref.watch` 依赖下层 Provider
- 禁止循环依赖
- 避免 Provider 层级过深（不超过 5 层）
- 副作用操作（写入数据库、发送通知）放在 AsyncNotifier 的方法中，不在 build 中执行

### 5.4 状态更新规则

- 数据写入完成后调用 `ref.invalidate()` 通知相关 Provider 刷新
- 避免直接修改 Provider 持有的 List 或 Map 状态；使用不可变更新
- 异步操作统一使用 `AsyncValue.guard()` 包裹
- 状态更新必须在 AsyncNotifier 的方法内完成，禁止在 Widget 中直接修改 Provider 状态

### 5.5 AutoDispose 规则

- 页面级 Provider 默认使用 `autoDispose`：页面销毁后自动释放
- 全局 Provider（数据库、Repository）不使用 autoDispose
- 通知相关 Provider 不使用 autoDispose

---

## 6. Drift 规范

### 6.1 表定义规则

- 表名使用复数形式：`food_items`、`categories`
- 字段名使用 snake_case：`expiry_date`、`created_at`
- 每个表必须有自增主键 `id`
- 时间字段使用 `DateTimeColumn`，存储为 ISO 8601 字符串
- 枚举字段使用 `IntColumn` 存储索引值，不存字符串
- 所有字段必须有明确的默认值（`withDefault`）

### 6.2 DAO 规则

- 每个表对应一个 DAO 文件
- DAO 方法命名遵循查询语义：
  - 查询单条：`getXxx`
  - 查询列表：`getAllXxx` / `getXxxList`
  - 新增：`insertXxx` / `addXxx`
  - 更新：`updateXxx`
  - 删除：`deleteXxx`
- DAO 返回类型必须明确，禁止返回 `Future<void>` 以外的无类型结果
- DAO 不包含业务逻辑（如"是否即将过期"的判断），业务逻辑在 UseCase 中处理

### 6.3 数据库文件规则

- 数据库文件命名为 `freshkeeper.db`
- 文件存储在 `getApplicationDocumentsDirectory()` 下
- MVP 期间不引入迁移逻辑；schema 变更时直接清除数据
- 数据库操作在主线程执行（SQLite 本地操作足够快，无需异步线程）

### 6.4 模型转换规则

- Drift Model（`FoodItemModel`）供 Data 层内部使用
- Domain Entity（`FoodItem`）供 Domain 和 Presentation 层使用
- 转换逻辑集中在 Repository 实现中，不在 DAO 中转换
- Model → Entity 转换方法统一命名为 `_toEntity`
- Entity → Model 转换方法统一命名为 `_toModel`

---

## 7. Git Commit 规范

### 7.1 Commit Message 格式

```
<type>: <subject>

<body> (可选)
```

**type 取值：**

| type | 用途 |
|------|------|
| `feat` | 新功能 |
| `fix` | Bug 修复 |
| `docs` | 文档变更 |
| `refactor` | 重构（不涉及功能变更） |
| `style` | 代码格式调整（空格、格式化等） |
| `chore` | 构建流程、依赖管理、项目配置 |
| `perf` | 性能优化 |
| `test` | 测试相关 |

**subject 规则：**

- 不超过 50 个字符
- 中文描述，动词开头
- 末尾不加句号

### 7.2 提交粒度

- 每个提交只做一件事
- 文档变更与代码变更分开提交
- WIP 提交不允许 push 到远程仓库
- 本地可以频繁提交，push 前可以 rebase 整理

### 7.3 分支策略

MVP 期间采用简化分支策略：

| 分支 | 用途 |
|------|------|
| `master` | 主分支，随时可发布 |
| `dev` | 开发分支，日常开发合入 |
| `feat/*` | 功能分支，从 dev 切出，完成后合回 dev |

单人开发时可简化为：

- 直接基于 `master` 开发
- 每个功能或修复独立提交
- 完成一个里程碑后打 tag

### 7.4 Commit 示例

```
feat: 首页新增食材列表按过期日期排序

docs: 补充 Architecture.md 数据流章节

fix: 修复食材状态在零点后未自动更新

refactor: 提取 FoodCard 为独立 Widget

chore: 初始化 Flutter 项目结构

style: 调整 import 顺序使其符合规范
```

---

## 8. 注释规范

### 8.1 注释原则

- 注释解释"为什么这样做"，而不是"做了什么"
- 好的代码本身应该能说明"做了什么"
- 不写废话注释：`// 设置名称` → 这行代码本身已经表达了这个意思

### 8.2 文档注释

- 所有公开 API（UseCase、Repository 接口、Service 方法）必须写 `///` 文档注释
- 文档注释内容：方法功能描述 + 参数说明 + 返回值说明
- 不需要对每个参数写 `@param` DartDoc，在描述中自然带出即可

```
/// 获取指定天数内即将过期的食材列表。
///
/// [withinDays] 表示距离过期多少天内算作"即将过期"，默认 3 天。
/// 返回的列表按过期日期升序排列，已消耗和已丢弃的食材不包含在内。
Future<List<FoodItem>> call({int withinDays = 3});
```

### 8.3 实现注释

- 复杂算法或逻辑需添加行内注释
- TODO 注释必须标注负责人和日期：`// TODO(xiaoming): 2026-07-19 后续需要优化排序`
- FIXME 注释必须标注问题描述：`// FIXME: 日期比较未考虑时区偏移`
- 禁止提交含有 DEBUG 或临时注释的代码

### 8.4 文件头注释

每个 Dart 文件顶部添加文件说明注释：

```
/// 食材卡片组件。
///
/// 在首页列表中展示单件食材的摘要信息，
/// 包括食材名称、剩余天数、过期日期和状态颜色。
library;
```

---

## 9. Material3 规范

### 9.1 设计语言

- 全局使用 Material Design 3（M3）设计语言
- 使用 `MaterialApp` 的 `useMaterial3: true` 启用
- 主题使用 `ColorScheme.fromSeed()` 基于种子色生成
- 不覆写 M3 组件默认行为，除非有明确的产品理由

### 9.2 主题色

- 种子色（seed color）：根据品牌定义单一种子色
- App 内不使用自定义 `Color` 常量；所有颜色从 `Theme.of(context).colorScheme` 获取
- 暗色模式跟随系统设置，通过 `ThemeData(brightness: ...)` 自动切换
- 组件颜色使用语义化配色，不直接引用色值

### 9.3 组件使用规则

| M3 组件 | 使用场景 |
|---------|----------|
| `Card` | 食材卡片、信息卡片 |
| `FilledButton` | 主要操作（保存、确认） |
| `TextButton` | 次要操作（取消、修改日期） |
| `FloatingActionButton` | 首页新增食材入口 |
| `SegmentedButton` | 时间筛选切换 |
| `Chip` | 食材标签、分类标签 |
| `NavigationBar` | 底部导航（后续版本） |
| `AlertDialog` | 确认删除、确认丢弃 |
| `SnackBar` | 操作反馈（"已标记为已吃掉"） |
| `BottomSheet` | 扩展操作（列表选择） |

### 9.4 字体与排版

- 使用 M3 默认字体（Roboto）
- 字号层级使用 `TextTheme` 内置样式，不自定义字号
  - 首页标题：`titleLarge`
  - 食材名称：`titleMedium`
  - 剩余天数：`headlineMedium`
  - 分组标题：`labelLarge`
  - 辅助信息：`bodySmall`
- 不使用内联 `TextStyle`；所有文字样式通过 `Theme.of(context).textTheme` 获取

### 9.5 间距与布局

- 间距使用 8dp 基准网格：8、16、24、32
- 不使用固定像素值；间距从 `Theme.of(context).visualDensity` 或常量中获取
- Card 内边距统一为 16dp
- 页面左右边距统一为 16dp
- 组件之间的间距使用 SizedBox / Padding，不用 Container 做间距

### 9.6 动效

- 使用 M3 默认动效曲线
- 不自定义动画时长，使用 `Duration(milliseconds: 200)` 或 `300`
- 列表项出现使用 `AnimatedList` 或简单 FadeTransition
- 状态变更使用 `AnimatedSwitcher` 做平滑过渡
- 手势操作（滑动标记）使用 `Dismissible` 组件

### 9.7 无障碍

- 所有交互组件必须提供 `Semantics` 标签
- 图片化 emoji 需要语义化描述
- 颜色不能作为唯一的信息传递方式（色盲用户友好）
- 目标触摸区域不小于 48x48 dp

---

## 10. 代码审查清单

每次提交前对照检查：

### 功能性

- [ ] 新增功能有对应的 UseCase
- [ ] 数据变更后调用了 `ref.invalidate()`
- [ ] 空状态有对应的 UI 展示
- [ ] 错误状态有对应的 UI 展示
- [ ] 加载状态有对应的 UI 展示

### 代码质量

- [ ] 无 `dynamic` 类型
- [ ] 无 `late` 变量（除非已标注理由）
- [ ] 无未使用的 import
- [ ] 无硬编码的字符串（使用常量或国际化）
- [ ] Widget 不超过 150 行
- [ ] build 方法中无 IO 或数据库操作

### 架构合规

- [ ] UI 层未直接引用 Data 层（如 DAO、Model）
- [ ] Domain 层未引用 Flutter 库
- [ ] Feature 之间无交叉引用
- [ ] Provider 定义在正确的目录下
- [ ] 数据库操作通过 Repository → DAO 路径完成

### 样式

- [ ] 使用 M3 配色语义，无自定义 Color
- [ ] 使用 `const` 构造函数
- [ ] 导入顺序符合规范
- [ ] `dart format` 通过
- [ ] 主题样式通过 Theme 获取

---

## 11. 禁用清单

以下做法在本项目中禁止使用：

| 禁止项 | 理由 | 替代方案 |
|--------|------|----------|
| `setState` | 破坏单向数据流 | Riverpod Provider |
| `InheritedWidget` | Riverpod 已封装 | Riverpod Provider |
| `BuildContext` 传参 | 隐式依赖，难测试 | Riverpod 依赖注入 |
| `GlobalKey` 访问状态 | 反模式 | Riverpod Provider |
| `async` 的 `build` 方法 | Flutter 不允许 | FutureProvider |
| `Navigator.push` / `pop` | 类型不安全 | GoRouter |
| `Provider.of<T>` | Riverpod 不使用 | `ref.watch` |
| `MediaQuery.of(context)` | 可通过 context 获取 | `Theme.of(context)` |
| 直接操作数据库路径 | App 沙箱已隔离 | Drift API |
| `print()` 调试 | 生产环境泄露 | `log()` / `debugPrint()` |
