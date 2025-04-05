import 'package:flutter_riverpod/flutter_riverpod.dart';

final isBottomSheetOpenProvider = StateProvider<bool>((ref) => false);
final fabOffsetProvider = StateProvider<double>((ref) => 100); // default offset
