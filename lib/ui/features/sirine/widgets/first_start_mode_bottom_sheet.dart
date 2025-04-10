import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/entities/locked_address.dart';
import 'package:founded_ninu/domain/use_cases/time.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/formatted_eta_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_destination_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_initial_position_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_starttime_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/travel_state_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/large_button_icons.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/second_start_mode_bottom_sheet.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/timeline_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class FirstStartModeBottomSheet extends ConsumerStatefulWidget {
  const FirstStartModeBottomSheet({super.key});

  @override
  ConsumerState<FirstStartModeBottomSheet> createState() =>
      _FirstStartModeBottomSheetState();
}

class _FirstStartModeBottomSheetState
    extends ConsumerState<FirstStartModeBottomSheet> {
  @override
  Widget build(BuildContext context) {
    DestinationInfo? destinationInfo = ref.watch(
      selectedDestinationInfoProvider,
    );
    String? duration = destinationInfo?.duration;
    String? distance = destinationInfo?.distance;
    LockedAddress? finalDestination = ref.watch(lockedDestinationProvider);
    LockedAddress? finalInitalPosition = ref.watch(
      lockedInitialPositionProvider,
    );

    // Declare and initialize travelDuration safely
    // print("NOW: $now");
    // print("ETA $eta");

    final startTime = ref.watch(lockedStartTimeProvider);
    String formattedStartTime = "";
    if (startTime != null) {
      formattedStartTime = formatTime(startTime);
    }
    final formattedETA = ref.watch(formattedETAProvider);

    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 5,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),

                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              "Distance",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              distance ?? "-",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                            ),
                          ),
                          TimelineWidget(
                            fromLocation: finalDestination?.name ?? "...",
                            toLocation: finalInitalPosition?.name ?? "...",
                            fromTime: formattedStartTime,
                            toTime: formattedETA,
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 12,
                        children: [
                          Text(
                            "Travel Time $duration",
                            style: TextStyle(color: Colors.white),
                          ),
                          LargeIconButton(
                            onPressed: (() {
                              // context.pop();

                              // final container = ProviderScope.containerOf(
                              //   context,
                              // ); // this is NOT tied to widget lifetime
                              SchedulerBinding.instance.addPostFrameCallback((
                                _,
                              ) {
                                ref
                                    .read(activeBottomSheetProvider.notifier)
                                    .state = ActiveBottomSheet.secondStart;
                                final scaffoldKey = ref.read(
                                  scaffoldKeyProvider,
                                );
                                scaffoldKey.currentState?.showBottomSheet(
                                  (context) => SecondBottomSheet(),
                                  backgroundColor: colorScheme.primary,
                                );
                                // .closed
                                // .then((_) {
                                //   ref
                                //       .read(
                                //         activeBottomSheetProvider.notifier,
                                //       )
                                //       .state = ActiveBottomSheet.none;
                                // });
                              });
                            }),
                            icon: Icon(Icons.notifications_active, size: 38),
                            label: Text(
                              "SIRINE",
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: colorScheme.tertiary,
                          ),
                          LargeIconButton(
                            onPressed: (() => context.pop()),
                            icon: Icon(
                              Icons.videocam_sharp,
                              size: 40,
                              color: Colors.black,
                            ),
                            label: Text(
                              "Video Call",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            backgroundColor: Color(0xFFFAC068),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned(
              top: 0,
              right: 5,
              child: IconButton(
                onPressed: () {
                  ref.read(travelStateModeProvider.notifier).state =
                      TravelStateMode.defaultMode;
                  ref.read(lockedDestinationProvider.notifier).state = null;
                  ref.read(selectedDestinationProvider.notifier).state = null;
                  ref.read(lockedInitialPositionProvider.notifier).state = null;
                  ref.read(lockedStartTimeProvider.notifier).state = null;
                  ref.read(routePolylineProvider.notifier).state = {};
                  context.pop();
                },
                icon: Icon(Icons.cancel_outlined, color: colorScheme.tertiary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
