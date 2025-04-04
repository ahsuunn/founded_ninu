import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final userLocationStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 10, // Update every 10 meters
    ),
  );
});

final selectedDestinationProvider = StateProvider<LatLng?>((ref) => null);

final routePolylineProvider = StateProvider<Set<Polyline>>((ref) => {});
void updateRoutePolyline(
  WidgetRef ref,
  LatLng userLocation,
  LatLng destination,
) async {
  List<LatLng> newRoute = await MapUsecase().fetchRoute(
    userLocation,
    destination,
  );

  if (newRoute.isNotEmpty) {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: newRoute,
      color: Colors.blue,
      width: 5,
    );

    ref.read(routePolylineProvider.notifier).state = {polyline};
  }
}
