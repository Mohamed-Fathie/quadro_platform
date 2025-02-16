import 'package:google_geocoding_api/google_geocoding_api.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' show LatLng;
import 'package:quadro_platform/features/google_map/model/selected_location.dart';

class GeoCodingRepository {
  final GoogleGeocodingApi _geocoding;

  GeoCodingRepository(String apiKey) : _geocoding = GoogleGeocodingApi(apiKey);

  Future<SelectedLocation> reverseGeocode(LatLng coordinates) async {
    final response = await _geocoding.reverse(
      "${coordinates.latitude},${coordinates.longitude}",
      language: 'ar',
    );

    String? street;
    String? city;

    if (response.results.isNotEmpty) {
      final components = response.results.first.addressComponents;

      street = components
          .firstWhere(
            (c) => c.types.contains('route'),
            orElse: () => const GoogleGeocodingAddressComponent(
                longName: 'Unknown street'),
          )
          .longName;

      city = components
          .firstWhere(
            (c) =>
                c.types.contains('locality') || c.types.contains('sublocality'),
            orElse: () =>
                const GoogleGeocodingAddressComponent(longName: 'Unknown city'),
          )
          .longName;
    }

    return SelectedLocation(
      coordinates: coordinates,
      street: street,
      city: city,
    );
  }
}
