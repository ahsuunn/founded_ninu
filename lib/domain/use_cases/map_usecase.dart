import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
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
    // The correct endpoint URL for the Routes API
    final url = 'https://routes.googleapis.com/directions/v2:computeRoutes';

    // Convert travel mode to match Routes API format
    String travelMode;
    switch (mode) {
      case 'driving':
        travelMode = 'DRIVE';
        break;
      case 'motorcycle':
        travelMode = 'TWO_WHEELER';
        break;
      case 'walking':
        travelMode = 'WALK';
        break;
      case 'bicycling':
        travelMode = 'BICYCLE';
        break;
      default:
        travelMode = 'DRIVE';
    }

    try {
      // Routes API uses POST instead of GET
      Response response = await dio.post(
        url,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': AppKeys.mapsApiKey,
            'X-Goog-FieldMask':
                'routes.distanceMeters,routes.duration,routes.polyline.encodedPolyline,routes.legs.distanceMeters,routes.legs.duration',
          },
        ),
        data: {
          'origin': {
            'location': {
              'latLng': {
                'latitude': origin.latitude,
                'longitude': origin.longitude,
              },
            },
          },
          'destination': {
            'location': {
              'latLng': {
                'latitude': destination.latitude,
                'longitude': destination.longitude,
              },
            },
          },
          'travelMode': travelMode,
          'routingPreference': 'TRAFFIC_AWARE',
          'computeAlternativeRoutes': false,
          'polylineQuality': 'HIGH_QUALITY',
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['routes'] != null && data['routes'].isNotEmpty) {
          final route = data['routes'][0];

          // Extract polyline points
          final encodedPolyline = route['polyline']['encodedPolyline'];
          final polylinePoints =
              PolylinePoints()
                  .decodePolyline(encodedPolyline)
                  .map((e) => LatLng(e.latitude, e.longitude))
                  .toList();

          // Default values for distance and duration
          String distance = 'Unknown';
          String duration = 'Unknown';

          // Get the route-level distance and duration first
          if (route['distanceMeters'] != null) {
            final distanceMeters = route['distanceMeters'];
            distance =
                (distanceMeters < 1000)
                    ? '$distanceMeters m'
                    : '${(distanceMeters / 1000).toStringAsFixed(1)} km';
          }

          if (route['duration'] != null) {
            final durationStr = route['duration'];
            // Parse duration string like "1200s" to seconds
            final seconds = int.tryParse(durationStr.replaceAll('s', '')) ?? 0;
            if (seconds < 60) {
              duration = '$seconds sec';
            } else if (seconds < 3600) {
              duration = '${(seconds / 60).round()} min';
            } else {
              final hours = (seconds / 3600).floor();
              final minutes = ((seconds % 3600) / 60).round();
              duration = '$hours hr $minutes min';
            }
          }

          // Try leg data if route-level data is not available
          if (route['legs'] != null && route['legs'].isNotEmpty) {
            final leg = route['legs'][0];

            if (distance == 'Unknown' && leg['distanceMeters'] != null) {
              final distanceMeters = leg['distanceMeters'];
              distance =
                  (distanceMeters < 1000)
                      ? '$distanceMeters m'
                      : '${(distanceMeters / 1000).toStringAsFixed(1)} km';
            }

            if (duration == 'Unknown' && leg['duration'] != null) {
              final durationStr = leg['duration'];
              final seconds =
                  int.tryParse(durationStr.replaceAll('s', '')) ?? 0;
              if (seconds < 60) {
                duration = '$seconds sec';
              } else if (seconds < 3600) {
                duration = '${(seconds / 60).round()} min';
              } else {
                final hours = (seconds / 3600).floor();
                final minutes = ((seconds % 3600) / 60).round();
                duration = '$hours hr $minutes min';
              }
            }
          }

          return {
            'polyline': polylinePoints,
            'distance': distance,
            'duration': duration,
          };
        } else {
          debugPrint('No routes found in the response');
          return {};
        }
      } else {
        debugPrint('Error response: ${response.data}');
        throw Exception('Failed to fetch directions: ${response.statusCode}');
      }
    } catch (e) {
      if (e is DioException) {
        debugPrint('DioException: ${e.message}');
        debugPrint('Response data: ${e.response?.data}');
        debugPrint('Response status code: ${e.response?.statusCode}');
        // debugPrint the complete request details for debugging
        debugPrint('Request details:');
        debugPrint('URL: ${e.requestOptions.uri}');
        debugPrint('Method: ${e.requestOptions.method}');
        debugPrint('Headers: ${e.requestOptions.headers}');
        debugPrint('Data: ${e.requestOptions.data}');
      }
      debugPrint('Error fetching route: $e');
      return {};
    }
  }
}
