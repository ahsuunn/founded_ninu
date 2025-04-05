import 'package:flutter/material.dart';

class HospitalBottomSheet extends StatelessWidget {
  final String hospitalName;
  final String hospitalVicinity;
  final String distance;
  final String duration;
  final VoidCallback onSetDirection;

  const HospitalBottomSheet({
    super.key,
    required this.hospitalName,
    required this.hospitalVicinity,
    required this.distance,
    required this.duration,
    required this.onSetDirection,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
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
                            hospitalName,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            hospitalVicinity,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            distance,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            duration,
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
                                onPressed: onSetDirection,
                                icon: const Icon(Icons.directions),
                                label: const Text("Direction"),
                              ),
                              ElevatedButton.icon(
                                onPressed: () => {},
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
