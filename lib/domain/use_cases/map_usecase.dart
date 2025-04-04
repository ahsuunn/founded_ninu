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

  Future<List<LatLng>> fetchRoute(LatLng origin, LatLng destination) async {
    Dio dio = Dio();

    final url = 'https://maps.googleapis.com/maps/api/directions/json';
    final originStr = '${origin.latitude},${origin.longitude}';
    final destinationStr = '${destination.latitude},${destination.longitude}';

    final uri = Uri.https('maps.googleapis.com', '/maps/api/directions/json', {
      'origin': originStr,
      'destination': destinationStr,
      'key': AppKeys.mapsApiKey,
    });

    try {
      Response response = await dio.get(
        url,
        queryParameters: {
          'origin': '${origin.latitude},${origin.longitude}',
          'destination': '${destination.latitude},${destination.longitude}',
          'key': AppKeys.mapsApiKey,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        if (data['routes'].isNotEmpty) {
          final points = data['routes'][0]['overview_polyline']['points'];
          return PolylinePoints()
              .decodePolyline(points)
              .map((e) => LatLng(e.latitude, e.longitude))
              .toList();
        } else {
          return [];
        }
      } else {
        throw Exception('Failed to fetched direction: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching route: $e');
      return [];
    }
  }
}
