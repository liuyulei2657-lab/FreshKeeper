library;
import "dart:io";
import "package:drift/drift.dart";
import "package:drift/native.dart";
import "package:path_provider/path_provider.dart";
import "package:path/path.dart" as p;
import "tables/food_item_table.dart";
import "daos/food_item_dao.dart";

part "app_database.g.dart";

@DriftDatabase(tables: [FoodItems], daos: [FoodItemDao])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onUpgrade: (m, from, to) async {
        if (from == 1) {
          await m.addColumn(foodItems, foodItems.purchaseDate);
          await m.addColumn(foodItems, foodItems.quantity);
          await m.addColumn(foodItems, foodItems.location);
          await m.addColumn(foodItems, foodItems.remark);
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, "freshkeeper.db"));
    return NativeDatabase(file);
  });
}
