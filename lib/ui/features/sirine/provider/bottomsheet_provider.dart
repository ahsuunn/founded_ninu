import 'package:flutter_riverpod/flutter_riverpod.dart';

enum ActiveBottomSheet { none, hospital, firstStart, secondStart }

// final isBottomSheetOpenProvider = StateProvider<bool>((ref) => false);
final fabOffsetProvider = StateProvider<double>((ref) => 100); // default offset
final activeBottomSheetProvider = StateProvider<ActiveBottomSheet>(
  (ref) => ActiveBottomSheet.none,
);

void handleBottomSheetClosed({
  required Future<void> closedFuture,
  required ProviderContainer container,
}) {
  closedFuture.then((_) {
    container.read(activeBottomSheetProvider.notifier).state =
        ActiveBottomSheet.none;
  });
}
