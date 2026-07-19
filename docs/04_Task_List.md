# FreshKeeper 开发任务清单

> Version: v1.0
>
> 状态: Draft
>
> 预估总工时: 48-72 小时
>
> 任务数量: 112 个
>
> 单任务工时: 15-30 分钟

---

## 阶段 0：项目搭建

---

### T-0001 创建 Flutter 项目

| 字段 | 内容 |
|------|------|
| **目标** | 使用 `flutter create` 初始化 Flutter 项目，指定包名和最低 SDK 版本 |
| **输入** | 空目录 docs/、assets/、design/、flutter_app/ |
| **输出** | flutter_app/ 目录下可编译的 Flutter 项目 |
| **验收标准** | `flutter run` 可正常启动空白页面，无编译错误 |
| **依赖** | 无 |

### T-0002 创建项目目录结构

| 字段 | 内容 |
|------|------|
| **目标** | 按 Architecture.md 定义的目录结构创建所有空目录 |
| **输入** | flutter_app/ 根目录 |
| **输出** | lib/ 下完整目录树：app/、core/、data/、domain/、features/ 等 |
| **验收标准** | 目录结构与 Architecture.md 完全一致 |
| **依赖** | T-0001 |

### T-0003 配置 pubspec.yaml 依赖

| 字段 | 内容 |
|------|------|
| **目标** | 添加所有第三方依赖：riverpod、drift、go_router、flutter_local_notifications、workmanager、shared_preferences、path_provider |
| **输入** | pubspec.yaml |
| **输出** | 配置好所有依赖的 pubspec.yaml，`flutter pub get` 成功 |
| **验收标准** | 所有依赖版本号锁定，无版本冲突 |
| **依赖** | T-0001 |

### T-0004 配置分析规则

| 字段 | 内容 |
|------|------|
| **目标** | 配置 analysis_options.yaml：启用 strict-casts、strict-inference、strict-raw-types |
| **输入** | analysis_options.yaml |
| **输出** | 严格模式的分析配置 |
| **验收标准** | `dart analyze` 报告 0 错误（初始化项目后） |
| **依赖** | T-0001 |

### T-0005 搭建 Material3 主题

| 字段 | 内容 |
|------|------|
| **目标** | 创建 app_theme.dart，配置 M3 ColorScheme、TextTheme、组件主题 |
| **输入** | lib/app/app.dart、lib/core/theme/app_theme.dart |
| **输出** | Material3 主题配置，包含亮色/暗色模式 |
| **验收标准** | App 启动后使用 M3 主题渲染，亮暗切换正常工作 |
| **依赖** | T-0001 |

### T-0006 配置 GoRouter 路由

| 字段 | 内容 |
|------|------|
| **目标** | 创建 router.dart，定义 4 个路由（首页、新增、详情、设置） |
| **输入** | lib/app/router.dart、lib/app/app.dart |
| **输出** | 声明式路由配置，页面参数传递 |
| **验收标准** | 路由表中所有路径可正常导航；传递参数后页面可接收 |
| **依赖** | T-0005 |

### T-0007 定义全局常量

| 字段 | 内容 |
|------|------|
| **目标** | 创建 app_constants.dart，定义默认提醒时间、提前天数、App 名称等 |
| **输入** | lib/core/constants/app_constants.dart |
| **输出** | 全局常量文件 |
| **验收标准** | 所有硬编码值收敛到常量文件，无散落在 Widget 中的魔数 |
| **依赖** | T-0002 |

### T-0008 搭建 DateUtils 工具

| 字段 | 内容 |
|------|------|
| **目标** | 创建日期工具函数：计算剩余天数、判断是否过期、格式化显示 |
| **输入** | lib/core/utils/date_utils.dart |
| **输出** | 纯函数工具集，不含 Flutter 依赖 |
| **验收标准** | 单元测试覆盖全部日期函数，边界值（零点、闰年、跨月）验证通过 |
| **依赖** | T-0002 |

---

## 阶段 1：数据库层

---

### T-0009 定义 FoodItems 数据库表

| 字段 | 内容 |
|------|------|
| **目标** | 使用 Drift 定义 food_items 表，包含 id、name、category、emoji、expiry_date、created_at、status_index |
| **输入** | lib/data/database/tables/food_item_table.dart |
| **输出** | Drift Table 定义 |
| **验收标准** | 表字段与 Architecture.md 表结构一致，主键、默认值配置正确 |
| **依赖** | T-0002、T-0003 |

### T-0010 配置 Drift 数据库

| 字段 | 内容 |
|------|------|
| **目标** | 创建 AppDatabase 类，关联 FoodItems 表和 FoodItemDao |
| **输入** | lib/data/database/app_database.dart |
| **输出** | Drift 数据库初始化文件 |
| **验收标准** | `flutter pub run build_runner build` 生成成功，无错误 |
| **依赖** | T-0009 |

### T-0011 运行 Drift 代码生成

| 字段 | 内容 |
|------|------|
| **目标** | 执行 build_runner 生成 Drift 代码（.g.dart 文件） |
| **输入** | app_database.dart、food_item_table.dart |
| **输出** | app_database.g.dart、food_item_table.g.dart |
| **验收标准** | 生成文件无 lint 错误，DAO mixin 可正常导入 |
| **依赖** | T-0010 |

### T-0012 实现 DAO — 查询方法

| 字段 | 内容 |
|------|------|
| **目标** | 实现 FoodItemDao：getAllFoodItems()（按过期日期升序）、getFoodItemById() |
| **输入** | lib/data/database/daos/food_item_dao.dart |
| **输出** | DAO 查询方法 |
| **验收标准** | 查询全部返回按 expiry_date ASC 排序的列表；按 ID 查询返回单条或 null |
| **依赖** | T-0011 |

### T-0013 实现 DAO — 写入方法

| 字段 | 内容 |
|------|------|
| **目标** | 实现 FoodItemDao：insertFoodItem()、updateStatus()、updateExpiryDate()、deleteFoodItem() |
| **输入** | food_item_dao.dart（在 T-0012 基础上扩展） |
| **输出** | DAO 写入方法 |
| **验收标准** | 写入后数据库行数增加；更新后字段值变更；删除后行数减少 |
| **依赖** | T-0012 |

