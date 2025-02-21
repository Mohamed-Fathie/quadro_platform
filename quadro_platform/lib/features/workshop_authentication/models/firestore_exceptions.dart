class FirestoreReadWriteFailure implements Exception {
  final String message;

  const FirestoreReadWriteFailure(
      [this.message = "حدث خطأ ما الرجاء اعادة المحاوله"]);
  factory FirestoreReadWriteFailure.fromCode(String code) {
    switch (code) {
      case 'aborted':
        return const FirestoreReadWriteFailure(
            'العملية تم إلغاؤها بسبب تعارض أو مشكلة في الكتابة.');
      case 'already-exists':
        return const FirestoreReadWriteFailure(
            'الوثيقة أو العنصر الذي تحاول إضافته موجود بالفعل.');
      case 'cancelled':
        return const FirestoreReadWriteFailure(
            'تم إلغاء العملية من قبل المستخدم أو بسبب خطأ.');
      case 'deadline-exceeded':
        return const FirestoreReadWriteFailure(
            'تم تجاوز الوقت المحدد للعملية.');
      case 'failed-precondition':
        return const FirestoreReadWriteFailure(
            'فشل العملية بسبب شرط غير متحقق.');
      case 'invalid-argument':
        return const FirestoreReadWriteFailure('الوسيطات المدخلة غير صالحة.');
      case 'not-found':
        return const FirestoreReadWriteFailure(
            'لم يتم العثور على الوثيقة أو المجموعة المطلوبة.');
      case 'unavailable':
        return const FirestoreReadWriteFailure(
            'الخدمة غير متاحة في الوقت الحالي.');
      default:
        return const FirestoreReadWriteFailure(
            'حدث خطأ غير معروف أثناء العملية.');
    }
  }
}
