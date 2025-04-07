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
    final activeBottomSheet = ref.watch(activeBottomSheetProvider);
    print("Active Bottom Sheet: $activeBottomSheet");

    return Stack(
      children: [
        Align(
          alignment: Alignment.bottomRight,
          child: Padding(
            padding: EdgeInsets.only(
              bottom: (activeBottomSheet != ActiveBottomSheet.none) ? 260 : 130,
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
        (activeBottomSheet == ActiveBottomSheet.hospital)
            ? AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              bottom:
                  (activeBottomSheet == ActiveBottomSheet.hospital) ? 260 : 0,
              left: 20,
              child: FloatingActionButton(
                backgroundColor:
                    (travelMode == "motorcycle")
                        ? Color(0xFFFDAB33)
                        : Color(0x80FDAB33),
                heroTag: "fab2",
                onPressed:
                    () =>
                        ref.read(travelModeProvider.notifier).state =
                            "motorcycle",
                child: const Icon(Icons.motorcycle_sharp, color: Colors.black),
              ),
            )
            : SizedBox(),

        // Car Button
        (activeBottomSheet == ActiveBottomSheet.hospital)
            ? AnimatedPositioned(
              duration: const Duration(milliseconds: 100),
              bottom:
                  (activeBottomSheet == ActiveBottomSheet.hospital) ? 330 : 0,
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
