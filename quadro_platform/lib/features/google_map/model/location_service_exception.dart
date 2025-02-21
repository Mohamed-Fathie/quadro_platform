import 'package:geolocator/geolocator.dart';

enum WorkshopLocationErrorType {
  gpsDisabled,
  permissionDenied,
  permissionDeniedForever,
  unknown,
}

class WorkshopLocationException implements Exception {
  final WorkshopLocationErrorType errorType;
  final String message;

  WorkshopLocationException({
    required this.errorType,
    required this.message,
  });

  @override
  String toString() {
    return 'WorkshopLocationException: $message';
  }

  static Future<void> checkLocationServices() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      throw WorkshopLocationException(
        errorType: WorkshopLocationErrorType.gpsDisabled,
        message: "خدمات الموقع معطلة. يرجى تفعيلها من إعدادات الجهاز.",
      );
    }
  }

  static Future<void> checkAndRequestPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw WorkshopLocationException(
          errorType: WorkshopLocationErrorType.permissionDenied,
          message: "تم رفض إذن الوصول للموقع. يرجى منح الإذن للوصول.",
        );
      }
      if (permission == LocationPermission.deniedForever) {
        throw WorkshopLocationException(
          errorType: WorkshopLocationErrorType.permissionDeniedForever,
          message:
              "تم رفض إذن الوصول للموقع نهائيًا. يرجى تغيير الإعدادات يدويًا.",
        );
      }
    }
  }
}
