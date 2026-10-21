import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/config/app_config.dart';
import 'core/database/app_database.dart';
import 'core/router/app_router.dart';
import 'core/services/app_lock.dart';
import 'core/services/notification_service.dart';
import 'core/theme/app_theme.dart';
import 'features/budget/data/bills_repository.dart';
import 'features/budget/domain/reminders.dart';

class MoneyHubApp extends ConsumerWidget {
  const MoneyHubApp({super.key});

  /// Re-plans every bill reminder from the current bills.
  static Future<void> syncReminders(WidgetRef ref) async {
    final notifications = ref.read(notificationServiceProvider);
    if (!ref.read(remindersEnabledProvider)) {
      await notifications.cancelAll();
      return;
    }
    final bills = ref.read(billsProvider).valueOrNull ?? const <RecurringItem>[];
    await notifications.replaceAll(planBillReminders(
      [
        for (final b in bills)
          BillReminderInput(
            id: b.id,
            name: b.name,
            amountCents: b.amountCents,
            nextDue: b.nextDueDate,
            remindDaysBefore: b.remindDaysBefore,
            trialEnds: b.trialEndsAt,
            active: b.isActive,
            autoPay: b.autoPay,
          ),
      ],
      DateTime.now(),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Keep phone reminders in step with bills: add, edit, pay, pause, delete.
    ref.listen(billsProvider, (_, next) {
      if (next.hasValue) syncReminders(ref);
    });
    ref.listen(remindersEnabledProvider, (_, __) => syncReminders(ref));

    return MaterialApp.router(
      title: AppConfig.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: ref.watch(routerProvider),
      builder: (context, child) => AppLockGate(child: child ?? const SizedBox.shrink()),
    );
  }
}
