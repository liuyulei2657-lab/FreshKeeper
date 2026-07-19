library;
import "package:flutter_riverpod/flutter_riverpod.dart";

final settingsReminderTimeProvider = StateProvider<String>((ref) => "08:00");
final settingsAdvanceDaysProvider = StateProvider<int>((ref) => 2);
final settingsNotificationEnabledProvider = StateProvider<bool>((ref) => true);
