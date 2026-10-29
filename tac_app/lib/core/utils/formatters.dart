const _weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
const _months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

/// 1400 → "€14", 2850 → "€28.50".
String formatEuro(int cents) {
  final euros = cents ~/ 100;
  final rest = cents % 100;
  return rest == 0 ? '€$euros' : '€$euros.${rest.toString().padLeft(2, '0')}';
}

/// "Today", "Tomorrow" or "Sat 1 Nov".
String formatDay(DateTime date, {DateTime? now}) {
  final diff = dateOnly(date).difference(dateOnly(now ?? DateTime.now())).inDays;
  if (diff == 0) return 'Today';
  if (diff == 1) return 'Tomorrow';
  return '${_weekdays[date.weekday - 1]} ${date.day} ${_months[date.month - 1]}';
}

String pluralSeats(int n) => n == 1 ? '1 seat' : '$n seats';

DateTime dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
