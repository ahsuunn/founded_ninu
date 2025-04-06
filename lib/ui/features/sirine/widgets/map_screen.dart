import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/features/sirine/provider/loading_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_appbar.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/overlay_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_view.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_floating_buttons.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  final mapController = MapController();
  LatLng _lastLocation = const LatLng(0, 0);
  bool _hasListened = false; // ensure only listens once

  @override
  void initState() {
    super.initState();
    mapController.initialize(ref);
  }

  @override
  Widget build(BuildContext context) {
    final scaffoldKey = ref.watch(scaffoldKeyProvider);
    if (!_hasListened) {
      _hasListened = true;

      ref.listen<AsyncValue<Position>>(userLocationStreamProvider, (_, next) {
        next.whenData((pos) {
          final newLocation = LatLng(pos.latitude, pos.longitude);
          if (_lastLocation == LatLng(0, 0) || _lastLocation != newLocation) {
            mapController.mapController?.animateCamera(
              CameraUpdate.newLatLng(newLocation),
            );
          }

          final chosenDestination = ref.read(selectedDestinationProvider);
          if (chosenDestination != null) {
            updateRoutePolyline(ref, newLocation, chosenDestination);
          }

          _lastLocation = newLocation;
        });
      });

      ref.listen<LatLng?>(selectedDestinationProvider, (prev, next) {
        final userPos = ref.read(locationProvider);
        if (userPos != null && next != null) {
          updateRoutePolyline(
            ref,
            LatLng(userPos.latitude, userPos.longitude),
            next,
          );
        }
      });
    }
    return Stack(
      children: [
        Scaffold(
          key: scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: MapAppbar(mapController: mapController),
          body: MapView(mapController: mapController, scaffoldKey: scaffoldKey),
        ),
        MapFloatingButtons(controller: mapController),
        if (ref.watch(isLoadingProvider))
          ModalBarrier(dismissible: false, color: Color(0x80000000)),
        if (ref.watch(isLoadingProvider))
          const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Sending Permission",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                Text(
                  "Please wait a moment...",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ],
            ),
          ),
      ],
    );
  }
}
