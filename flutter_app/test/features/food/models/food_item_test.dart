
library;

import "package:flutter_test/flutter_test.dart";
import "package:flutter_app/features/food/models/food_item.dart";
import "package:flutter_app/features/food/models/food_status.dart";

void main() {
  group("FoodItem", () {
    const baseDate = DateTime(2026, 7, 19);
    const laterDate = DateTime(2026, 7, 26);

    test("创建最小实体（仅必填字段）", () {
      final item = FoodItem(
        name: "牛奶",
        category: "乳制品",
        emoji: "🥛",
        expiryDate: laterDate,
        createdAt: baseDate,
      );

      expect(item.id, isNull);
      expect(item.name, "牛奶");
      expect(item.category, "乳制品");
      expect(item.emoji, "🥛");
      expect(item.expiryDate, laterDate);
      expect(item.createdAt, baseDate);
      expect(item.status, FoodStatus.normal);
      expect(item.purchaseDate, isNull);
      expect(item.quantity, isNull);
      expect(item.location, isNull);
      expect(item.remark, isNull);
    });

    test("创建完整实体（含可选字段）", () {
      final item = FoodItem(
        id: 1,
        name: "菠菜",
        category: "蔬菜",
        emoji: "🥬",
        expiryDate: baseDate,
        createdAt: baseDate,
        status: FoodStatus.expiring,
        purchaseDate: baseDate,
        quantity: 2,
        location: "冷藏层",
        remark: "周末前吃掉",
      );

      expect(item.id, 1);
      expect(item.purchaseDate, baseDate);
      expect(item.quantity, 2);
      expect(item.location, "冷藏层");
      expect(item.remark, "周末前吃掉");
    });

    test("copyWith 更新部分字段", () {
      final original = FoodItem(
        name: "牛奶",
        category: "乳制品",
        emoji: "🥛",
        expiryDate: laterDate,
        createdAt: baseDate,
      );

      final updated = original.copyWith(
        quantity: 3,
        location: "冷冻层",
      );

      expect(updated.name, "牛奶");
      expect(updated.quantity, 3);
      expect(updated.location, "冷冻层");
      expect(updated.remark, isNull);
      expect(updated.id, isNull);
    });

    test("copyWith 不传参时字段不变", () {
      final original = FoodItem(
        name: "鸡蛋",
        category: "蛋类",
        emoji: "🥚",
        expiryDate: baseDate,
        createdAt: baseDate,
        quantity: 10,
        remark: "土鸡蛋",
      );

      final copied = original.copyWith();

      expect(copied.name, "鸡蛋");
      expect(copied.quantity, 10);
      expect(copied.remark, "土鸡蛋");
      expect(copied.purchaseDate, isNull);
    });

    test("isActive 排除 consumed 和 discarded", () {
      final normal = FoodItem(
        name: "苹果", category: "水果", emoji: "🍎",
        expiryDate: laterDate, createdAt: baseDate,
      );
      expect(normal.status.isActive, isTrue);

      final consumed = normal.copyWith(status: FoodStatus.consumed);
      expect(consumed.status.isActive, isFalse);

      final discarded = normal.copyWith(status: FoodStatus.discarded);
      expect(discarded.status.isActive, isFalse);
    });
  });
}
