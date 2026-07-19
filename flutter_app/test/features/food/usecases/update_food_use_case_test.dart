library;
import "package:flutter_test/flutter_test.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/usecases/update_food_use_case.dart";

class _MockRepo implements FoodRepository {
  FoodItem? storedItem;
  @override Future<List<FoodItem>> getAllFoodItems() async => [];
  @override Future<FoodItem?> getFoodItemById(int id) async => storedItem;
  @override Future<int> addFoodItem(FoodItem item) async { storedItem = item; return item.id ?? 1; }
  @override Future<void> updateFoodStatus(int id, FoodStatus status) async {}
  @override Future<void> updateExpiryDate(int id, DateTime newDate) async {}
  @override Future<void> updateFoodItem(int id, FoodItem item) async { storedItem = item; }
  @override Future<void> deleteFoodItem(int id) async {}
}

void main() {
  late _MockRepo mock;
  late UpdateFoodUseCase useCase;

  setUp(() {
    mock = _MockRepo();
    useCase = UpdateFoodUseCase(mock);
    mock.storedItem = FoodItem(
      id: 1, name: "牛奶", category: "乳制品", emoji: "🥛",
      expiryDate: DateTime(2026, 7, 26), createdAt: DateTime.now(),
    );
  });

  group("UpdateFoodUseCase", () {
    test("修改名称和数量", () async {
      await useCase.call(id: 1, name: "鲜牛奶", quantity: 2);
      expect(mock.storedItem!.name, "鲜牛奶");
      expect(mock.storedItem!.quantity, 2);
    });

    test("修改过期日期", () async {
      final newDate = DateTime(2026, 8, 1);
      await useCase.call(id: 1, expiryDate: newDate);
      expect(mock.storedItem!.expiryDate, newDate);
    });

    test("修改位置和备注", () async {
      await useCase.call(id: 1, location: "冷藏层", remark: "尽快喝掉");
      expect(mock.storedItem!.location, "冷藏层");
      expect(mock.storedItem!.remark, "尽快喝掉");
    });

    test("不存在的 ID 抛出 StateError", () async {
      mock.storedItem = null;
      expect(() => useCase.call(id: 999), throwsStateError);
    });
  });
}
