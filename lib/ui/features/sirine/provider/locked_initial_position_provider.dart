import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/entities/locked_address.dart';

final lockedInitialPositionProvider = StateProvider<LockedAddress?>(
  (ref) => null,
);
