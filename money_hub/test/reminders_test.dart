// Run with:  flutter test

import 'package:flutter_test/flutter_test.dart';
import 'package:money_hub/features/budget/domain/reminders.dart';

void main() {
  final now = DateTime(2026, 10, 21, 8, 0); // Wed 8:00 am

  BillReminderInput bill({
    int id = 1,
    required DateTime due,
    int remind = 2,
    DateTime? trial,
    bool active = true,
    bool autoPay = false,
  }) =>
      BillReminderInput(
        id: id,
        name: 'Netflix',
        amountCents: 1549,
        nextDue: due,
        remindDaysBefore: remind,
        trialEnds: trial,
        active: active,
        autoPay: autoPay,
      );

  test('reminds N days before at 9 am', () {
    final r = planBillReminders([bill(due: DateTime(2026, 10, 25))], now);
    expect(r, hasLength(1));
    expect(r.single.id, 11);
    expect(r.single.at, DateTime(2026, 10, 23, 9));
    expect(r.single.title, 'Netflix is due in 2 days');
    expect(r.single.body, contains(r'$15.49'));
  });

  test('says "tomorrow" and mentions autopay', () {
    final r = planBillReminders([bill(due: DateTime(2026, 10, 25), remind: 1, autoPay: true)], now);
    expect(r.single.title, 'Netflix is due tomorrow');
    expect(r.single.body, contains('paid automatically'));
  });

  test('moves to the due date when the reminder time already passed', () {
    // Due tomorrow, remind 3 days before → that was in the past.
    final r = planBillReminders([bill(due: DateTime(2026, 10, 22), remind: 3)], now);
    expect(r.single.at, DateTime(2026, 10, 22, 9));
    expect(r.single.title, 'Netflix is due today');
  });

  test('skips overdue, paused bills', () {
    expect(planBillReminders([bill(due: DateTime(2026, 10, 20))], now), isEmpty);
    expect(planBillReminders([bill(due: DateTime(2026, 11, 1), active: false)], now), isEmpty);
  });

  test('warns 2 days before a free trial ends', () {
    final r = planBillReminders(
      [bill(id: 4, due: DateTime(2026, 11, 30), remind: 2, trial: DateTime(2026, 10, 30))],
      now,
    );
    final trial = r.firstWhere((x) => x.id == 42);
    expect(trial.at, DateTime(2026, 10, 28, 9));
    expect(trial.title, contains('Free trial'));
    expect(r.first.id, 42); // sorted soonest first
  });

  test('works across month ends', () {
    final r = planBillReminders([bill(due: DateTime(2026, 11, 1), remind: 2)], now);
    expect(r.single.at, DateTime(2026, 10, 30, 9));
  });
}
