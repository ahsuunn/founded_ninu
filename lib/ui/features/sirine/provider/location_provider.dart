import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/data/services/location_services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final locationProvider = StateNotifierProvider<LocationNotifier, Position?>(
  (ref) => LocationNotifier(),
);

class LocationNotifier extends StateNotifier<Position?> {
  LocationNotifier() : super(null) {
    _fetchLocation(); // Fetch location on initialization
  }

  Future<void> _fetchLocation() async {
    final LocationService locationService =
        LocationService(); // Create an instance

    try {
      Position position = await locationService.getCurrentLocation();
      state = position; // Update global state
    } catch (e) {
      debugPrint("Error fetching location: $e");
    }
  }

  void setMockPositionToDestination(LatLng destination) {
    print("MOCK ACTIVATED");
    state = Position(
      latitude: destination.latitude,
      longitude: destination.longitude,
      timestamp: DateTime.now(),
      accuracy: 5,
      altitude: 0.0,
      heading: 0.0,
      speed: 0.0,
      speedAccuracy: 0.0,
      headingAccuracy: 0.0,
      altitudeAccuracy: 0.0,
    );
  }

  void refreshLocation() {
    _fetchLocation(); // Refresh location manually
  }

  void setMockLocation(Position mockPosition) {
    state = mockPosition;
  }
}

final placemarkProvider = FutureProvider<List<Placemark>>((ref) async {
  final userPosition = ref.watch(locationProvider);

  if (userPosition == null) {
    return []; // Return an empty list if location is null
  }

  return await placemarkFromCoordinates(
    userPosition.latitude,
    userPosition.longitude,
  );
});
