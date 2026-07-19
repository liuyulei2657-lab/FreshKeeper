library;
import "../constants/preset_foods.dart";

String emojiForFood(String foodName) {
  final match = presetFoods.where((f) => f.name == foodName);
  if (match.isNotEmpty) return match.first.emoji;
  return "🥘";
}

String emojiForCategory(String category) {
  switch (category) {
    case "蔬菜": return "🥬";
    case "水果": return "🍎";
    case "乳制品": return "🥛";
    case "肉类": return "🥩";
    case "蛋类": return "🥚";
    case "豆制品": return "🫘";
    case "主食": return "🍞";
    case "饮品": return "🧃";
    case "调味品": return "🫙";
    default: return "🥘";
  }
}
