extension ArabicDateTimeFormatting on DateTime {
  /// Formats the DateTime as "Day Month, Year, Hour:Minute" in Arabic
  String formatInArabic() {
    const List<String> arabicMonths = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر'
    ];

    String day = this.day.toString();
    String month = arabicMonths[this.month - 1];
    String year = this.year.toString();
    String hour = this.hour.toString().padLeft(2, '0');
    String minute = this.minute.toString().padLeft(2, '0');

    return '$day $month, $year, $hour:$minute';
  }
}
