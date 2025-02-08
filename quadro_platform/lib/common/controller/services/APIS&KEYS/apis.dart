import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quadro_platform/common/controller/services/APIS&KEYS/keys.dart';

class Apis {
  static geoCodingAPI(LatLng position) =>
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapsKey';

  static placesAPI(String placeName) =>
      'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapsKey&sessiontoken=123254251&components=country:LY';

  static directionAPI(LatLng pickup, LatLng drop) =>
      'https://maps.googleapis.com/maps/api/directions/json?origin=${pickup.latitude},${pickup.longitude}&destination=${drop.latitude},${drop.longitude}&mode=driving&key=$mapsKey';

  static getLatLngFromPlaceIDAPI(String placeID) =>
      'https://maps.googleapis.com/maps/api/place/details/json?placeid=${placeID}&key=$mapsKey';

  static pushNotificationAPI() =>
      'https://fcm.googleapis.com/v1/projects/quadro-204be/messages:send';

      //changes

}
