/// "2026-10-18" — the key used in the activity_days table.
String dayKey(DateTime d) =>
    '${d.year.toString().padLeft(4, '0')}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

/// Consecutive active days ending today. If today has no activity yet, a
/// streak that ended yesterday still counts, so it doesn't reset at midnight.
int computeStreak(Iterable<String> activeDays, DateTime today) {
  final days = activeDays.toSet();
  var cursor = DateTime(today.year, today.month, today.day);
  if (!days.contains(dayKey(cursor))) {
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
    if (!days.contains(dayKey(cursor))) return 0;
  }
  var streak = 0;
  while (days.contains(dayKey(cursor))) {
    streak++;
    // Build the previous day from components so daylight-saving shifts
    // can't skip or repeat a date.
    cursor = DateTime(cursor.year, cursor.month, cursor.day - 1);
  }
  return streak;
}
