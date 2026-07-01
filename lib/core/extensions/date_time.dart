/// Lightweight French date formatting, without pulling `intl` for two
/// strings only.
extension FrenchDate on DateTime {
  static const _weekdays = [
    'LUNDI',
    'MARDI',
    'MERCREDI',
    'JEUDI',
    'VENDREDI',
    'SAMEDI',
    'DIMANCHE',
  ];

  static const _months = [
    'JANVIER',
    'FÉVRIER',
    'MARS',
    'AVRIL',
    'MAI',
    'JUIN',
    'JUILLET',
    'AOÛT',
    'SEPTEMBRE',
    'OCTOBRE',
    'NOVEMBRE',
    'DÉCEMBRE',
  ];

  /// e.g. `MERCREDI 1 JUILLET`
  String get frenchHeaderDate =>
      '${_weekdays[weekday - 1]} $day ${_months[month - 1]}';

  /// e.g. `À l'instant`, `Il y a 35 min`, `Il y a 2 h`, `Il y a 3 j`
  String get frenchTimeAgo {
    final diff = DateTime.now().difference(this);
    if (diff.inMinutes < 1) return "À l'instant";
    if (diff.inMinutes < 60) return 'Il y a ${diff.inMinutes} min';
    if (diff.inHours < 24) return 'Il y a ${diff.inHours} h';
    return 'Il y a ${diff.inDays} j';
  }
}
