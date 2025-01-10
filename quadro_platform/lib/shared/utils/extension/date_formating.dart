extension ArabicDateTimeFormatting on DateTime {
  /// Formats the DateTime as "Day Month, Year, Hour:Minute" in Arabic
  String formatInArabic({bool? withouthours}) {
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
    if (withouthours != null) {
      return '$day $month, $year';
    } else {
      return '$day $month, $year, $hour:$minute';
    }
  }

  /// Formats the difference between the present and the given DateTime in Arabic
  String timeDifferenceInArabic() {
    final now = DateTime.now();
    final difference = now.difference(this);

    if (difference.isNegative) {
      return 'التاريخ المحدد في المستقبل';
    }

    final days = difference.inDays;
    final hours = difference.inHours % 24;
    final minutes = difference.inMinutes % 60;
    final seconds = difference.inSeconds % 60;

    String formatUnit(int value, String singular, String plural) {
      if (value == 1) {
        return '$value $singular';
      } else if (value > 1 && value <= 10) {
        return '$value ${plural}';
      } else {
        return '$value ${plural}'; // Adjust this for proper Arabic grammar
      }
    }

    String result = '';
    if (days > 0) {
      result += formatUnit(days, 'يوم', 'أيام') + ' ';
    }
    if (hours > 0) {
      result += formatUnit(hours, 'ساعة', 'ساعات') + ' ';
    }
    if (minutes > 0) {
      result += formatUnit(minutes, 'دقيقة', 'دقائق') + ' ';
    }
    if (seconds > 0 && result.isEmpty) {
      // Include seconds only if no larger units are present
      result += formatUnit(seconds, 'ثانية', 'ثوانٍ');
    }

    return result.isEmpty ? 'الآن' : "مند ${result.trim()} ";
  }
}
