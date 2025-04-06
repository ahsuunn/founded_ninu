import 'package:dio/dio.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:geocoding/geocoding.dart';
import 'package:founded_ninu/data/services/map_services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

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

  Future<Map<String, dynamic>> fetchRoute(
    LatLng origin,
    LatLng destination, {
    String mode = 'driving', // or 'motorcycle'
  }) async {
    Dio dio = Dio();
    final url = 'https://maps.googleapis.com/maps/api/directions/json';

    try {
      Response response = await dio.get(
        url,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'mode': mode, // Add mode here
          'key': AppKeys.mapsApiKey,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['routes'].isNotEmpty) {
          final route = data['routes'][0];
          final leg = route['legs'][0];

          final points = route['overview_polyline']['points'];
          final polylinePoints =
              PolylinePoints()
                  .decodePolyline(points)
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();

          return {
            'polyline': polylinePoints,
            'distance': leg['distance']['text'],
            'duration': leg['duration']['text'],
          };
        } else {
          return {};
        }
      } else {
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
      return {};
    }
  }
}
