extension EnumExtension on String {
  /// Converts a string to an enum of type T.
  T toEnum<T>(List<T> values) {
    return values.firstWhere(
      (e) => e.toString().split('.').last == this,
    );
  }
}
