import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:founded_ninu/data/services/map_services.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:founded_ninu/ui/core/themes.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_provider.dart';
import 'package:geocoding/geocoding.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:founded_ninu/data/services/location_services.dart';

class MapScreen extends ConsumerStatefulWidget {
  const MapScreen({super.key});

  @override
  ConsumerState<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends ConsumerState<MapScreen> {
  GoogleMapController? _mapController;
  LatLng _currentPosition = const LatLng(0, 0);
  LatLng _destination = const LatLng(
    37.7749,
    -122.4194,
  ); // Default (San Francisco)
  List<LatLng> _routePoints = [];
  Set<Marker> markers = {};
  final String apiKey = AppKeys.mapsApiKey;

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    _fetchHospitalsMarker();
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

    Set<Marker> newMarkers = {}; // ✅ Temporary list to store markers

    for (var hospital in hospitals) {
      String hospitalName = hospital['name'] ?? "";
      if (MapUsecase().isHospital(hospitalName)) {
        print(hospitalName);
        Marker hospitalMarker = Marker(
          markerId: MarkerId(
            hospital['place_id'],
          ), // ✅ Unique ID for each marker
          position: LatLng(
            hospital['geometry']['location']['lat'],
            hospital['geometry']['location']['lng'],
          ),
          infoWindow: InfoWindow(
            // ✅ Show hospital name
            title: hospital['name'],
            snippet: hospital['vicinity'],
          ),
        );
        newMarkers.add(hospitalMarker); // ✅ Add marker to temporary list
      }
    }
    setState(() {
      markers.addAll(newMarkers); // ✅ Update state with new markers
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
          ),
        );
      });

      // Fetch the address
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address =
            "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";

        print("Current Address: $address");
      }

      // Move camera to the new location
      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: _currentPosition, zoom: 14.0),
          ),
        );
      }
    } catch (e) {
      print("Error fetching location: $e");
    }
  }

  Future<void> _setDestination(LatLng newDestination) async {
    setState(() {
      _destination = newDestination;
    });

    await _drawRoute();
  }

  Future<void> _drawRoute() async {
    PolylinePoints polylinePoints = PolylinePoints();
    List<LatLng> route = [];

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: AppKeys.mapsApiKey,
      request: PolylineRequest(
        origin: PointLatLng(
          _currentPosition.latitude,
          _currentPosition.longitude,
        ),
        destination: PointLatLng(_destination.latitude, _destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      for (var point in result.points) {
        route.add(LatLng(point.latitude, point.longitude));
      }
    }

    setState(() {
      _routePoints = route;
    });
  }

  void _moveToCurrentLocation() {
    print("MapController: $_mapController");

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

    return Stack(
      children: [
        Scaffold(
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
            //  {
            // if (_currentPosition.latitude != 0 ||
            //     _currentPosition.longitude != 0)
            //   Marker(
            //     markerId: const MarkerId("currentLocation"),
            //     position: _currentPosition,
            //   ),
            // },
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
              // We have the controller, now get the location if we don't have it yet
              if (_currentPosition.latitude == 0 &&
                  _currentPosition.longitude == 0) {
                _getUserLocation();
              }
            },
            polylines:
                _routePoints.isNotEmpty
                    ? {
                      Polyline(
                        polylineId: const PolylineId("route"),
                        points: _routePoints,
                        color: Colors.blue,
                        width: 5,
                      ),
                    }
                    : {},
          ),
        ),
        Positioned(
          bottom: 60,
          right: 20,
          child: FloatingActionButton(
            heroTag: "fab1",
            onPressed: _moveToCurrentLocation,
            child: const Icon(Icons.my_location),
          ),
        ),
        Positioned(
          bottom: 140,
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
