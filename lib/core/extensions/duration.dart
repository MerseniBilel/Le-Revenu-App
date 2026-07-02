extension DurationFormat on Duration {
  /// e.g. `1:05`, `0:35`
  String get mmss {
    final seconds = inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$inMinutes:$seconds';
  }
}
