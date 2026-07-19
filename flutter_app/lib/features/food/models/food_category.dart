library;
enum FoodCategory {
  vegetables("蔬菜"),
  fruits("水果"),
  dairy("乳制品"),
  meat("肉类"),
  eggs("蛋类"),
  tofu("豆制品"),
  staple("主食"),
  beverage("饮品"),
  condiment("调味品"),
  other("其他");

  final String label;
  const FoodCategory(this.label);

  static FoodCategory fromLabel(String label) {
    return FoodCategory.values.firstWhere((c) => c.label == label, orElse: () => FoodCategory.other);
  }
}
