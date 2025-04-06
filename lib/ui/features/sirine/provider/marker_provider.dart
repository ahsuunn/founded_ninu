import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/hospital_info.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final markersProvider = StateProvider<Set<Marker>>((ref) => {});
final selectedMarkerIdProvider = StateProvider<String?>((ref) => null);
final hospitalMarkerPositionsProvider =
    StateProvider<Map<String, HospitalInfo>>((ref) => {});
