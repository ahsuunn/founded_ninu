import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/loading_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_destination_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/marker_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/first_start_mode_bottom_sheet.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';
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
          final hospitalPosition = hospitalMap[markerId]!;

          try {
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
    final width = MediaQuery.of(context).size.width;
    final markerId = ref.watch(selectedMarkerIdProvider);
    final currentPosition = ref.watch(locationProvider);
    String mode = ref.watch(travelModeProvider);
    final hospitalMap = ref.watch(hospitalMarkerPositionsProvider);
    final destinationInfo = ref.watch(selectedDestinationInfoProvider);
    // print("DESTINATION INFO : ${destinationInfo?.distance ?? "no distance"}");
    // print("MODE : $mode");

    // Listen for travel mode changes
    ref.listen<String>(travelModeProvider, (prev, next) async {
      final markerId = ref.read(selectedMarkerIdProvider);
      final currentPosition = ref.read(locationProvider);
      final hospitalMap = ref.read(hospitalMarkerPositionsProvider);
      // print("MODE CHANGE TO $mode");
      if (markerId != null &&
          currentPosition != null &&
          hospitalMap[markerId] != null) {
        final hospitalPosition = hospitalMap[markerId]!;

        try {
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
        } catch (e) {
          debugPrint("Failed to fetch new route on mode change: $e");
        }
      }
    });

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.25,
      minChildSize: 0.2,
      maxChildSize: 0.5,
      builder: (context, scrollController) {
        return SingleChildScrollView(
          controller: scrollController,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            destinationInfo?.distance ?? "",
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            destinationInfo?.duration ?? "",
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
                                  //fetch the data if not hd been set.
                                  debugPrint(markerId);

                                  final hospitalPosition =
                                      hospitalMap[markerId];
                                  if (hospitalPosition != null) {
                                    final data = await MapUsecase().fetchRoute(
                                      LatLng(
                                        currentPosition!.latitude,
                                        currentPosition.longitude,
                                      ),
                                      hospitalPosition,
                                      mode: mode,
                                    );
                                    final info = DestinationInfo(
                                      distance: data['distance'],
                                      duration: data['duration'],
                                    );
                                    ref
                                        .read(
                                          selectedDestinationInfoProvider
                                              .notifier,
                                        )
                                        .state = info;
                                    ref
                                        .read(
                                          selectedDestinationProvider.notifier,
                                        )
                                        .state = hospitalPosition;
                                  }

                                  ref.read(isLoadingProvider.notifier).state =
                                      true;
                                  // Simulate hospital permission request (mock API call)
                                  await Future.delayed(
                                    const Duration(seconds: 2),
                                  );

                                  ref.read(isLoadingProvider.notifier).state =
                                      false;

                                  // Lock the destination (if needed)
                                  // await MapController().startNavigationFlow(
                                  //   ref,
                                  // );

                                  //Pop the current Bottom sheet
                                  if (context.mounted) context.pop();

                                  //Open the new bottom sheet
                                  final scaffoldKey = ref.read(
                                    scaffoldKeyProvider,
                                  );
                                  scaffoldKey.currentState?.showBottomSheet(
                                    (context) => FirstStartModeBottomSheet(),
                                    backgroundColor: colorScheme.primary,
                                  );
                                  ref
                                      .read(isBottomSheetOpenProvider.notifier)
                                      .state = true;
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
      },
    );
  }
}
