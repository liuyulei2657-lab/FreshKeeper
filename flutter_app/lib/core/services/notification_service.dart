library;
class NotificationService {
  NotificationService();

  Future<void> initialize() async {
    // TODO: 使用 flutter_local_notifications 初始化
  }

  Future<void> sendDailyReminder(List<String> expiredToday, List<String> expiringSoon) async {
    // TODO: 发送每日过期提醒通知
  }

  Future<void> cancelAll() async {
    // TODO: 取消所有待发送通知
  }
}
