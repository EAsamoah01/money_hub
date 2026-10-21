import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../core/database/app_database.dart';
import '../../../core/utils/money_format.dart';
import '../data/bills_repository.dart';
import '../data/budget_repository.dart';
import '../domain/budget_math.dart';

/// Add a bill/subscription (billId == null) or edit one.
class BillFormScreen extends ConsumerStatefulWidget {
  const BillFormScreen({super.key, this.billId});
  final int? billId;

  @override
  ConsumerState<BillFormScreen> createState() => _BillFormScreenState();
}

class _BillFormScreenState extends ConsumerState<BillFormScreen> {
  final _form = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _amount = TextEditingController();
  final _remind = TextEditingController(text: '2');
  final _cancelUrl = TextEditingController();

  RecurringKind _kind = RecurringKind.bill;
  Frequency _frequency = Frequency.monthly;
  DateTime _nextDue = DateTime.now();
  DateTime? _trialEnds;
  int? _categoryId;
  bool _autoPay = false;
  bool _ready = false;
  bool _saving = false;

  bool get _isEdit => widget.billId != null;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (_isEdit) {
      final b = await ref.read(billProvider(widget.billId!).future);
      if (b != null) {
        _name.text = b.name;
        _amount.text = (b.amountCents / 100).toStringAsFixed(2);
        _remind.text = '${b.remindDaysBefore}';
        _cancelUrl.text = b.cancelUrl ?? '';
        _kind = b.kind;
        _frequency = b.frequency;
        _nextDue = b.nextDueDate;
        _trialEnds = b.trialEndsAt;
        _categoryId = b.categoryId;
        _autoPay = b.autoPay;
      }
    }
    if (mounted) setState(() => _ready = true);
  }

  @override
  void dispose() {
    for (final c in [_name, _amount, _remind, _cancelUrl]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<DateTime?> _pick(DateTime initial) => showDatePicker(
        context: context,
        initialDate: initial,
        firstDate: DateTime(2000),
        lastDate: DateTime(DateTime.now().year + 10),
      );

  Future<void> _save() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _saving = true);
    final url = _cancelUrl.text.trim();
    try {
      await ref.read(billsRepositoryProvider).save(
            id: widget.billId,
            name: _name.text.trim(),
            kind: _kind,
            amountCents: (parseNum(_amount.text) * 100).round(),
            frequency: _frequency,
            nextDueDate: DateTime(_nextDue.year, _nextDue.month, _nextDue.day),
            trialEndsAt: _kind == RecurringKind.subscription ? _trialEnds : null,
            categoryId: _categoryId,
            remindDaysBefore: int.tryParse(_remind.text) ?? 2,
            autoPay: _autoPay,
            cancelUrl: url.isEmpty ? null : (url.startsWith('http') ? url : 'https://$url'),
          );
      if (mounted) context.pop();
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Could not save: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final cats = ref.watch(categoriesProvider).valueOrNull ?? const [];
    final t = Theme.of(context);
    final sub = _kind == RecurringKind.subscription;
    final outline = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
      side: BorderSide(color: t.colorScheme.outlineVariant),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit' : (sub ? 'Add subscription' : 'Add bill')),
        leading: IconButton(icon: const Icon(Icons.close), onPressed: () => context.pop()),
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
                      SegmentedButton<RecurringKind>(
                        segments: const [
                          ButtonSegment(value: RecurringKind.bill, label: Text('Bill'), icon: Icon(Icons.receipt_outlined)),
                          ButtonSegment(
                            value: RecurringKind.subscription,
                            label: Text('Subscription'),
                            icon: Icon(Icons.autorenew),
                          ),
                        ],
                        selected: {_kind},
                        onSelectionChanged: (s) => setState(() => _kind = s.first),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _name,
                        textCapitalization: TextCapitalization.words,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          hintText: sub ? 'e.g. Netflix, Spotify, gym' : 'e.g. Rent, electricity, phone',
                          prefixIcon: const Icon(Icons.label_outline),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty) ? 'Required' : null,
                      ),
                      const SizedBox(height: 14),
                      TextFormField(
                        controller: _amount,
                        decoration: const InputDecoration(labelText: 'Amount', prefixText: r'$ '),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]'))],
                        validator: (v) {
                          final n = double.tryParse((v ?? '').replaceAll(',', ''));
                          return (n == null || n <= 0) ? 'Enter an amount above 0' : null;
                        },
                      ),
                      const SizedBox(height: 14),
                      Text('How often', style: t.textTheme.labelLarge),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          for (final f in Frequency.values)
                            ChoiceChip(
                              label: Text(frequencyLabel(f)),
                              selected: _frequency == f,
                              onSelected: (_) => setState(() => _frequency = f),
                            ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      ListTile(
                        shape: outline,
                        leading: const Icon(Icons.event_outlined),
                        title: Text(DateFormat.yMMMEd().format(_nextDue)),
                        subtitle: const Text('Next due date'),
                        onTap: () async {
                          final d = await _pick(_nextDue);
                          if (d != null) setState(() => _nextDue = d);
                        },
                      ),
                      if (sub) ...[
                        const SizedBox(height: 10),
                        ListTile(
                          shape: outline,
                          leading: const Icon(Icons.hourglass_bottom),
                          title: Text(_trialEnds == null ? 'No free trial' : DateFormat.yMMMEd().format(_trialEnds!)),
                          subtitle: const Text('Free trial ends (optional)'),
                          trailing: _trialEnds == null
                              ? null
                              : IconButton(
                                  tooltip: 'Clear',
                                  icon: const Icon(Icons.close),
                                  onPressed: () => setState(() => _trialEnds = null),
                                ),
                          onTap: () async {
                            final d = await _pick(_trialEnds ?? DateTime.now().add(const Duration(days: 7)));
                            if (d != null) setState(() => _trialEnds = d);
                          },
                        ),
                      ],
                      const SizedBox(height: 14),
                      DropdownMenu<int>(
                        key: ValueKey('bill-cat-${cats.length}'),
                        initialSelection: _categoryId,
                        expandedInsets: EdgeInsets.zero,
                        label: const Text('Budget category (optional)'),
                        leadingIcon: const Icon(Icons.inbox_outlined),
                        dropdownMenuEntries: [
                          for (final c in cats) DropdownMenuEntry(value: c.id, label: c.name),
                        ],
                        onSelected: (v) => setState(() => _categoryId = v),
                      ),
                      const SizedBox(height: 6),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Paid automatically (autopay)'),
                        value: _autoPay,
                        onChanged: (v) => setState(() => _autoPay = v),
                      ),
                      TextFormField(
                        controller: _remind,
                        decoration: const InputDecoration(
                          labelText: 'Remind me this many days before',
                          prefixIcon: Icon(Icons.notifications_outlined),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                      ),
                      if (sub) ...[
                        const SizedBox(height: 14),
                        TextFormField(
                          controller: _cancelUrl,
                          decoration: const InputDecoration(
                            labelText: 'Cancel page link (optional)',
                            hintText: 'netflix.com/cancelplan',
                            prefixIcon: Icon(Icons.link),
                          ),
                          keyboardType: TextInputType.url,
                        ),
                      ],
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
