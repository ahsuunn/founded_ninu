import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:geocoding/geocoding.dart';

class MapSnippet extends ConsumerWidget {
  MapSnippet({super.key});
  final Dio dio = Dio();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPosition = ref.watch(locationProvider);

    if (userPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      ); // Show loader if location is null
    }

    final placemarkAsync = ref.watch(placemarkProvider);

    double lat = userPosition.latitude;
    double lng = userPosition.longitude;

    String staticMapUrl =
        "https://maps.googleapis.com/maps/api/staticmap"
        "?center=$lat,$lng"
        "&zoom=16"
        "&size=800x300"
        "&maptype=roadmap"
        "&markers=color:red%7Clabel:You%7C$lat,$lng" // User marker
        "&key=${AppKeys.mapsApiKey}";

    return Container(
      width: double.infinity,
      height: 175,
      decoration: BoxDecoration(
        color: Colors.white, // Change this to match the design
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            spreadRadius: 2,
            offset: Offset(2, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: SizedBox(
          child: Stack(
            children: [
              Center(
                child: Image.network(staticMapUrl, width: double.infinity),
              ), // Icon Placeholder
              Stack(
                // mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity, // Adjust width as needed
                    height: 50,
                    color: Color(0x5Fbdbdbd), // Placeholder effect
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8, right: 4.0, top: 8),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 35,
                          height: 35,
                          decoration: BoxDecoration(
                            color: colorScheme.primary,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Icon(
                            Icons.location_on_outlined,
                            color: Colors.white,
                            size: 22,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 4.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Current location",
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey[800],
                                ),
                              ),
                              // Text("Address"),
                              placemarkAsync.when(
                                data: (address) {
                                  if (address.isEmpty) {
                                    return const Text("No address found.");
                                  }
                                  return Text(
                                    "${address.first.street}",
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                                loading:
                                    () => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                error: (err, stack) => Text("Error: $err"),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 4),
                ],
              ),

              Positioned(
                bottom: 10,
                right: 10,
                child: IconButton(
                  style: ButtonStyle(
                    backgroundColor: WidgetStatePropertyAll(
                      colorScheme.primary,
                    ),
                  ),
                  onPressed:
                      () => {
                        ref.read(locationProvider.notifier).refreshLocation(),
                      },
                  icon: Icon(Icons.refresh_rounded, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
