library;
import "package:drift/drift.dart";

class FoodItems extends Table {
  IntColumn get id => integer().autoIncrement()();

  /// 食材名称，如"牛奶"
  TextColumn get name => text()();

  /// 分类，如"乳制品"
  TextColumn get category => text()();

  /// 对应 emoji，如"🥛"
  TextColumn get emoji => text()();

  /// 过期日期
  DateTimeColumn get expiryDate => dateTime()();

  /// 录入时间
  DateTimeColumn get createdAt => dateTime()();

  /// 状态索引：0=normal, 1=expiring, 2=expired, 3=consumed, 4=discarded
  IntColumn get statusIndex => integer().withDefault(const Constant(0))();

  /// 购买日期（可选）
  DateTimeColumn get purchaseDate => dateTime()();

  /// 数量（可选）
  IntColumn get quantity => integer()();

  /// 存放位置，如"冰箱冷藏层"（可选）
  TextColumn get location => text()();

  /// 备注（可选）
  TextColumn get remark => text()();

  @override
  Set<Column> get primaryKey => {id};
}
