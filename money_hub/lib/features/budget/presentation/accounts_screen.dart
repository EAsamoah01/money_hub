import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/database/app_database.dart';
import '../../../core/router/routes.dart';
import '../../../core/utils/money_format.dart';
import '../../../core/widgets/gradient_header.dart';
import '../data/budget_repository.dart';
import 'widgets/budget_widgets.dart';

const _accountTypes = [AccountType.checking, AccountType.savings, AccountType.cash, AccountType.creditCard];

String accountTypeLabel(AccountType t) => switch (t) {
      AccountType.cash => 'Cash',
      AccountType.checking => 'Checking',
      AccountType.savings => 'Savings',
      AccountType.brokerage => 'Brokerage',
      AccountType.retirement => 'Retirement',
      AccountType.crypto => 'Crypto',
      AccountType.property => 'Property',
      AccountType.vehicle => 'Vehicle',
      AccountType.otherAsset => 'Other asset',
      AccountType.creditCard => 'Credit card',
      AccountType.loan => 'Loan',
      AccountType.mortgage => 'Mortgage',
      AccountType.otherLiability => 'Other debt',
    };

IconData accountTypeIcon(AccountType t) => switch (t) {
      AccountType.cash => Icons.payments_outlined,
      AccountType.checking => Icons.account_balance_outlined,
      AccountType.savings => Icons.savings_outlined,
      AccountType.creditCard => Icons.credit_card,
      _ => Icons.account_balance_wallet_outlined,
    };

class AccountsScreen extends ConsumerWidget {
  const AccountsScreen({super.key});

  Future<void> _add(BuildContext context, WidgetRef ref) async {
    final result = await showDialog<({String name, AccountType type, int cents})>(
      context: context,
      builder: (_) => const _AddAccountDialog(),
    );
    if (result == null) return;
    await ref.read(budgetRepositoryProvider).addAccount(name: result.name, type: result.type, balanceCents: result.cents);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final accounts = ref.watch(accountsProvider).valueOrNull;
    final cash = accounts?.where((a) => !a.type.isLiability).fold<int>(0, (s, a) => s + a.balanceCents) ?? 0;

    return Scaffold(
      appBar: AppBar(title: const Text('Accounts')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _add(context, ref),
        icon: const Icon(Icons.add),
        label: const Text('Add account'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: accounts == null
              ? const Center(child: CircularProgressIndicator())
              : ListView(
                  padding: const EdgeInsets.only(bottom: 96),
                  children: [
                    GradientHeader(
                      title: fmtMoney(cash / 100),
                      subtitle: 'across your cash, checking and savings accounts',
                      icon: Icons.account_balance,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          if (accounts.isEmpty)
                            const Padding(
                              padding: EdgeInsets.all(24),
                              child: Text(
                                'Add the accounts your money lives in. An "Everyday account" is created '
                                'automatically the first time you log a transaction.',
                                textAlign: TextAlign.center,
                              ),
                            ),
                          for (final a in accounts)
                            Card(
                              child: ListTile(
                                leading: IconBubble(accountTypeIcon(a.type)),
                                title: Text(a.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                subtitle: Text(accountTypeLabel(a.type)),
                                trailing: Text(
                                  fmtMoney(a.balanceCents / 100, cents: true),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w700,
                                    color: a.balanceCents < 0 ? Theme.of(context).colorScheme.error : null,
                                  ),
                                ),
                                onTap: () => context.push(Loc.accountDetail(a.id)),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AddAccountDialog extends StatefulWidget {
  const _AddAccountDialog();

  @override
  State<_AddAccountDialog> createState() => _AddAccountDialogState();
}

class _AddAccountDialogState extends State<_AddAccountDialog> {
  final _name = TextEditingController();
  final _balance = TextEditingController();
  AccountType _type = AccountType.checking;

  @override
  void dispose() {
    _name.dispose();
    _balance.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _name.text.trim();
    if (name.isEmpty) return;
    final cents = (parseNum(_balance.text) * 100).round();
    // Credit card balances are money owed, so store them as negative.
    Navigator.pop(context, (name: name, type: _type, cents: _type.isLiability ? -cents.abs() : cents));
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add account'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _name,
              autofocus: true,
              textCapitalization: TextCapitalization.words,
              decoration: const InputDecoration(labelText: 'Name', hintText: 'e.g. Chase checking'),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                for (final t in _accountTypes)
                  ChoiceChip(
                    label: Text(accountTypeLabel(t)),
                    selected: _type == t,
                    onSelected: (_) => setState(() => _type = t),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _balance,
              decoration: InputDecoration(
                labelText: _type.isLiability ? 'Amount owed now' : 'Current balance',
                prefixText: r'$ ',
              ),
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
              onSubmitted: (_) => _submit(),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        FilledButton(onPressed: _submit, child: const Text('Add')),
      ],
    );
  }
}

class AccountDetailScreen extends ConsumerWidget {
  const AccountDetailScreen({super.key, required this.accountId});
  final int accountId;

  Future<void> _rename(BuildContext context, WidgetRef ref, Account a) async {
    final c = TextEditingController(text: a.name);
    final name = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rename account'),
        content: TextField(controller: c, autofocus: true, decoration: const InputDecoration(labelText: 'Name')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, c.text), child: const Text('Save')),
        ],
      ),
    );
    c.dispose();
    if (name != null && name.trim().isNotEmpty) {
      await ref.read(budgetRepositoryProvider).renameAccount(a.id, name.trim());
    }
  }

  Future<void> _archive(BuildContext context, WidgetRef ref, Account a) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Hide ${a.name}?'),
        content: const Text('The account is hidden from lists. Its transactions are kept.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Hide')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(budgetRepositoryProvider).archiveAccount(a.id);
    if (context.mounted) context.pop();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final account = ref.watch(accountProvider(accountId)).valueOrNull;
    final txs = ref.watch(accountTransactionsProvider(accountId)).valueOrNull ?? const [];
    final names = ref.watch(categoryNamesProvider);

    if (account == null) return Scaffold(appBar: AppBar(), body: const Center(child: CircularProgressIndicator()));

    return Scaffold(
      appBar: AppBar(
        title: Text(account.name),
        actions: [
          PopupMenuButton<String>(
            onSelected: (v) => v == 'rename' ? _rename(context, ref, account) : _archive(context, ref, account),
            itemBuilder: (_) => const [
              PopupMenuItem(value: 'rename', child: Text('Rename')),
              PopupMenuItem(value: 'archive', child: Text('Hide account')),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add transaction',
        onPressed: () => context.push(Loc.transactionNew(accountId: account.id)),
        child: const Icon(Icons.add),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.only(bottom: 96),
            children: [
              GradientHeader(
                title: fmtMoney(account.balanceCents / 100, cents: true),
                subtitle: '${accountTypeLabel(account.type)} · ${txs.length} transactions',
                icon: accountTypeIcon(account.type),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (txs.isEmpty)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('No transactions in this account yet.', textAlign: TextAlign.center),
                      ),
                    ...transactionsByDay(
                      txs,
                      categoryNames: names,
                      context: context,
                      onTap: (t) => context.push(Loc.transactionEdit(t.id)),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
