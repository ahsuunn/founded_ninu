import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:founded_ninu/data/services/map_services.dart';
import 'package:founded_ninu/domain/use_cases/map_usecase.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:founded_ninu/data/services/location_services.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
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
            icon: BitmapDescriptor.defaultMarkerWithHue(20),
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
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
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
      ),
    );
  }
}
