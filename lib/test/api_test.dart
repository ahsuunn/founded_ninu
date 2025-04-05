// ignore_for_file: avoid_print

import 'package:dio/dio.dart';
import 'package:founded_ninu/config/keys.dart';

void main() async {
  final Dio dio = Dio();
  const String apiKey = AppKeys.mapsApiKey; // Replace with your key

  const double lat = -6.6103519;
  const double lng = 106.8248279;
  final String url =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  try {
    Response response = await dio.get(
      url,
      queryParameters: {
        'location': '$lat,$lng',
        'radius': 5000,
        'type': 'hospital',
        'key': apiKey,
      },
    );

    if (response.statusCode == 200) {
      print("Hospitals Found: ${response.data['results'].length}");
      for (var hospital in response.data['results']) {
        print("🏥 Name: ${hospital['name']}");
        print("📍 Address: ${hospital['vicinity']}");
        print("---------");
      }
    } else {
      print('❌ Failed to load hospitals. Status Code: ${response.statusCode}');
    }
  } catch (e) {
    print('⚠️ Error fetching hospitals: $e');
  }
}
