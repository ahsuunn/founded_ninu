import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:founded_ninu/data/services/map_services.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/core/routing.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/custom_icon.dart';
import 'package:founded_ninu/ui/features/sirine/widgets/hospital_bottom_sheet.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:founded_ninu/data/services/location_services.dart';

final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  LatLng _lastLocation = LatLng(0, 0);
  Set<Marker> markers = {};
  Set<Marker> tempMarkers = {}; // ✅ Temporary list to store markers
  final String apiKey = AppKeys.mapsApiKey;
  bool _isBottomSheetVisible = false;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  void dispose() {
    super.dispose();
    _mapController?.dispose();
  }

  Future<void> _fetchHospitalsMarker() async {
    List<dynamic> hospitals = await GoogleMapsService().getNearbyHospitals(
      _currentPosition.latitude,
      _currentPosition.longitude,
    );
    final customIcon = await createCustomMarkerIcon(
      Icons.local_hospital_outlined,
      colorScheme.primary,
      90.0,
    );

    for (var hospital in hospitals) {
      String hospitalName = hospital['name'] ?? "";
      if (MapUsecase().isHospital(hospitalName)) {
        double hospitalLat = hospital['geometry']['location']['lat'];
        double hospitalLng = hospital['geometry']['location']['lng'];
        Marker hospitalMarker = Marker(
          markerId: MarkerId(
            hospital['place_id'],
          ), // ✅ Unique ID for each marker
          position: LatLng(hospitalLat, hospitalLng),
          infoWindow: InfoWindow(
            // ✅ Show hospital name
            title: hospital['name'],
            snippet: hospital['vicinity'],
          ),
          icon: customIcon,
          onTap: () {
            setState(() => _isBottomSheetVisible = true);

            _scaffoldKey.currentState
                ?.showBottomSheet(
                  (context) => HospitalBottomSheet(
                    hospitalName: hospitalName,
                    hospitalVicinity: hospital['vicinity'],
                    onSetDirection: () {
                      ref
                          .read(selectedDestinationProvider.notifier)
                          .state = LatLng(hospitalLat, hospitalLng);
                      router.pop(context);
                    },
                  ),
                  backgroundColor: colorScheme.primary, // Optional
                )
                .closed
                .then((_) {
                  setState(() {
                    _isBottomSheetVisible = false;
                  });
                });
          },
        );
        tempMarkers.add(hospitalMarker); // ✅ Add marker to temporary list
      }
    }
    setState(() {
      markers.addAll(tempMarkers); // ✅ Update state with new markers
    });
  }

  Future<void> _getUserLocation() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        markers.add(
          Marker(
            markerId: MarkerId("Current Location"),
            position: LatLng(
              _currentPosition.latitude,
              _currentPosition.longitude,
            ),
            icon: BitmapDescriptor.defaultMarkerWithHue(
              BitmapDescriptor.hueAzure,
            ),
            infoWindow: InfoWindow(title: "Your Current Location"),
          ),
        );
      });
      _fetchHospitalsMarker();
      // Move camera to the new location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition, zoom: 14.0),
          ),
        );
      }
    } catch (e) {}
  }

  void _moveToCurrentLocation() {
    if (_mapController != null) {
      _mapController!.animateCamera(CameraUpdate.newLatLng(_currentPosition));
    }
  }

  @override
  Widget build(BuildContext context) {
    // Getting user current location and address
    final userPosition = ref.watch(locationProvider);
    if (userPosition == null) {
      return const Center(
        child: CircularProgressIndicator(),
      ); // Show loader if location is null
    }
    final placemarkAsync = ref.watch(placemarkProvider);
    final selectedDestination = ref.watch(selectedDestinationProvider);
    ref.listen<AsyncValue<Position>>(userLocationStreamProvider, (_, next) {
      next.whenData((pos) {
        // Update camera position on user movement
        final newLocation = LatLng(pos.latitude, pos.longitude);
        if (_lastLocation == LatLng(0, 0) || _lastLocation != newLocation) {
          _mapController?.animateCamera(CameraUpdate.newLatLng(newLocation));
        }

        // Update the route polyline dynamically
        updateRoutePolyline(
          ref,
          LatLng(pos.latitude, pos.longitude), // Current user location
          selectedDestination!, // Your selected hospital or destination
        );
        _lastLocation = newLocation;
      });
    });

    ref.listen<LatLng?>(selectedDestinationProvider, (previous, next) async {
      final userPos = ref.read(locationProvider);
      if (userPos != null && next != null) {
        updateRoutePolyline(
          ref,
          LatLng(userPos.latitude, userPos.longitude),
          next,
        );

        // Optionally move camera to destination
        _mapController?.animateCamera(CameraUpdate.newLatLng(next));
      }
    });

    return Stack(
      children: [
        Scaffold(
          key: _scaffoldKey,
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.only(left: 12.0),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_rounded, fill: 1, size: 32),
                onPressed: () => context.pop(),
              ),
            ),
            title: Padding(
              padding: const EdgeInsets.only(right: 4.0),
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
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Current location",
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey[800],
                          ),
                        ),
                        placemarkAsync.when(
                          data: (address) {
                            if (address.isEmpty) {
                              return const Text("No address found.");
                            }
                            return Text(
                              "${address.first.street}",
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
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
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
          body: GoogleMap(
            zoomControlsEnabled: false,
            initialCameraPosition: CameraPosition(
              target:
                  _currentPosition.latitude != 0 ||
                          _currentPosition.longitude != 0
                      ? _currentPosition
                      : LatLng(
                        37.7749,
                        -122.4194,
                      ), // Default position until we get real location
              zoom: 14.0,
            ),
            markers: markers,
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // We have the controller, now get the location if we don't have it yet
              if (_currentPosition.latitude == 0 &&
                  _currentPosition.longitude == 0) {
                _getUserLocation();
              }
            },
            polylines: ref.watch(routePolylineProvider),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          bottom: _isBottomSheetVisible ? 260 : 60,
          right: 20,
          child: FloatingActionButton(
            heroTag: "fab1",
            onPressed: _moveToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
        AnimatedPositioned(
          duration: const Duration(milliseconds: 100),
          bottom: _isBottomSheetVisible ? 330 : 130,
          right: 20,
          child: FloatingActionButton(
            heroTag: "fab2",
            onPressed: _fetchHospitalsMarker,
            child: const Icon(Icons.local_hospital_rounded),
          ),
        ),
      ],
    );
  }
}
