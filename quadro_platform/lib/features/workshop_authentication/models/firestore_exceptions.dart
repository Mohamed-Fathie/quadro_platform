class FirestroeReadWriteFailure implements Exception {
  final String message;

  const FirestroeReadWriteFailure(
      [this.message = "حدث خطأ ما الرجاء اعادة المحاوله"]);
  factory FirestroeReadWriteFailure.fromCode(String code) {
    switch (code) {
      case 'aborted':
        return const FirestroeReadWriteFailure(
            'العملية تم إلغاؤها بسبب تعارض أو مشكلة في الكتابة.');
      case 'already-exists':
        return const FirestroeReadWriteFailure(
            'الوثيقة أو العنصر الذي تحاول إضافته موجود بالفعل.');
      case 'cancelled':
        return const FirestroeReadWriteFailure(
            'تم إلغاء العملية من قبل المستخدم أو بسبب خطأ.');
      case 'deadline-exceeded':
        return const FirestroeReadWriteFailure(
            'تم تجاوز الوقت المحدد للعملية.');
      case 'failed-precondition':
        return const FirestroeReadWriteFailure(
            'فشل العملية بسبب شرط غير متحقق.');
      case 'invalid-argument':
        return const FirestroeReadWriteFailure('الوسيطات المدخلة غير صالحة.');
      case 'not-found':
        return const FirestroeReadWriteFailure(
            'لم يتم العثور على الوثيقة أو المجموعة المطلوبة.');
      case 'unavailable':
        return const FirestroeReadWriteFailure(
            'الخدمة غير متاحة في الوقت الحالي.');
      default:
        return const FirestroeReadWriteFailure(
            'حدث خطأ غير معروف أثناء العملية.');
    }
  }
}
