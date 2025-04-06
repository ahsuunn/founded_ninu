import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/second_start_mode_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class FirstStartModeBottomSheet extends ConsumerWidget {
  const FirstStartModeBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("You're now in Start Mode"),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              context.pop(); // close current

              final scaffoldKey = ref.read(scaffoldKeyProvider);
              scaffoldKey.currentState?.showBottomSheet(
                (context) => SecondBottomSheet(),
                backgroundColor: colorScheme.primary,
              );
            },
            child: const Text("Next"),
          ),
        ],
      ),
    );
  }
}
