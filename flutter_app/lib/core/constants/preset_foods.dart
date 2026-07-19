library;
class PresetFood {
  final String name;
  final String category;
  final String emoji;
  final int defaultDays;
  const PresetFood(this.name, this.category, this.emoji, this.defaultDays);
}

final List<PresetFood> presetFoods = [
  // 蔬菜
  PresetFood("白菜", "蔬菜", "🥬", 7),
  PresetFood("菠菜", "蔬菜", "🥬", 5),
  PresetFood("番茄", "蔬菜", "🍅", 7),
  PresetFood("黄瓜", "蔬菜", "🥒", 5),
  PresetFood("生菜", "蔬菜", "🥬", 4),
  PresetFood("西兰花", "蔬菜", "🥦", 7),
  PresetFood("胡萝卜", "蔬菜", "🥕", 14),
  PresetFood("土豆", "蔬菜", "🥔", 30),
  PresetFood("洋葱", "蔬菜", "🧅", 30),
  PresetFood("大葱", "蔬菜", "🧅", 7),
  PresetFood("生姜", "蔬菜", "🫚", 30),
  PresetFood("大蒜", "蔬菜", "🧄", 30),
  PresetFood("茄子", "蔬菜", "🍆", 5),
  PresetFood("玉米", "蔬菜", "🌽", 7),
  PresetFood("蘑菇", "蔬菜", "🍄", 5),
  // 水果
  PresetFood("苹果", "水果", "🍎", 14),
  PresetFood("香蕉", "水果", "🍌", 5),
  PresetFood("橙子", "水果", "🍊", 10),
  PresetFood("草莓", "水果", "🍓", 3),
  PresetFood("葡萄", "水果", "🍇", 7),
  PresetFood("蓝莓", "水果", "🫐", 7),
  PresetFood("西瓜", "水果", "🍉", 7),
  PresetFood("猕猴桃", "水果", "🥝", 7),
  PresetFood("柠檬", "水果", "🍋", 14),
  // 乳制品
  PresetFood("牛奶", "乳制品", "🥛", 7),
  PresetFood("酸奶", "乳制品", "🥛", 14),
  PresetFood("奶酪", "乳制品", "🧀", 30),
  PresetFood("黄油", "乳制品", "🧈", 60),
  // 肉类
  PresetFood("猪肉", "肉类", "🥩", 5),
  PresetFood("牛肉", "肉类", "🥩", 5),
  PresetFood("鸡肉", "肉类", "🍗", 5),
  PresetFood("虾仁", "肉类", "🦐", 3),
  PresetFood("鱼", "肉类", "🐟", 3),
  PresetFood("鸡蛋", "蛋类", "🥚", 21),
  PresetFood("豆腐", "豆制品", "🫘", 3),
  PresetFood("豆浆", "豆制品", "🫘", 3),
  // 主食
  PresetFood("面包", "主食", "🍞", 7),
  PresetFood("面条", "主食", "🍝", 30),
  PresetFood("大米", "主食", "🍚", 180),
  PresetFood("饺子", "主食", "🥟", 30),
  // 饮品
  PresetFood("可乐", "饮品", "🥤", 180),
  PresetFood("果汁", "饮品", "🧃", 30),
  PresetFood("啤酒", "饮品", "🍺", 180),
  // 调味品
  PresetFood("酱油", "调味品", "🫙", 180),
  PresetFood("醋", "调味品", "🫙", 180),
  PresetFood("食用油", "调味品", "🫙", 180),
  PresetFood("盐", "调味品", "🧂", 365),
  PresetFood("糖", "调味品", "🧂", 365),
];
