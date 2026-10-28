String apiDate(DateTime date) =>
    '${date.year.toString().padLeft(4, '0')}-'
    '${date.month.toString().padLeft(2, '0')}-'
    '${date.day.toString().padLeft(2, '0')}';

String displayDate(String date) {
  final parsed = DateTime.tryParse(date);
  if (parsed == null) return date;
  return '${parsed.month.toString().padLeft(2, '0')}/'
      '${parsed.day.toString().padLeft(2, '0')}/${parsed.year}';
}
