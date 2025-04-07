import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/first_start_mode_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class SecondBottomSheet extends ConsumerWidget {
  const SecondBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You’re now in the second bottom sheet"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              // context.pop(); // close current

              SchedulerBinding.instance.addPostFrameCallback((_) {
                ref.read(activeBottomSheetProvider.notifier).state =
                    ActiveBottomSheet.firstStart;
                final scaffoldKey = ref.read(scaffoldKeyProvider);
                scaffoldKey.currentState?.showBottomSheet(
                  (context) => FirstStartModeBottomSheet(),
                  backgroundColor: colorScheme.primary,
                );
                // .closed
                // .then((_) {
                //   ref.read(activeBottomSheetProvider.notifier).state =
                //       ActiveBottomSheet.none;
                // });
              });
            },
            child: const Text("Back"),
          ),
        ],
      ),
    );
  }
}
