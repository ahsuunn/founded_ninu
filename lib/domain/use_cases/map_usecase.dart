import 'package:geocoding/geocoding.dart';
import 'package:founded_ninu/data/services/map_services.dart';

class MapUsecase {
  bool isHospital(String placeName) {
    final regex = RegExp(
      r'\b(rs|rumah sakit|hospital)\b',
      caseSensitive: false,
    );
    return regex.hasMatch(placeName);
  }

  Future<Set<Placemark>> fetchNearbyHospitals(double lat, double lng) async {
    List<dynamic> response = await GoogleMapsService().getNearbyHospitals(
      lat,
      lng,
    );

    Set<Placemark> placemarks = {};
    for (var hospital in response) {
      double latitude = hospital['geometry']['location']['lat'];
      double longitude = hospital['geometry']['location']['lng'];
      List<Placemark> hospitalPlacemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (hospitalPlacemarks.isNotEmpty) {
        for (var placemark in hospitalPlacemarks) {
          if (isHospital(placemark.name!)) placemarks.add(placemark);
        }
      }
    }

    return placemarks;
  }
}
