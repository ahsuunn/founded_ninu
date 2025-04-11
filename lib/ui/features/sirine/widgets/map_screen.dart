import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/cancel_confirmation_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/has_arrived_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/loading_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/overlay_prompt_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/arrival_bottom_sheet.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/cancel_confirmation.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_appbar.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/overlay_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
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
        next.whenData((pos) async {
          final newLocation = LatLng(pos.latitude, pos.longitude);
          if (_lastLocation == LatLng(0, 0) || _lastLocation != newLocation) {
            mapController.mapController?.animateCamera(
              CameraUpdate.newLatLng(newLocation),
            );
          }

          final chosenDestination = ref.read(selectedDestinationProvider);
          print("CHOSEN DESTINATION IN LISTENER : $chosenDestination");

          // 🔹 Check arrival
          if (chosenDestination != null) {
            final distance = Geolocator.distanceBetween(
              newLocation.latitude,
              newLocation.longitude,
              chosenDestination.latitude,
              chosenDestination.longitude,
            );

            final hasArrivedNotifier = ref.read(hasArrivedProvider.notifier);
            print(distance);
            if (distance < 10) {
              if (!ref.read(hasArrivedProvider)) {
                hasArrivedNotifier.state = true; // Just arrived
                if (ref.watch(
                      activeBottomSheetProvider as ProviderListenable<bool>,
                    ) !=
                    ActiveBottomSheet.none)
                  context.pop;
                showBottomSheet(
                  context: context,
                  builder: (context) => ArrivalBottomSheet(),
                );
                debugPrint("🚀 User has arrived at destination!");
              }
            } else {
              if (ref.read(hasArrivedProvider)) {
                hasArrivedNotifier.state = false; // No longer at destination
              }
            }
          }

          //Update Polyline
          if (chosenDestination != null) {
            updateRoutePolyline(ref, newLocation, chosenDestination);
          }

          // Update destination info (distance and duration)
          final travelMode = ref.read(travelModeProvider);
          if (chosenDestination != null) {
            final data = await MapUsecase().fetchRoute(
              newLocation,
              chosenDestination,
              mode: travelMode,
            );
            final updatedInfo = DestinationInfo(
              distance: data['distance'],
              duration: data['duration'],
            );
            ref.read(selectedDestinationInfoProvider.notifier).state =
                updatedInfo;
          }

          _lastLocation = newLocation;
        });
      });

      ref.listen<LatLng?>(selectedDestinationProvider, (prev, next) async {
        print("UPDATE ROUTE POLYLINE");
        if (next != null) {
          final pos = await Geolocator.getCurrentPosition();
          final userPos = LatLng(pos.latitude, pos.longitude);
          updateRoutePolyline(ref, userPos, next);
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
        if (ref.watch(showOverlayPromptProvider))
          OverlayPromptWidget(
            message: "Permission has been allowed, proceed to activate Ninu?",
            buttonText: "Activate",
          ),
        if (ref.watch(showCancelConfirmationProvider))
          CancelConfirmationDialog(),
      ],
    );
  }
}
