import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../providers/nova_save_provider.dart';

class CreateGoalModal extends ConsumerStatefulWidget {
  final VoidCallback? onSuccess;
  const CreateGoalModal({super.key, this.onSuccess});
  @override
  ConsumerState<CreateGoalModal> createState() => _CreateGoalModalState();
}

class _CreateGoalModalState extends ConsumerState<CreateGoalModal> {
  late TextEditingController _name, _amt;
  final _key = GlobalKey<FormState>();
  DateTime? _date;
  bool _loading = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    _name = TextEditingController();
    _amt = TextEditingController();
  }

  @override
  void dispose() {
    _name.dispose();
    _amt.dispose();
    super.dispose();
  }

  int _kobo(String s) {
    try {
      return (double.parse(s.replaceAll('₦', '').replaceAll(',', '')) * 100).toInt();
    } catch (_) {
      return 0;
    }
  }

  Future<void> _submit() async {
    if (!_key.currentState!.validate() || _date == null) return;
    setState(() {_loading = true; _err = null;});
    try {
      await ref.read(novaSaveControllerProvider.notifier).createSavingsGoal(
        name: _name.text,
        targetAmountInKobo: _kobo(_amt.text),
        targetDate: _date!,
      );
      if (mounted) {Navigator.pop(context); widget.onSuccess?.call();}
    } catch (e) {
      setState(() => _err = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scale = MediaQuery.of(context).textScaleFactor;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24, right: 24, top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Create Goal', style: Theme.of(context).textTheme.headlineSmall),
            SizedBox(height: 24 * scale),
            Form(
              key: _key,
              child: Column(
                children: [
                  TextFormField(
                    controller: _name,
                    decoration: InputDecoration(
                      labelText: 'Goal Name',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  SizedBox(height: 16 * scale),
                  TextFormField(
                    controller: _amt,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Amount (₦)',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    validator: (v) => _kobo(v ?? '') <= 0 ? 'Valid amount' : null,
                  ),
                  SizedBox(height: 16 * scale),
                  GestureDetector(
                    onTap: () async {
                      final p = await showDatePicker(
                        context: context,
                        initialDate: _date ?? DateTime.now().add(const Duration(days: 30)),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 3650)),
                      );
                      if (p != null) setState(() => _date = p);
                    },
                    child: Container(
                      height: 48 * scale,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(_date == null ? 'Select Date' : DateFormat('MMM dd, yyyy').format(_date!)),
                            Icon(Icons.calendar_today),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (_err != null) ...[
              SizedBox(height: 16 * scale),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(_err!, style: TextStyle(color: Colors.red.shade700)),
              ),
            ],
            SizedBox(height: 24 * scale),
            SizedBox(
              height: 48 * scale,
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading ? CircularProgressIndicator() : Text('Create'),
              ),
            ),
            SizedBox(height: 12 * scale),
            SizedBox(
              height: 48 * scale,
              child: OutlinedButton(
                onPressed: _loading ? null : () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
