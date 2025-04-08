import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/ninu_icon_state_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/radiating_sirine_icon.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/first_start_mode_bottom_sheet.dart';
import 'package:go_router/go_router.dart';

class SecondBottomSheet extends ConsumerStatefulWidget {
  const SecondBottomSheet({super.key});

  @override
  ConsumerState<SecondBottomSheet> createState() => _SecondBottomSheetState();
}

class _SecondBottomSheetState extends ConsumerState<SecondBottomSheet> {
  bool isBluetoothOn = false;
  bool isActivated = false;

  @override
  Widget build(BuildContext context) {
    final sirineState = ref.watch(sirineStateProvider);
    final sirineNotifier = ref.read(sirineStateProvider.notifier);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        spacing: 4,
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
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
              color:
                  sirineState.isBluetoothOn || sirineState.isActivated
                      ? Colors.white
                      : Colors.white54,
              borderRadius: BorderRadius.circular(100),
            ),
            child:
                sirineState.isActivated
                    ? RadiatingSirineIcon(
                      onTap: () {
                        sirineNotifier.deactivateSirine();
                      },
                    )
                    : IconButton(
                      iconSize: 120,
                      icon: Icon(
                        sirineState.isActivated
                            ? Icons.wifi_tethering
                            : Icons.power_settings_new_rounded,
                        color: colorScheme.primary,
                      ),
                      onPressed:
                          sirineState.isBluetoothOn
                              ? () {
                                sirineNotifier.activateSirine();
                              }
                              : null,
                    ),
          ),
          Text(
            sirineState.isActivated
                ? "Sirine is running"
                : sirineState.isBluetoothOn
                ? "Press to Activate Sirine"
                : "Pair Device",
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (!sirineState.isActivated)
            Text(
              sirineState.isBluetoothOn
                  ? "Device Connected"
                  : "Make sure your device is on and nearby",
              style: const TextStyle(color: Colors.white70),
            ),
          Row(
            spacing: 12,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      sirineState.isBluetoothOn
                          ? Colors.orange
                          : const Color(0xA0AF3231),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                ),
                onPressed: () {
                  sirineNotifier.toggleBluetooth(!sirineState.isBluetoothOn);
                },
                icon: const Icon(Icons.bluetooth, color: Colors.white),
                label: Text(
                  "Bluetooth",
                  style: TextStyle(
                    color:
                        sirineState.isBluetoothOn
                            ? colorScheme.primary
                            : Colors.white,
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Colors.white,
                ),
                child: Icon(
                  Icons.notifications_active,
                  color: colorScheme.primary,
                  size: 28,
                ),
              ),
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
                child: const Text(
                  "Back",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
