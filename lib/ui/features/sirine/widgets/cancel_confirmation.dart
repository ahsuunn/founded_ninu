import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/cancel_confirmation_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_destination_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_initial_position_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/locked_starttime_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/travel_state_provider.dart';
import 'package:go_router/go_router.dart';

class CancelConfirmationDialog extends ConsumerWidget {
  const CancelConfirmationDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Modal barrier to prevent background interaction
        Positioned.fill(
          child: ModalBarrier(color: Colors.black54, dismissible: false),
        ),

        // Dialog itself
        Center(
          child: AlertDialog(
            shadowColor: Colors.black,
            backgroundColor: colorScheme.primary,
            title: Text(
              "Are you sure?",
              style: TextStyle(color: colorScheme.tertiary),
            ),
            content: Text(
              "Do you want to cancel this emergency?",
              style: TextStyle(color: colorScheme.tertiary),
            ),
            actions: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.tertiary,
                ),
                onPressed: () {
                  ref.read(showCancelConfirmationProvider.notifier).state =
                      false;
                },
                child: Text("No", style: TextStyle(color: colorScheme.primary)),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xAFAF3231),
                ),
                onPressed: () {
                  // Perform reset
                  ref.read(travelStateModeProvider.notifier).state =
                      TravelStateMode.defaultMode;
                  ref.read(lockedDestinationProvider.notifier).state = null;
                  ref.read(selectedDestinationProvider.notifier).state = null;
                  ref.read(lockedInitialPositionProvider.notifier).state = null;
                  ref.read(lockedStartTimeProvider.notifier).state = null;
                  ref.read(routePolylineProvider.notifier).state = {};

                  // Hide the dialog
                  ref.read(showCancelConfirmationProvider.notifier).state =
                      false;

                  // Optionally close bottom sheet
                  context.pop();
                  ref.watch(activeBottomSheetProvider.notifier).state =
                      ActiveBottomSheet.none;
                },
                child: Text(
                  "Yes",
                  style: TextStyle(color: colorScheme.tertiary),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
