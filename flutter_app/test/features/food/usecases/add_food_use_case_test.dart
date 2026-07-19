library;
import "package:flutter_test/flutter_test.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";
import "package:flutter_app/features/food/repository/food_repository.dart";
import "package:flutter_app/features/food/usecases/add_food_use_case.dart";

class _MockRepository implements FoodRepository {
  FoodItem? lastAdded;
  @override Future<int> addFoodItem(FoodItem item) async {
    lastAdded = item;
    return 1;
  }
  @override Future<List<FoodItem>> getAllFoodItems() async => [];
  @override Future<FoodItem?> getFoodItemById(int id) async => null;
  @override Future<void> updateFoodStatus(int id, FoodStatus status) async {}
  @override Future<void> updateExpiryDate(int id, DateTime newDate) async {}
  @override Future<void> updateFoodItem(int id, FoodItem item) async {}
  @override Future<void> deleteFoodItem(int id) async {}
}

void main() {
  late _MockRepository mockRepo;
  late AddFoodUseCase useCase;

  setUp(() {
    mockRepo = _MockRepository();
    useCase = AddFoodUseCase(mockRepo);
  });

  group("AddFoodUseCase", () {
    test("正常添加食材", () async {
      final result = await useCase.call(
        name: "牛奶",
        category: "乳制品",
        emoji: "🥛",
        expiryDate: DateTime(2026, 7, 26),
      );
      expect(result.name, "牛奶");
      expect(result.id, 1);
      expect(result.purchaseDate, isNotNull);
      expect(result.quantity, 1);
    });

    test("空名称抛出异常", () async {
      expect(
        () => useCase.call(
          name: "  ",
          category: "其他",
          emoji: "🥘",
          expiryDate: DateTime(2026, 7, 26),
        ),
        throwsArgumentError,
      );
    });

    test("自定义数量生效", () async {
      final result = await useCase.call(
        name: "鸡蛋",
        category: "蛋类",
        emoji: "🥚",
        expiryDate: DateTime(2026, 8, 1),
        quantity: 10,
      );
      expect(result.quantity, 10);
    });
  });
}
