library;
import "package:flutter_riverpod/flutter_riverpod.dart";

final notificationEnabledProvider = StateProvider<bool>((ref) => true);
final reminderTimeProvider = StateProvider<String>((ref) => "08:00");
final advanceDaysProvider = StateProvider<int>((ref) => 2);
