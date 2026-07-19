library;
import "package:drift/drift.dart";

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
