import 'package:dio/dio.dart';
import 'package:founded_ninu/config/keys.dart';

class GoogleMapsService {
  final Dio _dio = Dio();
  final String apiKey = AppKeys.mapsApiKey;

  Future<List<dynamic>> getNearbyHospitals(double lat, double lng) async {
    final String url =
        'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

    try {
      Response response = await _dio.get(
        url,
        queryParameters: {
          'location': '$lat,$lng',
          'radius': 5000, // Search within 5km
          'type': 'hospital',
          'key': apiKey,
        },
      );

      if (response.statusCode == 200) {
        print(response.data['results']);
        return response.data['results']; // List of hospitals
      } else {
        throw Exception('Failed to load hospitals');
      }
    } catch (e) {
      print('Error fetching hospitals: $e');
      return [];
    }
  }
}
