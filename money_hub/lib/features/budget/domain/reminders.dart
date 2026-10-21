// Works out WHEN to remind about bills and free trials. Pure Dart so it can
// be tested; NotificationService turns the result into phone notifications.

import '../../../core/utils/money_format.dart';

class BillReminderInput {
  const BillReminderInput({
    required this.id,
    required this.name,
    required this.amountCents,
    required this.nextDue,
    required this.remindDaysBefore,
    this.trialEnds,
    this.active = true,
    this.autoPay = false,
  });

  final int id;
  final String name;
  final int amountCents;
  final DateTime nextDue;
  final int remindDaysBefore;
  final DateTime? trialEnds;
  final bool active;
  final bool autoPay;
}

class PlannedReminder {
  const PlannedReminder({required this.id, required this.at, required this.title, required this.body});

  /// Stable per bill: bill.id * 10 + 1 (due) / + 2 (trial).
  final int id;

  /// Local time to show the notification.
  final DateTime at;
  final String title;
  final String body;

  @override
  String toString() => 'PlannedReminder($id, $at, $title)';
}

/// Days before a free trial ends to warn the user.
const trialWarningDays = 2;

/// One reminder per active bill ([remindDaysBefore] days before it's due, at
/// [hour]:00), plus a warning before any free trial ends. Times already in
/// the past are skipped; if the normal reminder time has passed but the
/// bill is due later today or in the future, the reminder moves to the due
/// date itself.
List<PlannedReminder> planBillReminders(Iterable<BillReminderInput> bills, DateTime now, {int hour = 9}) {
  final out = <PlannedReminder>[];
  for (final b in bills) {
    if (!b.active) continue;
    final amount = fmtMoney(b.amountCents / 100, cents: true);
    final days = b.remindDaysBefore < 0 ? 0 : b.remindDaysBefore;

    var at = DateTime(b.nextDue.year, b.nextDue.month, b.nextDue.day - days, hour);
    var daysLeft = days;
    if (!at.isAfter(now)) {
      final dueDay = DateTime(b.nextDue.year, b.nextDue.month, b.nextDue.day, hour);
      if (dueDay.isAfter(now)) {
        at = dueDay;
        daysLeft = 0;
      } else {
        at = DateTime(0); // no reminder
      }
    }
    if (at.isAfter(now)) {
      final when = switch (daysLeft) { 0 => 'today', 1 => 'tomorrow', _ => 'in $daysLeft days' };
      out.add(PlannedReminder(
        id: b.id * 10 + 1,
        at: at,
        title: '${b.name} is due $when',
        body: b.autoPay ? '$amount will be paid automatically.' : '$amount due. Tap to mark it as paid.',
      ));
    }

    final trial = b.trialEnds;
    if (trial != null) {
      final warnAt = DateTime(trial.year, trial.month, trial.day - trialWarningDays, hour);
      if (warnAt.isAfter(now)) {
        out.add(PlannedReminder(
          id: b.id * 10 + 2,
          at: warnAt,
          title: 'Free trial for ${b.name} ends in $trialWarningDays days',
          body: "Cancel before then if you don't want to pay $amount.",
        ));
      }
    }
  }
  out.sort((a, b) => a.at.compareTo(b.at));
  return out;
}
