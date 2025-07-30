class DurationFormatter {
    static String formattedDuration(Duration d) {
      String shiftByTwo(int n) => n.toString().padLeft(2, '0');
      return "${shiftByTwo(d.inHours)}:${shiftByTwo(d.inMinutes % 60)}:${shiftByTwo(d.inSeconds % 60)}";
    }

}