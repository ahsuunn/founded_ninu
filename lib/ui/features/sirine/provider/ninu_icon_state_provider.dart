// sirine_state.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SirineState {
  final bool isBluetoothOn;
  final bool isActivated;

  SirineState({this.isBluetoothOn = false, this.isActivated = false});

  SirineState copyWith({bool? isBluetoothOn, bool? isActivated}) {
    return SirineState(
      isBluetoothOn: isBluetoothOn ?? this.isBluetoothOn,
      isActivated: isActivated ?? this.isActivated,
    );
  }
}

class SirineStateNotifier extends StateNotifier<SirineState> {
  SirineStateNotifier() : super(SirineState());

  void toggleBluetooth(bool value) {
    state = state.copyWith(isBluetoothOn: value);
    if (!value) {
      // Reset sirine if Bluetooth is turned off
      state = state.copyWith(isActivated: false);
    }
  }

  void activateSirine() {
    if (state.isBluetoothOn) {
      state = state.copyWith(isActivated: true);
    }
  }

  void deactivateSirine() {
    state = state.copyWith(isActivated: false);
  }
}

final sirineStateProvider =
    StateNotifierProvider<SirineStateNotifier, SirineState>(
      (ref) => SirineStateNotifier(),
    );
