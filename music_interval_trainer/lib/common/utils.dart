class Utils {
  static String formatDuration(Duration? duration, String nullValue) {
    if (duration == null) {
      return nullValue;
    } else {
      String twoDigit(int n) => n.toString().padLeft(2, "0");

      int minutes = duration.inMinutes;
      int seconds = duration.inSeconds % 60;
      int tenths = (duration.inMilliseconds % 1000) ~/ 100;
      return '${twoDigit(minutes)}:${twoDigit(seconds)}.$tenths';
    }
  }

}