### T-0014 定义 FoodStatus 枚举

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodStatus 枚举：normal、expiring、expired、consumed、discarded；提供 isActive 计算属性 |
| **输入** | lib/core/enums/food_status.dart |
| **输出** | 枚举定义文件 |
| **验收标准** | 枚举值顺序与数据库 status_index 一致；consumed 和 discarded 的 isActive 返回 false |
| **依赖** | T-0002 |

### T-0015 定义 FoodCategory 枚举

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodCategory 枚举：vegetables、fruits、dairy、meat、eggs、tofu、bread、beverages、condiments、other |
| **输入** | lib/data/models/food_category.dart |
| **输出** | 枚举定义文件 |
| **验收标准** | 分类覆盖 PRD 中预置食材列表所需的所有类别 |
| **依赖** | T-0002 |

### T-0016 实现食材 — Emoji 映射函数

| 字段 | 内容 |
|------|------|
| **目标** | 创建 food_emoji.dart，根据食材名称返回对应 emoji；未匹配时返回默认 🥘 |
| **输入** | lib/core/utils/food_emoji.dart |
| **输出** | 纯函数工具集 |
| **验收标准** | 牛奶 → 🥛、菠菜 → 🥬，未命中返回默认值；单元测试覆盖全部预置食材 |
| **依赖** | T-0002 |

### T-0017 创建预设食材常量数据

| 字段 | 内容 |
|------|------|
| **目标** | 创建 preset_foods.dart，定义 30+ 种常见食材的列表，含名称、分类、emoji、默认保质期 |
| **输入** | lib/core/constants/preset_foods.dart |
| **输出** | 预设食材常量数据 |
| **验收标准** | 数据覆盖蔬菜、水果、乳制品、肉类、蛋类、豆制品、面包、饮料、调味品；每种食材有默认保质期 |
| **依赖** | T-0014、T-0015、T-0016 |

### T-0018 实现 DateExtensions

| 字段 | 内容 |
|------|------|
| **目标** | 创建 DateTime 扩展方法：daysUntil()、isToday()、isExpired()、formatted() |
| **输入** | lib/core/extensions/date_extensions.dart |
| **输出** | 扩展方法文件 |
| **验收标准** | daysUntil 返回正确整数（正数/负数/零）；isToday 在同一天返回 true |
| **依赖** | T-0002 |

---

## 阶段 2：领域层

---

### T-0019 定义 FoodItem 领域实体

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodItem 不可变实体类，包含 id、name、category、emoji、expiryDate、createdAt、status 字段及 copyWith 方法 |
| **输入** | lib/domain/entities/food_item.dart |
| **输出** | 纯 Dart 实体类 |
| **验收标准** | 实体不含 Flutter 或 Drift 依赖；copyWith 创建新实例且旧实例不变 |
| **依赖** | T-0014、T-0018 |

### T-0020 定义 FoodRepository 抽象接口

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodRepository 抽象类，声明全部 CRUD 方法签名 |
| **输入** | lib/domain/repositories/food_repository.dart |
| **输出** | 抽象接口 |
| **验收标准** | 方法签名覆盖 Architecture.md 中定义的 7 个方法 |
| **依赖** | T-0019 |

### T-0021 实现 AddFoodItem UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 AddFoodItem 类，含 call 方法：校验参数 → 构建实体 → 调用 repository |
| **输入** | lib/domain/usecases/add_food_item.dart |
| **输出** | UseCase 类 |
| **验收标准** | 空名称抛出 ArgumentError；过期日期早于昨天抛出 ArgumentError；校验通过后调用 repository |
| **依赖** | T-0019、T-0020 |

### T-0022 实现 GetFoodItems UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 GetFoodItems 类，获取全部食材并按过期日期排序返回 |
| **输入** | lib/domain/usecases/get_food_items.dart |
| **输出** | UseCase 类 |
| **验收标准** | 返回列表按 expiryDate 升序排列 |
| **依赖** | T-0019、T-0020 |

### T-0023 实现 GetExpiringItems UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 GetExpiringItems 类，获取 N 天内过期且状态为 active 的食材 |
| **输入** | lib/domain/usecases/get_expiring_items.dart |
| **输出** | UseCase 类 |
| **验收标准** | 默认 3 天；排除 consumed 和 discarded 状态；结果按过期日期升序 |
| **依赖** | T-0019、T-0020、T-0018 |

### T-0024 实现 UpdateFoodStatus UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 UpdateFoodStatus 类，修改食材状态（消耗/丢弃） |
| **输入** | lib/domain/usecases/update_food_status.dart |
| **输出** | UseCase 类 |
| **验收标准** | 状态更新后数据库持久化；状态变为 consumed 或 discarded 后不再出现在首页列表 |
| **依赖** | T-0019、T-0020 |

### T-0025 实现 UpdateExpiryDate UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 UpdateExpiryDate 类，修改过期日期并触发状态重新计算 |
| **输入** | lib/domain/usecases/update_expiry_date.dart |
| **输出** | UseCase 类 |
| **验收标准** | 新日期晚于今天 → 状态变为 normal；新日期在今天 → 状态变为 expired |
| **依赖** | T-0019、T-0020、T-0018 |

### T-0026 实现 DeleteFoodItem UseCase

| 字段 | 内容 |
|------|------|
| **目标** | 创建 DeleteFoodItem 类，从数据库物理删除食材 |
| **输入** | lib/domain/usecases/delete_food_item.dart |
| **输出** | UseCase 类 |
| **验收标准** | 删除后数据库查不到该记录；已删除的 ID 可被新记录复用 |
| **依赖** | T-0019、T-0020 |

---

## 阶段 3：数据层实现

---

### T-0027 实现 FoodRepositoryImpl — 依赖注入

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodRepositoryImpl 类，接收 FoodItemDao 参数，实现 FoodRepository 接口 |
| **输入** | lib/data/repositories/food_repository_impl.dart |
| **输出** | Repository 实现骨架 |
| **验收标准** | 类签名正确，所有接口方法已覆写（可先抛 UnimplementedError） |
| **依赖** | T-0019、T-0020、T-0013 |

