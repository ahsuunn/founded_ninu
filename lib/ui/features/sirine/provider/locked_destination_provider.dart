import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/locked_address.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

final lockedDestinationProvider = StateProvider<LockedAddress?>((ref) => null);
