class Utils {
  static String formatDuration(Duration? duration, String nullValue) => (null != duration) ? duration.toString().split('.').first.padLeft(8, "0") : nullValue;
}
