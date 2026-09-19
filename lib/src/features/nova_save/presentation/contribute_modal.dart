import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../authentication/providers/auth_providers.dart';
import '../domain/savings_goal_model.dart';
import '../providers/nova_save_provider.dart';

class ContributeModal extends ConsumerStatefulWidget {
  final SavingsGoalModel goal;
  final VoidCallback? onSuccess;
  const ContributeModal({super.key, required this.goal, this.onSuccess});
  @override
  ConsumerState<ContributeModal> createState() => _ContributeModalState();
}

class _ContributeModalState extends ConsumerState<ContributeModal> {
  late TextEditingController _amt;
  final _form = GlobalKey<FormState>();
  bool _loading = false;
  String? _err;

  @override
  void initState() {
    super.initState();
    _amt = TextEditingController();
  }

  @override
  void dispose() {
    _amt.dispose();
    super.dispose();
  }

  int _kobo(String s) {
    try {
      return (double.parse(s.replaceAll('₦', '').replaceAll(',', '')) * 100)
          .toInt();
    } catch (_) {
      return 0;
    }
  }

  Future<void> _submit() async {
    if (!_form.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _err = null;
    });
    try {
      final kobo = _kobo(_amt.text);
      final user = await ref.read(currentUserProfileProvider.future);
      if (user == null || kobo > user.walletBalanceInKobo) {
        throw Exception('Insufficient balance');
      }
      await ref
          .read(novaSaveControllerProvider.notifier)
          .contributeToGoal(goalId: widget.goal.id, amountInKobo: kobo);
      if (mounted) {
        Navigator.pop(context);
        widget.onSuccess?.call();
      }
    } catch (e) {
      setState(() => _err = e.toString().replaceFirst('Exception: ', ''));
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.of(context).textScaler;
    double scaled(double fontSize) => textScaler.scale(fontSize);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Contribute',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            SizedBox(height: scaled(24)),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text('Goal'), Text(widget.goal.name)],
                  ),
                  SizedBox(height: scaled(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Target Amount'),
                      Text(widget.goal.formattedTargetNaira),
                    ],
                  ),
                  SizedBox(height: scaled(12)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Target Date'),
                      Text(DateFormat('DD-MMM-yyyy').format(widget.goal.targetDate)),
                    ],
                  ),
                  SizedBox(height: scaled(16)),
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress'),
                          Text(widget.goal.progressPercentage),
                        ],
                      ),
                      SizedBox(height: 8),
                      LinearProgressIndicator(value: widget.goal.progressRatio),
                      SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Saved: ${widget.goal.formattedCurrentNaira}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            'Target: ${widget.goal.formattedTargetNaira}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: scaled(24)),
            Form(
              key: _form,
              child: TextFormField(
                controller: _amt,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Amount (₦)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
              ),
            ),
            if (_err != null) ...[
              SizedBox(height: scaled(16)),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  border: Border.all(color: Colors.red.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _err!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            ],
            SizedBox(height: scaled(24)),
            SizedBox(
              height: scaled(48),
              child: ElevatedButton(
                onPressed: _loading ? null : _submit,
                child: _loading
                    ? CircularProgressIndicator()
                    : Text('Contribute'),
              ),
            ),
            SizedBox(height: scaled(12)),
            SizedBox(
              height: scaled(48),
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
