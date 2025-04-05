import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/marker_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';

class MapView extends ConsumerWidget {
  final MapController mapController;
  final GlobalKey<ScaffoldState> scaffoldKey;

  const MapView({
    required this.mapController,
    required this.scaffoldKey,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final location = ref.watch(locationProvider);
    if (location == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      zoomControlsEnabled: false,
      initialCameraPosition: CameraPosition(
        target: mapController.currentPosition,
        zoom: 14.0,
      ),
      markers: ref.watch(markersProvider),
      onMapCreated: (GoogleMapController controller) {
        mapController.mapController = controller;
      },
      polylines: ref.watch(routePolylineProvider),
    );
  }
}
