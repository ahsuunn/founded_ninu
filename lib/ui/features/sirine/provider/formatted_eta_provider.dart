import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:founded_ninu/domain/use_cases/time.dart';
import 'package:founded_ninu/ui/features/sirine/provider/location_stream_provider.dart';

final formattedETAProvider = Provider<String>((ref) {
  final destinationInfo = ref.watch(selectedDestinationInfoProvider);
  final startTime =
      DateTime.now(); // or ref.watch(lockedStartTimeProvider) if you want a fixed start time
  final durationStr = destinationInfo?.duration;

  Duration travelDuration = Duration.zero;
  if (durationStr != null) {
    travelDuration = parseDuration(durationStr);
  }

  final eta = startTime.add(travelDuration);
  return formatTime(eta); // Your formatting function, e.g., hh:mm a
});
