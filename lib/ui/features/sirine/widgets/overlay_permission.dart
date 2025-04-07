import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/overlay_prompt_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/second_start_mode_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class OverlayPromptWidget extends ConsumerWidget {
  final String message;
  final String buttonText;

  const OverlayPromptWidget({
    super.key,
    required this.message,
    required this.buttonText,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Stack(
      children: [
        // Block background interaction
        const ModalBarrier(dismissible: false, color: Colors.black54),

        // Foreground content
        Center(
          child: Stack(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 40),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(
                      height: 24,
                    ), // Reserve space for the X button
                    Text(
                      message,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: (() {
                        ref.read(showOverlayPromptProvider.notifier).state =
                            false;
                        context.pop(); //Remove current bottom sheet
                        ref.read(activeBottomSheetProvider.notifier).state =
                            ActiveBottomSheet.secondStart;
                        final scaffoldKey = ref.read(scaffoldKeyProvider);
                        scaffoldKey.currentState
                            ?.showBottomSheet(
                              (context) => SecondBottomSheet(),
                              backgroundColor: colorScheme.primary,
                            )
                            .closed
                            .then((_) {
                              if (!context.mounted) return;
                              ref
                                  .read(activeBottomSheetProvider.notifier)
                                  .state = ActiveBottomSheet.none;
                            });
                      }),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: colorScheme.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                      ),
                      child: Text(
                        buttonText,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              // X button positioned in top-right corner of the container
              Positioned(
                right: 42,
                top: 4,
                child: IconButton(
                  icon: const Icon(Icons.cancel_outlined),
                  color: Colors.white,
                  onPressed:
                      () =>
                          ref.read(showOverlayPromptProvider.notifier).state =
                              false,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
