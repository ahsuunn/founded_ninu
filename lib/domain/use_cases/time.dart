Duration parseDuration(String durationStr) {
  final regex = RegExp(
    r'(\d+)\s*(hour|minute|min|hours|minutes)',
    caseSensitive: false,
  );
  final matches = regex.allMatches(durationStr);

  int hours = 0;
  int minutes = 0;

  for (final match in matches) {
    final value = int.parse(match.group(1)!);
    final unit = match.group(2)!.toLowerCase();

    if (unit.contains('hour')) {
      hours += value;
    } else if (unit.contains('min')) {
      minutes += value;
    }
  }

  return Duration(hours: hours, minutes: minutes);
}

String formatTime(DateTime time) {
  return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
}
