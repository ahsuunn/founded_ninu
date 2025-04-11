import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

// Mock Position class with all required implementations
class MockPosition implements Position {
  final double latitude;
  final double longitude;

  // Implement all required Position members
  @override
  final double accuracy = 0;

  @override
  final double altitude = 0;

  @override
  final double heading = 0;

  @override
  final double speed = 0;

  @override
  final double speedAccuracy = 0;

  @override
  final DateTime timestamp = DateTime.now();

  // Additional properties required by Position
  @override
  final double altitudeAccuracy = 0;

  @override
  final int? floor = null;

  @override
  final double headingAccuracy = 0;

  @override
  final bool isMocked = true;

  @override
  Map<String, dynamic> toJson() => {
    'latitude': latitude,
    'longitude': longitude,
    'accuracy': accuracy,
    'altitude': altitude,
    'altitudeAccuracy': altitudeAccuracy,
    'heading': heading,
    'headingAccuracy': headingAccuracy,
    'speed': speed,
    'speedAccuracy': speedAccuracy,
    'floor': floor,
    'timestamp': timestamp.toIso8601String(),
    'isMocked': isMocked,
  };

  MockPosition({required this.latitude, required this.longitude});
}

// Corrected class to use AutoDisposeAsyncNotifier instead of AutoDisposeStreamNotifier
class MockLocationNotifier extends AutoDisposeAsyncNotifier<Position> {
  final _controller = StreamController<Position>.broadcast();
  Position? _lastPosition;

  @override
  FutureOr<Position> build() {
    ref.onDispose(() => _controller.close());

    // Set up listener for the stream
    _controller.stream.listen((position) {
      _lastPosition = position;
      state = AsyncData(position);
    });

    // Initial state
    return Future.value(
      _lastPosition ?? MockPosition(latitude: 0, longitude: 0),
    );
  }

  void updatePosition(double latitude, double longitude) {
    final position = MockPosition(latitude: latitude, longitude: longitude);
    _controller.add(position);
  }
}

// Mock location provider
final mockLocationStreamProvider =
    AsyncNotifierProvider.autoDispose<MockLocationNotifier, Position>(() {
      return MockLocationNotifier();
    });

// Alternative StreamProvider approach if you prefer working with streams directly
final mockLocationStreamProvider2 = StreamProvider.autoDispose<Position>((ref) {
  final controller = StreamController<Position>.broadcast();

  ref.onDispose(() => controller.close());

  // Expose controller through a provider
  ref.read(_mockStreamControllerProvider.notifier).state = controller;

  return controller.stream;
});

final _mockStreamControllerProvider =
    StateProvider<StreamController<Position>?>((ref) => null);

// A provider to control the mock position
final mockPositionControllerProvider = Provider<MockPositionController>((ref) {
  return MockPositionController(ref);
});

// Controller to update mock position
class MockPositionController {
  final Ref ref;

  MockPositionController(this.ref);

  void updatePosition(double latitude, double longitude) {
    // Use AsyncNotifier approach
    final notifier = ref.read(mockLocationStreamProvider.notifier);
    notifier.updatePosition(latitude, longitude);

    // Or use StreamController approach if you switched to that
    // final controller = ref.read(_mockStreamControllerProvider);
    // if (controller != null) {
    //   controller.add(MockPosition(latitude: latitude, longitude: longitude));
    // }
  }

  void simulateApproachToDestination(
    LatLng destination, {
    int steps = 10,
    int millisPerStep = 500,
  }) {
    // Get current position (or use a default)
    final currentLatLng =
        ref.read(currentPositionProvider) ?? const LatLng(0, 0);

    // Calculate increments for each step
    final latIncrement =
        (destination.latitude - currentLatLng.latitude) / steps;
    final lngIncrement =
        (destination.longitude - currentLatLng.longitude) / steps;

    // Simulate movement in steps
    for (int i = 1; i <= steps; i++) {
      Future.delayed(Duration(milliseconds: i * millisPerStep), () {
        final newLat = currentLatLng.latitude + (latIncrement * i);
        final newLng = currentLatLng.longitude + (lngIncrement * i);
        updatePosition(newLat, newLng);

        // For debugging
        final distance = Geolocator.distanceBetween(
          newLat,
          newLng,
          destination.latitude,
          destination.longitude,
        );
        debugPrint('Step $i: Distance to destination: $distance meters');
      });
    }
  }
}

// Store current position for reference
final currentPositionProvider = StateProvider<LatLng?>((ref) => null);

// Mock UI widget for controlling the test
class MockLocationTester extends StatelessWidget {
  const MockLocationTester({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, _) {
        final mockController = ref.watch(mockPositionControllerProvider);

        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Location Mock Controls',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {
                  // Simulate current location
                  mockController.updatePosition(
                    37.7749,
                    -122.4194,
                  ); // San Francisco
                  ref
                      .read(currentPositionProvider.notifier)
                      .state = const LatLng(37.7749, -122.4194);
                },
                child: const Text('Set Current Location'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Simulate destination selection
                  final destination = const LatLng(
                    37.7755,
                    -122.4130,
                  ); // Near SF
                  ref.read(selectedDestinationProvider.notifier).state =
                      destination;
                },
                child: const Text('Set Destination'),
              ),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  // Get the chosen destination
                  final destination = ref.read(selectedDestinationProvider);
                  if (destination != null) {
                    // Simulate approach to destination
                    mockController.simulateApproachToDestination(destination);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Please set a destination first'),
                      ),
                    );
                  }
                },
                child: const Text('Simulate Approach'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// These providers are assumed to exist in your app
// You would need to ensure they match your actual providers
final selectedDestinationProvider = StateProvider<LatLng?>((ref) => null);
final hasArrivedProvider = StateProvider<bool>((ref) => false);
final travelStateModeProvider = StateProvider<TravelStateMode>(
  (ref) => TravelStateMode.defaultMode,
);
final lockedDestinationProvider = StateProvider<LatLng?>((ref) => null);
final lockedInitialPositionProvider = StateProvider<LatLng?>((ref) => null);
final lockedStartTimeProvider = StateProvider<DateTime?>((ref) => null);
final routePolylineProvider = StateProvider<Map<String, dynamic>>((ref) => {});
final travelModeProvider = StateProvider<String>((ref) => 'driving');
final selectedDestinationInfoProvider = StateProvider<DestinationInfo?>(
  (ref) => null,
);

// Placeholder classes that should match your actual implementation
enum TravelStateMode { defaultMode, navigating }

class DestinationInfo {
  final String distance;
  final String duration;

  DestinationInfo({required this.distance, required this.duration});
}