### T-0028 实现 FoodRepositoryImpl — 实体映射

| 字段 | 内容 |
|------|------|
| **目标** | 实现 _toEntity() 和 _toModel() 私有方法，完成 Model ↔ Entity 双向转换 |
| **输入** | food_repository_impl.dart（在 T-0027 基础上扩展） |
| **输出** | 实体映射逻辑 |
| **验收标准** | 转换后字段值完全一致（含日期、枚举索引）；双向转换可逆 |
| **依赖** | T-0027、T-0019、T-0017 |

### T-0029 实现 FoodRepositoryImpl — 查询方法

| 字段 | 内容 |
|------|------|
| **目标** | 实现 getAllFoodItems()、getFoodItemById() 方法 |
| **输入** | food_repository_impl.dart（在 T-0028 基础上扩展） |
| **输出** | 查询方法 |
| **验收标准** | 查询结果从 Model 转换为 Entity 后返回 |
| **依赖** | T-0028 |

### T-0030 实现 FoodRepositoryImpl — 写入方法

| 字段 | 内容 |
|------|------|
| **目标** | 实现 addFoodItem()、updateFoodStatus()、updateExpiryDate()、deleteFoodItem() 方法 |
| **输入** | food_repository_impl.dart（在 T-0029 基础上扩展） |
| **输出** | 写入方法 |
| **验收标准** | Entity 传入 → 转换为 Model → 调用 DAO 对应方法；数据持久化验证通过 |
| **依赖** | T-0029 |

### T-0031 配置全局 Provider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 app_providers.dart，提供 databaseProvider、foodItemDaoProvider、foodRepositoryProvider |
| **输入** | lib/providers/app_providers.dart |
| **输出** | 全局依赖注入 Provider |
| **验收标准** | ref.watch(foodRepositoryProvider) 返回 FoodRepository 实例，类型正确 |
| **依赖** | T-0010、T-0027 |

---

## 阶段 4：首页

---

### T-0032 实现 foodItemListProvider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FutureProvider，通过 GetFoodItems UseCase 获取全部食材 |
| **输入** | lib/features/home/providers/home_providers.dart |
| **输出** | 首页核心数据 Provider |
| **验收标准** | Provider 返回 AsyncValue<List<FoodItem>>；数据库为空时返回空列表 |
| **依赖** | T-0031、T-0022 |

### T-0033 实现今日过期派生 Provider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 todayExpiredProvider，从 foodItemListProvider 过滤出今天过期的食材 |
| **输入** | home_providers.dart（在 T-0032 基础上扩展） |
| **输出** | 派生 Provider |
| **验收标准** | 只包含 expiryDate == today 且 status 为 active 的食材 |
| **依赖** | T-0032、T-0018 |

### T-0034 实现即将过期派生 Provider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 expiringSoonProvider，从 foodItemListProvider 过滤出 1-3 天内过期的食材 |
| **输入** | home_providers.dart（在 T-0033 基础上扩展） |
| **输出** | 派生 Provider |
| **验收标准** | 只包含今天之后 1-3 天内过期且 status 为 active 的食材 |
| **依赖** | T-0032、T-0018 |

### T-0035 实现其它食材派生 Provider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 otherItemsProvider，从 foodItemListProvider 过滤出 3 天以后过期的食材 |
| **输入** | home_providers.dart（在 T-0034 基础上扩展） |
| **输出** | 派生 Provider |
| **验收标准** | 只包含 3 天以后过期且 status 为 active 的食材 |
| **依赖** | T-0032、T-0018 |

### T-0036 搭建 HomePage 骨架

| 字段 | 内容 |
|------|------|
| **目标** | 创建 HomePage 页面：Scaffold + AppBar（标题 + 设置齿轮图标）+ FAB + 列表区域 |
| **输入** | lib/features/home/pages/home_page.dart |
| **输出** | 首页骨架 |
| **验收标准** | 页面渲染，标题显示"FreshKeeper"，FAB 显示"+"，设置图标可点击 |
| **依赖** | T-0031 |

### T-0037 实现 FoodCard 组件

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodCard：展示食材名称、剩余天数、过期日期，根据状态显示颜色 |
| **输入** | lib/features/home/widgets/food_card.dart |
| **输出** | 食材卡片 Widget |
| **验收标准** | 卡片展示正常：正常=灰色、即将过期=黄色、过期=红色；剩余天数大字显示 |
| **依赖** | T-0005 |

### T-0038 实现 TodaySection 顶栏

| 字段 | 内容 |
|------|------|
| **目标** | 创建 TodaySection："今天吃这些"区域，展示今日过期食材列表 |
| **输入** | lib/features/home/widgets/today_section.dart |
| **输出** | 顶部建议区 Widget |
| **验收标准** | 有过期食材时展示卡片列表；无过期食材时隐藏该区域 |
| **依赖** | T-0033、T-0037 |

### T-0039 实现 FoodGroupSection 分组列表

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodGroupSection：分组标题 + 食材列表，支持自定义标题和颜色 |
| **输入** | lib/features/home/widgets/food_group_section.dart |
| **输出** | 分组列表 Widget |
| **验收标准** | 标题展示组名+数量；卡片展示在每个组内；组间有空行分隔 |
| **依赖** | T-0037 |

### T-0040 组装首页完整列表

| 字段 | 内容 |
|------|------|
| **目标** | 在 HomePage 中组合 TodaySection、FoodGroupSection（今日/即将/其它），实现完整列表 |
| **输入** | home_page.dart（在 T-0036 基础上扩展） |
| **输出** | 完整首页 |
| **验收标准** | 三个分组按序展示；今日过期 → 即将过期 → 其它；数据为空时隐藏对应组 |
| **依赖** | T-0038、T-0039 |

### T-0041 实现 EmptyState 空状态

