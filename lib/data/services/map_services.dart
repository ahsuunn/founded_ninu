import 'package:dio/dio.dart';
import 'package:founded_ninu/config/keys.dart';

class GoogleMapsService {
  final Dio _dio = Dio();
  final String apiKey = AppKeys.mapsApiKey;

  Future<List<dynamic>> getNearbyHospitals(double lat, double lng) async {
    // New Places API endpoint
    final String url = 'https://places.googleapis.com/v1/places:searchNearby';

    try {
      // The new API requires a POST request with a JSON body
      Response response = await _dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': apiKey,
            'X-Goog-FieldMask':
                'places.displayName,places.formattedAddress,places.location,places.id',
          },
        ),
        data: {
          'locationRestriction': {
            'circle': {
              'center': {'latitude': lat, 'longitude': lng},
              'radius': 5000.0, // 5km in meters
            },
          },
          'includedTypes': ['hospital'],
        },
      );

      if (response.statusCode == 200) {
        // Structure of response has changed in the new API
        return response.data['places'] ?? []; // List of hospitals
      } else {
        throw Exception('Failed to load hospitals: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching nearby hospitals: $e');
      return [];
    }
  }
}
