class AppFormatters {
  AppFormatters._();

  static int parseCount(dynamic value) {
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static String formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 100000) return '${count ~/ 1000}K';
    if (count < 10000000) return '${count ~/ 100000}L';
    return '${count ~/ 10000000}CR';
  }
}