| 字段 | 内容 |
|------|------|
| **目标** | 创建 EmptyState：冰箱空引导文案 + 图标 + 提示添加 |
| **输入** | lib/features/home/widgets/empty_state.dart |
| **输出** | 空状态 Widget |
| **验收标准** | 食材列表为空时显示空状态；有食材时隐藏 |
| **依赖** | T-0036 |

### T-0042 实现 LoadingState

| 字段 | 内容 |
|------|------|
| **目标** | 首页数据加载中显示 CircularProgressIndicator |
| **输入** | home_page.dart 内联实现 |
| **输出** | 加载状态 |
| **验收标准** | Provider 状态为 loading 时显示加载指示器；数据就绪后切换为列表 |
| **依赖** | T-0040 |

### T-0043 实现 ErrorState

| 字段 | 内容 |
|------|------|
| **目标** | 首页数据加载失败时显示错误信息 + 重试按钮 |
| **输入** | home_page.dart 内联实现 |
| **输出** | 错误状态 |
| **验收标准** | Provider 状态为 error 时显示错误页面；点击重试后重新加载 |
| **依赖** | T-0042 |

### T-0044 实现下拉刷新

| 字段 | 内容 |
|------|------|
| **目标** | 首页列表包裹 RefreshIndicator，下拉触发 foodItemListProvider 刷新 |
| **输入** | home_page.dart（在 T-0042 基础上扩展） |
| **输出** | 下拉刷新交互 |
| **验收标准** | 下拉触发刷新回调；刷新完成后 indicator 消失；列表更新 |
| **依赖** | T-0042 |

### T-0045 实现滑动标记 — 已吃掉

| 字段 | 内容 |
|------|------|
| **目标** | FoodCard 左滑显示勾选图标 + "已吃掉"；滑动后标记 consumed，弹出 SnackBar |
| **输入** | food_card.dart + home_page.dart |
| **输出** | Dismissible 动画 + 状态更新 |
| **验收标准** | 左滑触发状态更新；更新后卡片消失；SnackBar 提供撤销 |
| **依赖** | T-0037、T-0024 |

### T-0046 实现滑动标记 — 已丢弃

| 字段 | 内容 |
|------|------|
| **目标** | FoodCard 右滑显示垃圾桶图标 + "已丢弃"；滑动后标记 discarded，弹出 SnackBar |
| **输入** | food_card.dart + home_page.dart |
| **输出** | Dismissible 动画 + 状态更新 |
| **验收标准** | 右滑触发状态更新；更新后卡片消失；SnackBar 提供撤销 |
| **依赖** | T-0045 |

### T-0047 实现撤销操作

| 字段 | 内容 |
|------|------|
| **目标** | SnackBar 展示"已标记为已吃掉/已丢弃" + "撤销"按钮；点击撤销回退状态 |
| **输入** | home_page.dart |
| **输出** | 撤销交互 |
| **验收标准** | 5 秒内点击撤销 → 食材恢复状态并重新出现在列表原位置；超时后不可撤销 |
| **依赖** | T-0045、T-0046 |

### T-0048 首页 FAB 导航到新增页

| 字段 | 内容 |
|------|------|
| **目标** | FAB 点击后通过 GoRouter 导航到 /add |
| **输入** | home_page.dart |
| **输出** | 导航交互 |
| **验收标准** | 点击 FAB 后页面跳转到新增页 |
| **依赖** | T-0036、T-0006 |

### T-0049 首页设置图标导航

| 字段 | 内容 |
|------|------|
| **目标** | AppBar 设置图标点击后导航到 /settings |
| **输入** | home_page.dart |
| **输出** | 导航交互 |
| **验收标准** | 点击齿轮图标后页面跳转到设置页 |
| **依赖** | T-0036、T-0006 |

---

## 阶段 5：新增页

---

### T-0050 搭建 AddFoodPage 骨架

| 字段 | 内容 |
|------|------|
| **目标** | 创建 AddFoodPage：AppBar（返回 + "新增食材"）+ ScrollView + 保存按钮 |
| **输入** | lib/features/add_food/pages/add_food_page.dart |
| **输出** | 新增页骨架 |
| **验收标准** | 页面可滚动，AppBar 显示标题，保存按钮在底部 |
| **依赖** | T-0006 |

### T-0051 实现 AddFoodProvider — 表单状态

| 字段 | 内容 |
|------|------|
| **目标** | 创建 Notifier 管理表单状态：selectedFood、expiryDate、isCustom、searchQuery |
| **输入** | lib/features/add_food/providers/add_food_providers.dart |
| **输出** | 表单状态管理 |
| **验收标准** | 选中食材后状态更新；重置方法清除所有已选字段 |
| **依赖** | T-0031 |

### T-0052 实现 AddFoodProvider — 保存逻辑

| 字段 | 内容 |
|------|------|
| **目标** | 扩展 Notifier：validateAndSave() 校验后调用 AddFoodItem UseCase，完成后 invalidate |
| **输入** | add_food_providers.dart（在 T-0051 基础上扩展） |
| **输出** | 保存流程 |
| **验收标准** | 校验通过 → 调用 UseCase → invalidate foodItemListProvider → 返回首页 |
| **依赖** | T-0051、T-0021 |

### T-0053 实现默认过期日期

| 字段 | 内容 |
|------|------|
| **目标** | 新增页打开时默认过期日期为今天 +7 天 |
| **输入** | add_food_providers.dart |
| **输出** | 默认日期逻辑 |
| **验收标准** | 页面打开时默认显示 7 天后；选择食材后自动更新为该食材的默认保质期 |
| **依赖** | T-0052、T-0017 |

### T-0054 实现 FoodTagGrid 组件

| 字段 | 内容 |
|------|------|
| **目标** | 创建 FoodTagGrid：按分类分组展示预置食材标签，点击选中/取消 |
| **输入** | lib/features/add_food/widgets/food_tag_grid.dart |
| **输出** | 食材标签网格 |
| **验收标准** | 标签按分类分组展示；点击选中高亮；再次点击取消选中 |
| **依赖** | T-0017、T-0005 |

### T-0055 实现分类标题

