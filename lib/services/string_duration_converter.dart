import 'package:freezed_annotation/freezed_annotation.dart';

class StringDurationConverter implements JsonConverter<Duration, String> {
  const StringDurationConverter();

  @override
  Duration fromJson(String json) {
    final parts = json.split(':');

    if (parts.length == 3) {
      return Duration(
        hours: int.parse(parts[0]),
        minutes: int.parse(parts[1]),
        seconds: int.parse(parts[2].split('.')[0]),
      );
    }

    throw FormatException('Invalid duration format: $json. Expected HH:MM:SS');
  }

  @override
  String toJson(Duration duration) {
    final hours = duration.inHours.toString().padLeft(2, '0');
    final minutes = (duration.inMinutes % 60).toString().padLeft(2, '0');
    final seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');

    return '$hours:$minutes:$seconds';
  }
}