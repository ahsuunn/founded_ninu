class DestinationInfo {
  final String distance;
  final String duration;

  DestinationInfo({required this.distance, required this.duration});

  DestinationInfo copyWith({String? distance, String? duration}) {
    return DestinationInfo(
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
    );
  }
}
