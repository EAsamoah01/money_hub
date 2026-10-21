import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/utils/money_format.dart';
import '../data/debts_repository.dart';

/// Add a debt (debtId == null) or edit an existing one.
class DebtFormScreen extends ConsumerStatefulWidget {
  const DebtFormScreen({super.key, this.debtId});
  final int? debtId;

  @override
  ConsumerState<DebtFormScreen> createState() => _DebtFormScreenState();
}

class _DebtFormScreenState extends ConsumerState<DebtFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _balance = TextEditingController();
  final _apr = TextEditingController();
  final _min = TextEditingController();
  final _due = TextEditingController();
  bool _loading = false;
  bool _saving = false;

  bool get _isEdit => widget.debtId != null;

  @override
  void initState() {
    super.initState();
    if (_isEdit) _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    final d = await ref.read(debtProvider(widget.debtId!).future);
    if (!mounted) return;
    if (d != null) {
      _name.text = d.name;
      _balance.text = _plain(d.currentBalanceCents / 100);
      _apr.text = _plain(d.aprBasisPoints / 100);
      _min.text = _plain(d.minimumPaymentCents / 100);
      _due.text = d.dueDayOfMonth?.toString() ?? '';
    }
    setState(() => _loading = false);
  }

  /// 1500.0 → "1500", 22.99 → "22.99"
  static String _plain(double v) => v == v.roundToDouble() ? v.toStringAsFixed(0) : v.toStringAsFixed(2);

  @override
  void dispose() {
    for (final c in [_name, _balance, _apr, _min, _due]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(debtsRepositoryProvider);
    final name = _name.text.trim();
    final balance = (parseNum(_balance.text) * 100).round();
    final apr = (parseNum(_apr.text) * 100).round();
    final min = (parseNum(_min.text) * 100).round();
    final due = _due.text.trim().isEmpty ? null : int.tryParse(_due.text.trim());

    try {
      if (_isEdit) {
        await repo.edit(widget.debtId!,
            name: name, balanceCents: balance, aprBasisPoints: apr, minimumPaymentCents: min, dueDayOfMonth: due);
      } else {
        await repo.add(
            name: name, balanceCents: balance, aprBasisPoints: apr, minimumPaymentCents: min, dueDayOfMonth: due);
      }
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  String? _money(String? v, {bool allowZero = true}) {
    if (_required(v) != null) return 'Required';
    final n = double.tryParse(v!.replaceAll(',', ''));
    if (n == null || n < 0) return 'Enter a number';
    if (!allowZero && n == 0) return 'Must be more than 0';
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final numbers = [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit debt' : 'Add a debt'),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: Form(
                  key: _form,
                  child: ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      TextFormField(
                        controller: _name,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          hintText: 'e.g. Visa card, Car loan',
                          prefixIcon: Icon(Icons.label_outline),
                        ),
                        textCapitalization: TextCapitalization.sentences,
                        validator: _required,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _balance,
                        decoration: const InputDecoration(
                          labelText: 'Current balance',
                          prefixText: r'$ ',
                          prefixIcon: Icon(Icons.account_balance_wallet_outlined),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: numbers,
                        validator: (v) => _money(v, allowZero: _isEdit),
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _apr,
                        decoration: const InputDecoration(
                          labelText: 'Interest rate (APR)',
                          suffixText: '%',
                          prefixIcon: Icon(Icons.percent),
                          helperText: 'Find it on your statement. Use 0 for interest-free.',
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: numbers,
                        validator: (v) {
                          final e = _money(v);
                          if (e != null) return e;
                          return parseNum(v!) > 100 ? 'That looks too high' : null;
                        },
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _min,
                        decoration: const InputDecoration(
                          labelText: 'Minimum monthly payment',
                          prefixText: r'$ ',
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: numbers,
                        validator: _money,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _due,
                        decoration: const InputDecoration(
                          labelText: 'Due day of month (optional)',
                          hintText: '1–31',
                          prefixIcon: Icon(Icons.event_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final d = int.tryParse(v);
                          return (d == null || d < 1 || d > 31) ? 'Enter a day from 1 to 31' : null;
                        },
                      ),
                      const SizedBox(height: 24),
                      FilledButton.icon(
                        onPressed: _saving ? null : _save,
                        icon: const Icon(Icons.check),
                        label: Text(_isEdit ? 'Save changes' : 'Add debt'),
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
