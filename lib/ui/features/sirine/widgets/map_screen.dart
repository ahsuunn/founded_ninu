import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:founded_ninu/config/keys.dart';
import 'package:founded_ninu/data/services/map_services.dart';
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
  final String apiKey = AppKeys.mapsApiKey;

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

  Future<void> _getUserLocation() async {
    try {
      Position position = await LocationService().getCurrentLocation();
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
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
            markers: {
              if (_currentPosition.latitude != 0 ||
                  _currentPosition.longitude != 0)
                Marker(
                  markerId: const MarkerId("currentLocation"),
                  position: _currentPosition,
                ),
              if (_destination != _currentPosition)
                Marker(
                  markerId: const MarkerId("destination"),
                  position: _destination,
                ),
            },
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
            bottom: 120,
            right: 20,
            child: FloatingActionButton(
              onPressed: _moveToCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),
    );
  }
}