| 字段 | 内容 |
|------|------|
| **目标** | 每个食材分类组添加分类标题（蔬菜、水果、乳制品等）+ 分隔线 |
| **输入** | food_tag_grid.dart（在 T-0054 基础上扩展） |
| **输出** | 分类分组 |
| **验收标准** | 标题在每组上方；顺序与预设食材定义一致 |
| **依赖** | T-0054 |

### T-0056 实现搜索过滤

| 字段 | 内容 |
|------|------|
| **目标** | 搜索框输入文字后实时过滤预置食材列表 |
| **输入** | lib/features/add_food/widgets/search_bar.dart |
| **输出** | 搜索组件 |
| **验收标准** | 输入文字后标签列表过滤；清空输入后恢复全部；匹配不区分大小写 |
| **依赖** | T-0050 |

### T-0057 实现自定义食材输入

| 字段 | 内容 |
|------|------|
| **目标** | 标签列表末尾添加"自定义"标签；点击后弹出输入框 |
| **输入** | food_tag_grid.dart（在 T-0055 基础上扩展） |
| **输出** | 自定义输入 |
| **验收标准** | 选择自定义后显示 TextField；输入后作为食材名称；支持 emoji 手动输入 |
| **依赖** | T-0054 |

### T-0058 实现 ExpiryDatePicker

| 字段 | 内容 |
|------|------|
| **目标** | 创建日期选择区域：显示当前选中日期 + 点击弹出系统 DatePicker |
| **输入** | lib/features/add_food/widgets/date_picker_row.dart |
| **输出** | 日期选择组件 |
| **验收标准** | 点击日期文本弹出 DatePicker；选中后日期更新显示；最小可选日期为今天 |
| **依赖** | T-0050 |

### T-0059 实现快捷保质期按钮

| 字段 | 内容 |
|------|------|
| **目标** | 创建 ExpiryQuickButtons：3 天 / 7 天 / 14 天 / 30 天，点击自动计算过期日期 |
| **输入** | lib/features/add_food/widgets/expiry_quick_buttons.dart |
| **输出** | 快捷选择组件 |
| **验收标准** | 点击"3 天" → 过期日期设为今天+3；选中状态高亮；再次点击取消 |
| **依赖** | T-0058 |

### T-0060 实现保存按钮

| 字段 | 内容 |
|------|------|
| **目标** | 保存按钮：未选择食材时禁用；点击后调用保存逻辑，成功后弹出 SnackBar 并返回首页 |
| **输入** | add_food_page.dart（在 T-0050 基础上扩展） |
| **输出** | 保存流程 |
| **验收标准** | 未选食材时按钮灰色不可点击；选择后可点击；保存成功返回首页+SnackBar；保存失败展示错误 |
| **依赖** | T-0052、T-0054、T-0058 |

### T-0061 实现返回确认

| 字段 | 内容 |
|------|------|
| **目标** | 返回按钮：若已填写内容，弹出确认对话框"丢弃已填写的内容？" |
| **输入** | add_food_page.dart（在 T-0060 基础上扩展） |
| **输出** | 返回确认交互 |
| **验收标准** | 未填写 → 直接返回；已填写 → 弹窗确认；确认丢弃 → 返回；取消 → 留在页内 |
| **依赖** | T-0060 |

### T-0062 集成新增页到路由

| 字段 | 内容 |
|------|------|
| **目标** | 确保首页 FAB 导航到新增页、新增页保存后返回首页、所有状态正确 |
| **输入** | router.dart |
| **输出** | 完整导航闭环 |
| **验收标准** | 首页→新增页→保存→首页，全链路状态一致 |
| **依赖** | T-0060、T-0048 |

---

## 阶段 6：详情页

---

### T-0063 搭建 DetailPage 骨架

| 字段 | 内容 |
|------|------|
| **目标** | 创建 DetailPage：接收 foodId 参数，空 AppBar + 内容区域 + 底部操作按钮 |
| **输入** | lib/features/detail/pages/detail_page.dart |
| **输出** | 详情页骨架 |
| **验收标准** | 页面渲染；AppBar 显示返回按钮；内容区域和按钮区域布局正确 |
| **依赖** | T-0006 |

### T-0064 实现 DetailProvider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 foodDetailProvider(foodId)，通过 GetFoodItems UseCase 获取单个食材 |
| **输入** | lib/features/detail/providers/detail_providers.dart |
| **输出** | 单个食材 Provider |
| **验收标准** | 传入 ID 返回对应食材；ID 不存在返回 null |
| **依赖** | T-0031、T-0022 |

### T-0065 实现 FoodEmojiDisplay

| 字段 | 内容 |
|------|------|
| **目标** | 食材 emoji 大图展示区域，页面顶部居中 |
| **输入** | lib/features/detail/widgets/food_emoji_display.dart |
| **输出** | Emoji 展示组件 |
| **验收标准** | Emoji 居中展示，字号不小于 64dp |
| **依赖** | T-0063 |

### T-0066 实现食材信息展示

| 字段 | 内容 |
|------|------|
| **目标** | 展示食材名称（大字）、状态文字（颜色标识）、录入日期、过期日期 |
| **输入** | lib/features/detail/widgets/food_info_section.dart |
| **输出** | 信息展示组件 |
| **验收标准** | 名称大字展示；状态文字颜色正确（红/黄/灰）；日期格式"YYYY 年 MM 月 DD 日" |
| **依赖** | T-0065、T-0018 |

### T-0067 实现已吃掉按钮

| 字段 | 内容 |
|------|------|
| **目标** | 主要操作按钮"🍽️ 已经吃掉"；点击后更新状态为 consumed，返回首页 |
| **输入** | lib/features/detail/widgets/action_buttons.dart |
| **输出** | 已吃掉交互 |
| **验收标准** | 按钮显示正确；点击后更新状态；返回首页；首页列表刷新 |
| **依赖** | T-0064、T-0024 |

### T-0068 实现已丢弃按钮

