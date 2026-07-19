library;
enum FoodStatus {
  normal(0),
  expiring(1),
  expired(2),
  consumed(3),
  discarded(4);

  final int index;
  const FoodStatus(this.index);

  bool get isActive => this != consumed && this != discarded;

  static FoodStatus fromIndex(int index) {
    return FoodStatus.values.firstWhere((s) => s.index == index, orElse: () => FoodStatus.normal);
  }
}
