import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/map_controller.dart';

class MapFloatingButtons extends ConsumerWidget {
  final MapController controller;
  const MapFloatingButtons({required this.controller, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final travelMode = ref.watch(travelModeProvider);
    final isBottomSheetOpen = ref.watch(isBottomSheetOpenProvider);
    print("Bottom Sheet Opens $isBottomSheetOpen");

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: isBottomSheetOpen ? 260 : 130,
              right: 20,
            ),
            child: FloatingActionButton(
              heroTag: "fab1",
              onPressed: controller.moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ),

        // Motorcycle Button
        isBottomSheetOpen
            ? AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom: isBottomSheetOpen ? 260 : 0,
              left: 20,
              child: FloatingActionButton(
                backgroundColor:
                    (travelMode == "two-wheeled")
                        ? Color(0xFFFDAB33)
                        : Color(0x80FDAB33),
                heroTag: "fab2",
                onPressed:
                    () =>
                        ref.read(travelModeProvider.notifier).state =
                            "two-wheeled",
                child: const Icon(Icons.motorcycle_sharp, color: Colors.black),
              ),
            )
            : SizedBox(),

        // Car Button
        isBottomSheetOpen
            ? AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              bottom: isBottomSheetOpen ? 330 : 0,
              left: 20,
              child: FloatingActionButton(
                backgroundColor:
                    (travelMode == "driving")
                        ? Color(0xFFFDAB33)
                        : Color(0x80FDAB33),
                heroTag: "fab3",
                onPressed:
                    () =>
                        ref.read(travelModeProvider.notifier).state = "driving",
                child: const Icon(
                  Icons.directions_car_outlined,
                  color: Color(0xA0000000),
                ),
              ),
            )
            : SizedBox(),
      ],
    );
  }
}
