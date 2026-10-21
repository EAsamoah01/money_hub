import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/money_format.dart';
import '../data/budget_repository.dart';

/// Add or edit spending / income.
class TransactionFormScreen extends ConsumerStatefulWidget {
  const TransactionFormScreen({super.key, this.txId, this.categoryId, this.accountId, this.income = false});
  final int? txId;
  final int? categoryId;
  final int? accountId;

  /// Start on the Income tab (from "Add income").
  final bool income;

  @override
  ConsumerState<TransactionFormScreen> createState() => _TransactionFormScreenState();
}

class _TransactionFormScreenState extends ConsumerState<TransactionFormScreen> {
  final _form = GlobalKey<FormState>();
  final _amount = TextEditingController();
  final _payee = TextEditingController();
  final _note = TextEditingController();

  late TransactionType _type = widget.income ? TransactionType.income : TransactionType.expense;
  int? _categoryId;
  int? _accountId;
  DateTime _date = DateTime.now();
  MoneyTransaction? _existing;
  bool _ready = false;
  bool _saving = false;

  bool get _isEdit => widget.txId != null;

  /// Debt payments must be edited from the debt so balances stay correct.
  bool get _amountLocked => _existing?.debtId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final repo = ref.read(budgetRepositoryProvider);
    final defaultAccount = await repo.ensureDefaultAccount();
    _accountId = widget.accountId ?? defaultAccount;
    _categoryId = widget.categoryId;

    if (_isEdit) {
      final tx = await repo.getTransaction(widget.txId!);
      if (tx != null) {
        _existing = tx;
        _type = tx.type == TransactionType.income ? TransactionType.income : TransactionType.expense;
        _amount.text = (tx.amountCents.abs() / 100).toStringAsFixed(2);
        _payee.text = tx.payee ?? '';
        _note.text = tx.note ?? '';
        _categoryId = tx.categoryId;
        _accountId = tx.accountId;
        _date = tx.date;
      }
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    _amount.dispose();
    _payee.dispose();
    _note.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 366)),
    );
    if (picked != null) setState(() => _date = DateTime(picked.year, picked.month, picked.day, _date.hour, _date.minute));
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    if (_type == TransactionType.expense && _categoryId == null && _existing?.debtId == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Pick a category for this spending')));
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(budgetRepositoryProvider).saveTransaction(
            id: widget.txId,
            type: _type,
            amountCents: _amountLocked ? _existing!.amountCents.abs() : (parseNum(_amount.text) * 100).round(),
            accountId: _accountId!,
            categoryId: _categoryId,
            payee: _payee.text.trim().isEmpty ? null : _payee.text.trim(),
            note: _note.text.trim().isEmpty ? null : _note.text.trim(),
            date: _date,
          );
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  Future<void> _delete() async {
    final debt = _existing?.debtId != null;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete this transaction?'),
        content: Text(debt
            ? 'This was a debt payment, so the amount will be added back to the debt.'
            : 'Your account balance will be adjusted.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok != true) return;
    await ref.read(budgetRepositoryProvider).deleteTransaction(widget.txId!);
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final groups = ref.watch(categoryGroupsProvider).valueOrNull ?? const [];
    final accounts = ref.watch(accountsProvider).valueOrNull ?? const [];
    final groupNames = {for (final g in groups) g.id: g.name};
    final isIncome = _type == TransactionType.income;
    final t = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit transaction' : (isIncome ? 'Add income' : 'Add spending')),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
        actions: [
          if (_isEdit) IconButton(tooltip: 'Delete', icon: const Icon(Icons.delete_outline), onPressed: _delete),
        ],
      ),
      body: !_ready
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Form(
                  key: _form,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      SegmentedButton<TransactionType>(
                        segments: const [
                          ButtonSegment(
                            value: TransactionType.expense,
                            label: Text('Spending'),
                            icon: Icon(Icons.shopping_bag_outlined),
                          ),
                          ButtonSegment(value: TransactionType.income, label: Text('Income'), icon: Icon(Icons.south_west)),
                        ],
                        selected: {_type},
                        onSelectionChanged: _amountLocked ? null : (s) => setState(() => _type = s.first),
                      ),
                      const SizedBox(height: 16),
                      if (_existing?.debtId != null || _existing?.recurringItemId != null)
                        Card(
                          color: t.colorScheme.secondaryContainer,
                          child: ListTile(
                            leading: const Icon(Icons.link),
                            title: Text(_existing?.debtId != null ? 'Debt payment' : 'Bill payment'),
                            subtitle: Text(_existing?.debtId != null
                                ? 'The amount is locked. Delete and re-record it from the debt to change it.'
                                : 'Logged from your bills. Changes here only affect this payment.'),
                          ),
                        ),
                      TextFormField(
                        controller: _amount,
                        readOnly: _amountLocked,
                        autofocus: !_isEdit,
                        style: t.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
                        decoration: const InputDecoration(labelText: 'Amount', prefixText: r'$ '),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                        validator: (v) {
                          final n = double.tryParse((v ?? '').replaceAll(',', ''));
                          if (n == null || n <= 0) return 'Enter an amount above 0';
                          return null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _payee,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: isIncome ? 'From (e.g. employer)' : 'Paid to (e.g. store)',
                          prefixIcon: const Icon(Icons.storefront_outlined),
                        ),
                      ),
                      const SizedBox(height: 14),
                      if (!isIncome) ...[
                        DropdownMenu<int>(
                          key: ValueKey('cat-${cats.length}'),
                          initialSelection: _categoryId,
                          expandedInsets: EdgeInsets.zero,
                          label: const Text('Category'),
                          leadingIcon: const Icon(Icons.inbox_outlined),
                          enableFilter: true,
                          requestFocusOnTap: true,
                          dropdownMenuEntries: [
                            for (final c in cats)
                              DropdownMenuEntry(
                                value: c.id,
                                label: c.name,
                                trailingIcon: Text(groupNames[c.groupId] ?? '', style: t.textTheme.bodySmall),
                              ),
                          ],
                          onSelected: (v) => setState(() => _categoryId = v),
                        ),
                        const SizedBox(height: 14),
                      ],
                      DropdownMenu<int>(
                        key: ValueKey('acct-${accounts.length}'),
                        initialSelection: _accountId,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('Account'),
                        leadingIcon: const Icon(Icons.account_balance_outlined),
                        dropdownMenuEntries: [
                          for (final a in accounts) DropdownMenuEntry(value: a.id, label: a.name),
                        ],
                        onSelected: (v) => setState(() => _accountId = v ?? _accountId),
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: t.colorScheme.outlineVariant),
                        ),
                        leading: const Icon(Icons.event_outlined),
                        title: Text(DateFormat.yMMMEd().format(_date)),
                        subtitle: const Text('Date'),
                        onTap: _pickDate,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _note,
                        decoration: const InputDecoration(labelText: 'Note (optional)', prefixIcon: Icon(Icons.notes)),
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.check),
                        label: Text(_isEdit ? 'Save changes' : 'Save'),
                        style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
