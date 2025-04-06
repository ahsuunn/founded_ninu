import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/hospital_info.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/bottomsheet_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/marker_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/scaffold_provider.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:founded_ninu/data/services/location_services.dart';
import 'package:founded_ninu/data/services/map_services.dart';
import 'package:founded_ninu/domain/entities/destination_info.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/hospital_bottom_sheet.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/custom_icon.dart';
import 'package:founded_ninu/config/keys.dart';

class MapController {
  GoogleMapController? mapController;
  LatLng currentPosition = const LatLng(0, 0);
  LatLng lastLocation = const LatLng(0, 0);
  Set<Marker> markers = {};
  bool isBottomSheetVisible = false;

  final String apiKey = AppKeys.mapsApiKey;

  void initialize(WidgetRef ref) {
    _getUserLocation(ref);
  }

  Future<void> _getUserLocation(WidgetRef ref) async {
    final markers = ref.read(markersProvider.notifier); //Trigger rebuild
    final markerSet = ref.read(markersProvider); //Adds marker

    try {
      final position = await LocationService().getCurrentLocation();
      final customIcon = await createCustomMarkerIcon(
        Icons.place,
        colorScheme.primary,
        100.0,
      );

      currentPosition = LatLng(position.latitude, position.longitude);
      moveToCurrentLocation();
      markerSet.add(
        Marker(
          markerId: const MarkerId("Current Location"),
          position: currentPosition,
          icon: customIcon,
          infoWindow: const InfoWindow(title: "Your Current Location"),
        ),
      );
      markers.state = {...markerSet};

      await _fetchHospitalsMarker(ref);
    } catch (e) {
      debugPrint("Location Error: $e");
    }
  }

  Future<void> _fetchHospitalsMarker(WidgetRef ref) async {
    final markers = ref.read(markersProvider.notifier);
    final markerSet = ref.read(markersProvider);

    final hospitals = await GoogleMapsService().getNearbyHospitals(
      currentPosition.latitude,
      currentPosition.longitude,
    );

    final customIcon = await createCustomMarkerIcon(
      Icons.local_hospital_outlined,
      colorScheme.primary,
      90.0,
    );

    for (var hospital in hospitals) {
      final hospitalName = hospital['name'] ?? "";
      if (!MapUsecase().isHospital(hospitalName)) continue;

      final hospitalLat = hospital['geometry']['location']['lat'];
      final hospitalLng = hospital['geometry']['location']['lng'];
      final hospitalPosition = LatLng(hospitalLat, hospitalLng);

      final marker = Marker(
        markerId: MarkerId(hospital['place_id']),
        position: hospitalPosition,
        icon: customIcon,
        infoWindow: InfoWindow(
          title: hospitalName,
          snippet: hospital['vicinity'],
        ),
        onTap: () async {
          final placeId = hospital['place_id'];
          final mode = ref.read(travelModeProvider);
          final data = await MapUsecase().fetchRoute(
            currentPosition,
            hospitalPosition,
            mode: mode,
          );
          final info = DestinationInfo(
            distance: data['distance'],
            duration: data['duration'],
          );
          ref.read(selectedDestinationInfoProvider.notifier).state = info;

          //Notify FAB positioning
          ref.read(activeBottomSheetProvider.notifier).state =
              ActiveBottomSheet.hospital;

          //Notify which marker is chosen
          ref.read(selectedMarkerIdProvider.notifier).state = placeId;

          // Show bottom sheet
          final scaffoldKey = ref.read(scaffoldKeyProvider);
          scaffoldKey.currentState
              ?.showBottomSheet(
                (context) => HospitalBottomSheet(
                  hospitalName: hospitalName,
                  hospitalVicinity: hospital['vicinity'],
                  onSetDirection: () async {
                    final updatedData = await MapUsecase().fetchRoute(
                      currentPosition,
                      hospitalPosition,
                      mode: mode,
                    );
                    ref
                        .read(selectedDestinationInfoProvider.notifier)
                        .state = DestinationInfo(
                      distance: updatedData['distance'],
                      duration: updatedData['duration'],
                    );
                    ref.read(selectedDestinationProvider.notifier).state =
                        hospitalPosition;
                    debugPrint("CURRENT HOSPITAL POSTIION : $hospitalPosition");
                  },
                ),
                backgroundColor: colorScheme.primary,
              )
              .closed
              .then(
                (_) => {
                  ref.read(activeBottomSheetProvider.notifier).state =
                      ActiveBottomSheet.none,
                  ref.read(selectedMarkerIdProvider.notifier).state = null,
                },
              );
        },
      );
      final positionsNotifier = ref.read(
        hospitalMarkerPositionsProvider.notifier,
      );
      final currentMap = Map<String, HospitalInfo>.from(
        positionsNotifier.state,
      );
      currentMap[hospital['place_id']] = HospitalInfo(
        name: hospitalName,
        position: hospitalPosition,
      );
      positionsNotifier.state = currentMap;

      markerSet.add(marker);
      markers.state = {...markerSet};
    }
  }

  void moveToCurrentLocation() {
    if (mapController != null) {
      mapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(target: currentPosition, zoom: 15.0),
        ),
      );
    }
  }
}
