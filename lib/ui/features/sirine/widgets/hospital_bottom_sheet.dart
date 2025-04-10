import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/entities/locked_address.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/loading_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_initial_position_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_destination_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_starttime_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/marker_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/overlay_prompt_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/travel_state_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/first_start_mode_bottom_sheet.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/overlay_permission.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HospitalBottomSheet extends ConsumerStatefulWidget {
  final String hospitalName;
  final String hospitalVicinity;
  final VoidCallback onSetDirection;

  const HospitalBottomSheet({
    super.key,
    required this.hospitalName,
    required this.hospitalVicinity,
    required this.onSetDirection,
  });

  @override
  ConsumerState<HospitalBottomSheet> createState() =>
      _HospitalBottomSheetState();
}

class _HospitalBottomSheetState extends ConsumerState<HospitalBottomSheet> {
  @override
  void initState() {
    super.initState();

    // Use WidgetsBinding to wait until ref is fully ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.listenManual<String>(travelModeProvider, (prev, next) async {
        final markerId = ref.read(selectedMarkerIdProvider);
        final currentPosition = ref.read(locationProvider);
        final hospitalMap = ref.read(hospitalMarkerPositionsProvider);

        print("MODE CHANGE TO $next");

        if (markerId != null &&
            currentPosition != null &&
            hospitalMap[markerId] != null) {
          final hospitalPosition = hospitalMap[markerId]?.position;

          try {
            if (hospitalPosition != null) {
              final data = await MapUsecase().fetchRoute(
                LatLng(currentPosition.latitude, currentPosition.longitude),
                hospitalPosition,
                mode: next,
              );

              final info = DestinationInfo(
                distance: data['distance'],
                duration: data['duration'],
              );

              ref.read(selectedDestinationInfoProvider.notifier).state = info;
              // ref.read(selectedDestinationProvider.notifier).state =
            }
            //     hospitalPosition;
          } catch (e) {
            debugPrint("Failed to fetch new route on mode change: $e");
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for travel mode changes
    ref.listen<String>(travelModeProvider, (prev, next) async {
      final markerId = ref.read(selectedMarkerIdProvider);
      final currentPosition = ref.read(locationProvider);
      final hospitalMap = ref.read(hospitalMarkerPositionsProvider);
      final hospitalInfo = hospitalMap[markerId];
      // print("MODE CHANGE TO $mode");
      if (markerId != null &&
          currentPosition != null &&
          hospitalInfo?.position != null) {
        try {
          LatLng? hospitalPosition = hospitalInfo?.position;
          // String? hospitalName = hospitalInfo?.name;
          if (hospitalPosition != null) {
            final data = await MapUsecase().fetchRoute(
              LatLng(currentPosition.latitude, currentPosition.longitude),
              hospitalPosition,
              mode: next,
            );
            final info = DestinationInfo(
              distance: data['distance'],
              duration: data['duration'],
            );
            ref.read(selectedDestinationInfoProvider.notifier).state = info;
          }
        } catch (e) {
          debugPrint("Failed to fetch new route on mode change: $e");
        }
      }
    });

    final width = MediaQuery.of(context).size.width;
    final markerId = ref.watch(selectedMarkerIdProvider);
    final currentPosition = ref.watch(locationProvider);
    String mode = ref.watch(travelModeProvider);
    final destinationInfo = ref.watch(selectedDestinationInfoProvider);
    final hospitalMap = ref.watch(hospitalMarkerPositionsProvider);

    // print("DESTINATION INFO : ${destinationInfo?.distance ?? "no distance"}");
    // print("MODE : $mode");

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SizedBox(
          width: width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                width: width * 0.3,
                height: 5,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
              ),
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 6,
                    children: [
                      Text(
                        widget.hospitalName,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.hospitalVicinity,
                        style: const TextStyle(
                          fontSize: 14,
                          color: Color(0xD0FFFFFF),
                        ),
                      ),
                      Text(
                        "Distance :  ${destinationInfo?.distance ?? "- km"}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        "Travel Time : ~${destinationInfo?.duration ?? "- min"}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                      Wrap(
                        spacing: 8, // space between buttons
                        runSpacing: 8, // space between lines
                        children: [
                          ElevatedButton.icon(
                            onPressed: widget.onSetDirection,
                            icon: const Icon(Icons.directions),
                            label: const Text("Direction"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () async {
                              ref.read(travelStateModeProvider.notifier).state =
                                  TravelStateMode.startMode;

                              //Get Current Address
                              final placemarks = await ref.read(
                                placemarkProvider.future,
                              );
                              final currentAddress =
                                  placemarks.isNotEmpty
                                      ? placemarks.first.name ?? "Unknown"
                                      : "Unknown";

                              //Get Current Hospital
                              final hospitalPosition =
                                  hospitalMap[markerId]?.position;
                              final hospitalName = hospitalMap[markerId]?.name;

                              //Get Route and Destination Info
                              if (hospitalPosition != null &&
                                  currentPosition != null) {
                                final data = await MapUsecase().fetchRoute(
                                  LatLng(
                                    currentPosition.latitude,
                                    currentPosition.longitude,
                                  ),
                                  hospitalPosition,
                                  mode: mode,
                                );
                                final info = DestinationInfo(
                                  distance: data['distance'],
                                  duration: data['duration'],
                                );

                                //Get Current Time
                                if (ref.read(lockedStartTimeProvider) == null) {
                                  ref
                                      .read(lockedStartTimeProvider.notifier)
                                      .state = DateTime.now();
                                }

                                //Set Destination
                                final currentPos =
                                    await Geolocator.getCurrentPosition();
                                updateRoutePolyline(
                                  ref,
                                  LatLng(
                                    currentPos.latitude,
                                    currentPos.longitude,
                                  ),
                                  hospitalPosition,
                                );
                                ref
                                    .read(
                                      selectedDestinationInfoProvider.notifier,
                                    )
                                    .state = info;
                                ref
                                    .read(selectedDestinationProvider.notifier)
                                    .state = hospitalPosition;

                                // Lock the initial and final position
                                ref
                                    .read(lockedDestinationProvider.notifier)
                                    .state = LockedAddress(
                                  name: hospitalName ?? "Unknown",
                                  position: hospitalPosition,
                                );
                                ref
                                    .read(
                                      lockedInitialPositionProvider.notifier,
                                    )
                                    .state = LockedAddress(
                                  name: currentAddress,
                                  position: LatLng(
                                    currentPosition.latitude,
                                    currentPosition.longitude,
                                  ),
                                );
                              }

                              ref.read(isLoadingProvider.notifier).state = true;
                              // Simulate hospital permission request (mock API call)
                              await Future.delayed(const Duration(seconds: 2));

                              ref.read(isLoadingProvider.notifier).state =
                                  false;

                              ref
                                  .read(showOverlayPromptProvider.notifier)
                                  .state = true;

                              //Pop the current Bottom sheet
                              if (context.mounted) context.pop();

                              SchedulerBinding.instance.addPostFrameCallback((
                                _,
                              ) {
                                if (!context.mounted) return;

                                ref
                                    .read(activeBottomSheetProvider.notifier)
                                    .state = ActiveBottomSheet.firstStart;
                                //Open the new bottom sheet
                                final scaffoldKey = ref.read(
                                  scaffoldKeyProvider,
                                );
                                scaffoldKey.currentState
                                    ?.showBottomSheet(
                                      (context) => FirstStartModeBottomSheet(),
                                      backgroundColor: colorScheme.primary,
                                    )
                                    .closed
                                    .then((_) {
                                      if (!mounted) return;
                                      ref
                                          .read(
                                            activeBottomSheetProvider.notifier,
                                          )
                                          .state = ActiveBottomSheet.none;
                                    });
                              });
                            },
                            icon: const Icon(Icons.navigation_rounded),
                            label: const Text("Start"),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => {},
                            icon: const Icon(Icons.call),
                            label: const Text("Call"),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