| 字段 | 内容 |
|------|------|
| **目标** | 次要操作按钮"🗑️ 已经扔掉"；点击后更新状态为 discarded，返回首页 |
| **输入** | action_buttons.dart（在 T-0067 基础上扩展） |
| **输出** | 已丢弃交互 |
| **验收标准** | 按钮显示正确；点击后更新状态；返回首页；首页列表刷新 |
| **依赖** | T-0067 |

### T-0069 实现修改过期日期

| 字段 | 内容 |
|------|------|
| **目标** | 底部文字链接"修改过期日期"；点击弹出 DatePicker；确认后更新日期并刷新 |
| **输入** | detail_page.dart |
| **输出** | 日期修改交互 |
| **验收标准** | 点击弹出 DatePicker；确认后日期更新；状态重新计算；首页刷新 |
| **依赖** | T-0064、T-0025 |

### T-0070 集成详情页导航

| 字段 | 内容 |
|------|------|
| **目标** | 首页点击食材卡片导航到详情页；详情页返回后首页列表保持最新 |
| **输入** | food_card.dart + router.dart |
| **输出** | 完整导航闭环 |
| **验收标准** | 点击卡片 → 详情页；详情页操作后返回 → 首页列表已反映变更 |
| **依赖** | T-0067、T-0068、T-0037 |

---

## 阶段 7：设置页

---

### T-0071 搭建 SettingsPage 骨架

| 字段 | 内容 |
|------|------|
| **目标** | 创建 SettingsPage：AppBar（返回 + "设置"）+ 分组列表 |
| **输入** | lib/features/settings/pages/settings_page.dart |
| **输出** | 设置页骨架 |
| **验收标准** | 页面渲染，AppBar 显示标题 |
| **依赖** | T-0006 |

### T-0072 实现 SettingsProvider — 持久化

| 字段 | 内容 |
|------|------|
| **目标** | 创建 SettingsProvider，通过 SharedPreferences 读写：reminderTime、advanceDays、notificationEnabled |
| **输入** | lib/features/settings/providers/settings_providers.dart |
| **输出** | 设置状态管理 |
| **验收标准** | 读取有默认值；写入即时持久化；重启 App 后读取已保存值 |
| **依赖** | T-0031 |

### T-0073 实现提醒时间设置

| 字段 | 内容 |
|------|------|
| **目标** | 提醒时间行：显示当前设定时间 + 点击弹出 TimePicker |
| **输入** | lib/features/settings/widgets/setting_tile.dart |
| **输出** | 时间选择设置项 |
| **验收标准** | 显示"提醒时间：08:00"；点击弹出 TimePicker；确认后时间和显示更新 |
| **依赖** | T-0072 |

### T-0074 实现提前提醒天数设置

| 字段 | 内容 |
|------|------|
| **目标** | 提前天数行：显示当前设定天数（1/2/3）+ SegmentedButton 切换 |
| **输入** | setting_tile.dart（在 T-0073 基础上扩展） |
| **输出** | 天数选择设置项 |
| **验收标准** | 默认 2 天；切换后值即时持久化 |
| **依赖** | T-0073 |

### T-0075 实现通知开关

| 字段 | 内容 |
|------|------|
| **目标** | 通知开关行：Switch 控件，开启/关闭所有通知 |
| **输入** | setting_tile.dart（在 T-0074 基础上扩展） |
| **输出** | 通知开关 |
| **验收标准** | 关闭后不发送任何通知；开启后按设定规则发送 |
| **依赖** | T-0074 |

### T-0076 实现关于信息

| 字段 | 内容 |
|------|------|
| **目标** | 关于区域：App 名称、版本号（从 package_info 获取）、版权信息 |
| **输入** | settings_page.dart |
| **输出** | 关于信息展示 |
| **验收标准** | 显示 App 名称 "FreshKeeper" + 当前版本号 |
| **依赖** | T-0071 |

---

## 阶段 8：通知系统

---

### T-0077 初始化 NotificationService

| 字段 | 内容 |
|------|------|
| **目标** | 创建 NotificationService 类，初始化 flutter_local_notifications 插件 |
| **输入** | lib/notification/notification_service.dart |
| **输出** | 通知服务初始化 |
| **验收标准** | App 启动时初始化成功，无异常 |
| **依赖** | T-0003 |

### T-0078 配置 Android 通知渠道

| 字段 | 内容 |
|------|------|
| **目标** | 创建 Android 通知渠道："食材过期提醒"，channel ID 为 freshkeeper_expiry |
| **输入** | notification_service.dart（在 T-0077 基础上扩展） |
| **输出** | Android 通知渠道 |
| **验收标准** | Android 通知渠道创建成功；渠道名称/描述在系统设置中可查看 |
| **依赖** | T-0077 |

### T-0079 配置 iOS 通知权限

| 字段 | 内容 |
|------|------|
| **目标** | 配置 iOS 通知请求：request permissions on iOS，显示通知弹窗 |
| **输入** | notification_service.dart（在 T-0078 基础上扩展） |
| **输出** | iOS 通知权限 |
| **验收标准** | iOS 启动时弹出通知权限请求弹窗 |
| **依赖** | T-0077 |

### T-0080 实现通知内容格式化

| 字段 | 内容 |
|------|------|
| **目标** | 格式化通知内容：今日过期食材列出名称（最多 3 个）；即将过期显示数量 |
| **输入** | notification_service.dart |
| **输出** | 通知文案生成函数 |
| **验收标准** | "🥬 菠菜、牛奶今天过期"；"🥬 有 2 样食材即将过期"；同时满足则合并 |
| **依赖** | T-0077 |

### T-0081 实现每日检查逻辑

| 字段 | 内容 |
|------|------|
| **目标** | 实现 checkAndNotify()：查询当天过期和即将过期食材，按规则发送通知 |
| **输入** | notification_service.dart（在 T-0080 基础上扩展） |
| **输出** | 检查通知逻辑 |
| **验收标准** | 查询数据库 → 判断是否需要通知 → 调用 sendNotification；无需通知则不发送 |
| **依赖** | T-0080、T-0031 |

### T-0082 实现通知去重

