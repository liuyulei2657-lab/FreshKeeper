library;
int daysUntilExpiry(DateTime expiryDate) {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  final expiry = DateTime(expiryDate.year, expiryDate.month, expiryDate.day);
  return expiry.difference(today).inDays;
}

bool isExpired(DateTime expiryDate) => daysUntilExpiry(expiryDate) < 0;

bool isExpiring(DateTime expiryDate, {int thresholdDays = 3}) {
  final days = daysUntilExpiry(expiryDate);
  return days >= 0 && days <= thresholdDays;
}

String formatDate(DateTime date) {
  return "${date.year}-${date.month.toString().padLeft(2, "0")}-${date.day.toString().padLeft(2, "0")}";
}

String formatRemainingDays(int days) {
  if (days < 0) return "已过期 ${-days} 天";
  if (days == 0) return "今天过期";
  if (days == 1) return "明天过期";
  return "还有 $days 天";
}
