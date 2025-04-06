import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final userLocationStreamProvider = StreamProvider<Position>((ref) {
  return Geolocator.getPositionStream(
    locationSettings: LocationSettings(
      accuracy: LocationAccuracy.best,
      distanceFilter: 10, // Update every 10 meters
    ),
  );
});

final travelModeProvider = StateProvider<String>((ref) => 'driving');
final routePolylineProvider = StateProvider<Set<Polyline>>((ref) => {});
final selectedDestinationProvider = StateProvider<LatLng?>((ref) => null);
final selectedDestinationInfoProvider = StateProvider<DestinationInfo?>(
  (ref) => null,
);

void updateRoutePolyline(
  WidgetRef ref,
  LatLng userLocation,
  LatLng destination,
) async {
  final mode = ref.read(travelModeProvider);
  final pointData = await MapUsecase().fetchRoute(
    userLocation,
    destination,
    mode: mode,
  );

  // Set the polyline (maybe just one of them, or both separately)
  if (pointData.containsKey('polyline')) {
    final polyline = Polyline(
      polylineId: const PolylineId('route'),
      points: pointData['polyline'],
      color: colorScheme.primary,
      width: 5,
    );

    ref.read(routePolylineProvider.notifier).state = {polyline};
  }
}