| 字段 | 内容 |
|------|------|
| **目标** | 每天同一类型通知只发送一次；用户已打开 App 不发送 |
| **输入** | notification_service.dart（在 T-0081 基础上扩展） |
| **输出** | 去重逻辑 |
| **验收标准** | 同一 type 一天内只发一次；去重标志存储在 SharedPreferences |
| **依赖** | T-0081、T-0072 |

### T-0083 配置 WorkManager 后台任务

| 字段 | 内容 |
|------|------|
| **目标** | 注册 WorkManager 周期性任务，每日在用户设定时间执行检查 |
| **输入** | lib/notification/background_check.dart |
| **输出** | 后台周期性任务 |
| **验收标准** | 任务注册成功；到设定时间后触发回调（可通过日志验证） |
| **依赖** | T-0081、T-0072 |

### T-0084 配置 iOS 后台刷新

| 字段 | 内容 |
|------|------|
| **目标** | 配置 iOS BGTaskScheduler，注册每日后台刷新任务 |
| **输入** | background_check.dart（在 T-0083 基础上扩展） |
| **输出** | iOS 后台任务 |
| **验收标准** | iOS 后台任务注册成功 |
| **依赖** | T-0083 |

### T-0085 实现通知 Provider

| 字段 | 内容 |
|------|------|
| **目标** | 创建 notificationProvider，管理通知权限状态和开关状态 |
| **输入** | lib/notification/notification_providers.dart |
| **输出** | 通知状态 Provider |
| **验收标准** | Provider 返回通知权限状态（granted/denied/notDetermined） |
| **依赖** | T-0077 |

### T-0086 通知与设置联动

| 字段 | 内容 |
|------|------|
| **目标** | 设置页修改提醒时间或提前天数后，通知系统实时生效 |
| **输入** | notification_service.dart + settings_providers.dart |
| **输出** | 设置-通知联动 |
| **验收标准** | 修改提醒时间 → 重新注册 WorkManager 任务；关闭通知 → 取消待发送通知 |
| **依赖** | T-0083、T-0075 |

---

## 阶段 9：启动与初始化

---

### T-0087 创建 main.dart 入口

| 字段 | 内容 |
|------|------|
| **目标** | 创建 main.dart：ProviderScope 包裹 + WidgetsFlutterBinding + 初始化流程 |
| **输入** | lib/main.dart |
| **输出** | App 入口文件 |
| **验收标准** | App 启动时按序执行：初始化绑定 → 初始化通知 → 初始化数据库 → runApp |
| **依赖** | T-005、T-0077 |

### T-0088 实现 App 启动数据迁移

| 字段 | 内容 |
|------|------|
| **目标** | App 启动时检查数据库 schema 版本，必要时执行迁移 |
| **输入** | app_database.dart |
| **输出** | 数据库迁移逻辑 |
| **验收标准** | v1 启动无迁移动作 |
| **依赖** | T-0010 |

### T-0089 实现启动时状态刷新

| 字段 | 内容 |
|------|------|
| **目标** | App 启动时刷新食材状态：检查过期状态，normal→expiring→expired 自动流转 |
| **输入** | main.dart + food_repository_impl.dart |
| **输出** | 状态自动刷新 |
| **验收标准** | 启动后所有已过期的食材状态变为 expired；即将过期的变为 expiring |
| **依赖** | T-0087、T-0030 |

### T-0090 搭建 AppShell

| 字段 | 内容 |
|------|------|
| **目标** | 创建 App 类：MaterialApp.router 配置主题、路由、标题 |
| **输入** | lib/app/app.dart |
| **输出** | App 根组件 |
| **验收标准** | App 使用 M3 主题 + GoRouter + 正确标题 |
| **依赖** | T-0005、T-0006 |

---

## 阶段 10：打磨与发布

---

### T-0091 配置 Android 构建

| 字段 | 内容 |
|------|------|
| **目标** | 配置 Android：包名、最低 SDK 版本、应用名、权限声明（通知权限） |
| **输入** | android/app/build.gradle、AndroidManifest.xml |
| **输出** | Android 构建配置 |
| **验收标准** | flutter build apk --debug 成功 |
| **依赖** | T-0001 |

### T-0092 配置 iOS 构建

| 字段 | 内容 |
|------|------|
| **目标** | 配置 iOS：Bundle ID、最低部署版本、通知 Capability |
| **输入** | ios/Runner.xcodeproj、Info.plist |
| **输出** | iOS 构建配置 |
| **验收标准** | flutter build ios --debug --no-codesign 成功 |
| **依赖** | T-0001 |

### T-0093 配置应用图标

| 字段 | 内容 |
|------|------|
| **目标** | 设计并配置 App 图标，使用 flutter_launcher_icons 生成各分辨率 |
| **输入** | assets/icon.png + pubspec.yaml |
| **输出** | Android + iOS 各分辨率图标 |
| **验收标准** | 安装 App 后图标显示正确 |
| **依赖** | T-0091、T-0092、T-0003 |

### T-0094 配置应用名

| 字段 | 内容 |
|------|------|
| **目标** | Android：修改 strings.xml 中 app_name；iOS：修改 Info.plist 中 CFBundleDisplayName |
| **输入** | AndroidManifest.xml、Info.plist |
| **输出** | 应用名称配置 |
| **验收标准** | 安装后桌面显示 App 名称为 "FreshKeeper" |
| **依赖** | T-0093 |

### T-0095 实现动画过渡

| 字段 | 内容 |
|------|------|
| **目标** | 页面跳转使用 M3 默认过渡动画；列表项添加淡入动画 |
| **输入** | home_page.dart、food_card.dart |
| **输出** | 动画效果 |
| **验收标准** | 页面切换有滑动过渡；列表项出现有淡入效果 |
| **依赖** | T-0040 |

### T-0096 实现操作反馈

| 字段 | 内容 |
|------|------|
| **目标** | 所有用户操作有视觉/触觉反馈：保存成功 SnackBar、滑动删除振动反馈 |
| **输入** | HapticFeedback 集成到 add_food_page、food_card |
| **输出** | 操作反馈 |
| **验收标准** | 保存后展示 SnackBar；滑动时手机振动 |
| **依赖** | T-0047、T-0060 |

