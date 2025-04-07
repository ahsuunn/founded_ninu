import 'package:flutter_riverpod/flutter_riverpod.dart';

final travelStateModeProvider = StateProvider<TravelStateMode>(
  (ref) => TravelStateMode.defaultMode,
);

enum TravelStateMode { defaultMode, startMode }
