extension DurationExtension on Duration {
  String formatDuration() {
    final hours = inHours;
    final minutes = inMinutes % 60;
    final seconds = inSeconds % 60;

    return '${hours > 0 ? "$hours jam" : ""}${minutes > 0 ? " $minutes menit" : ""}${seconds > 0 ? " $seconds detik" : ""}';
  }
}