### T-0097 实现暗色模式适配

| 字段 | 内容 |
|------|------|
| **目标** | 主题支持亮/暗模式切换，跟随系统设置；暗色模式下配色正确 |
| **输入** | app_theme.dart |
| **输出** | 暗色模式 |
| **验收标准** | 系统切换暗色模式 → App 自动切换；所有页面在暗色模式下可读 |
| **依赖** | T-0005 |

### T-0098 错误边界处理

| 字段 | 内容 |
|------|------|
| **目标** | 全局错误捕获：FlutterError.onError 记录日志；runZonedGuarded 捕获未处理异常 |
| **输入** | main.dart |
| **输出** | 错误边界 |
| **验收标准** | 未处理异常不导致 App 崩溃；错误信息记录到日志 |
| **依赖** | T-0087 |

### T-0099 日志系统

| 字段 | 内容 |
|------|------|
| **目标** | 集成开发期日志：debug 级别记录 Provider 状态变更、UseCase 调用 |
| **输入** | core/utils/logger.dart |
| **输出** | 日志工具 |
| **验收标准** | debug 模式下日志输出；release 模式下日志不输出 |
| **依赖** | T-0002 |

### T-0100 无障碍适配

| 字段 | 内容 |
|------|------|
| **目标** | 所有交互组件添加 Semantics 标签；滑动操作提供描述性标签 |
| **输入** | food_card.dart、food_tag_grid.dart、action_buttons.dart |
| **输出** | 无障碍属性 |
| **验收标准** | TalkBack 可朗读所有交互元素；触摸目标不小于 48x48 |
| **依赖** | T-0045、T-0054、T-0067 |

### T-0101 Android 发布配置

| 字段 | 内容 |
|------|------|
| **目标** | 配置 Android 签名、应用签名密钥、build.gradle release 配置 |
| **输入** | android/ |
| **输出** | 可发布的 Android APK/AAB |
| **验收标准** | flutter build appbundle --release 成功 |
| **依赖** | T-0091 |

### T-0102 iOS 发布配置

| 字段 | 内容 |
|------|------|
| **目标** | 配置 iOS 证书、描述文件、Archive 配置 |
| **输入** | ios/ |
| **输出** | 可发布的 iOS Archive |
| **验收标准** | xcodebuild archive 成功 |
| **依赖** | T-0092 |

### T-0103 全链路回归测试

| 字段 | 内容 |
|------|------|
| **目标** | 走通全部用户流程：录入→查看→过期→通知→标记消耗 |
| **输入** | 已完成的所有页面和功能 |
| **输出** | 回归测试通过报告 |
| **验收标准** | 所有 User Story 状态为 Done；无 P0 级别 Bug |
| **依赖** | T-0101、T-0102 |

### T-0104 性能检查

| 字段 | 内容 |
|------|------|
| **目标** | 检查列表滚动性能、内存泄漏、数据库查询耗时 |
| **输入** | Flutter DevTools Profile |
| **输出** | 性能报告 |
| **验收标准** | 列表滚动 60fps；无内存泄漏；数据库查询 < 10ms |
| **依赖** | T-0103 |

### T-0105 构建发布版本

| 字段 | 内容 |
|------|------|
| **目标** | 构建 release 版本 APK/AAB/IPA |
| **输入** | 项目代码 |
| **输出** | 发布产物 |
| **验收标准** | 产物可正常安装到设备；核心功能全部可用 |
| **依赖** | T-0104 |

---

## 阶段 11：后续迭代（v1.1+）

---

### T-0106 实现历史记录

| 字段 | 内容 |
|------|------|
| **目标** | 新增"已消耗/已丢弃"食材查看页面，可查看历史记录 |
| **输入** | Architecture.md v1.1 规划 |
| **输出** | 历史记录页面 |
| **验收标准** | 展示已操作的食材列表；按时间倒序排列 |
| **依赖** | 所有 P0 任务 |

### T-0107 实现食材编辑

| 字段 | 内容 |
|------|------|
| **目标** | 详情页增加编辑功能：修改食材名称、分类 |
| **输入** | Architecture.md v1.1 规划 |
| **输出** | 编辑交互 |
| **验收标准** | 编辑后保存更新；首页列表刷新 |
| **依赖** | T-0069 |

### T-0108 实现搜索/筛选

| 字段 | 内容 |
|------|------|
| **目标** | 首页增加搜索或筛选入口：按名称搜索、按分类筛选 |
| **输入** | Architecture.md v1.1 规划 |
| **输出** | 搜索筛选功能 |
| **验收标准** | 搜索后列表过滤；切换分类后只展示该分类食材 |
| **依赖** | T-0040 |

### T-0109 实现批量录入

| 字段 | 内容 |
|------|------|
| **目标** | 新增页支持连续添加：保存后不清除已选食材，继续添加 |
| **输入** | Architecture.md v1.2 规划 |
| **输出** | 批量录入模式 |
| **验收标准** | 保存后不清白页面；点击"完成"才返回首页 |
| **依赖** | T-0062 |

### T-0110 实现桌面小组件

| 字段 | 内容 |
|------|------|
| **目标** | Android/iOS 桌面 Widget：展示今日过期食材 |
| **输入** | Architecture.md v1.2 规划 |
| **输出** | 桌面小组件 |
| **验收标准** | Widget 显示当日过期食材；点击打开 App 首页 |
| **依赖** | T-0033 |

### T-0111 实现统计模块

| 字段 | 内容 |
|------|------|
| **目标** | 月度浪费统计：丢弃食材数量 vs 消耗食材数量 |
| **输入** | Architecture.md v1.2 规划 |
| **输出** | 统计页面 |
| **验收标准** | 显示月度比率图表 |
| **依赖** | T-0106 |

### T-0112 实现多语言支持

| 字段 | 内容 |
|------|------|
| **目标** | 英文/日文国际化支持，自动跟随系统语言 |
| **输入** | Architecture.md 远期规划 |
| **输出** | i18n 配置 |
| **验收标准** | 切换系统语言后 App 界面语言随动 |
| **依赖** | T-0105 |
