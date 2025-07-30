class MonthDayFormatter {
  
  static String formatDate(DateTime date) {
    final months = ["Jan", "Feb", "Mar", "Apr", "May", "June", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];
    return "${months[date.month - 1]} ${date.day} ${date.year}";
  }

}