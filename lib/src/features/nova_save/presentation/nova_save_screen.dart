import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../domain/savings_goal_model.dart';
import '../providers/nova_save_provider.dart';
import 'contribute_modal.dart';
import 'create_goal_modal.dart';

class NovaSaveScreen extends ConsumerWidget {
  const NovaSaveScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Save'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: _buildBody(context, ref),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateGoalModal(context),
        icon: const Icon(Icons.add),
        label: const Text('New Goal'),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTotalSavedCard(context, ref),
            const SizedBox(height: 32),
            _buildActiveGoalsSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalSavedCard(BuildContext context, WidgetRef ref) {
    final totalSavedAsync = ref.watch(totalSavedKoboProvider);

    return totalSavedAsync.when(
      data: (totalKobo) {
        final naira = totalKobo / 100.0;
        final formattedAmount = _formatNairaForDisplay(naira);

        return Semantics(
          label: 'Total saved across all goals: $formattedAmount',
          readOnly: true,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total Saved',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    formattedAmount,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      loading: () => Semantics(
        label: 'Loading total saved amount',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: const SizedBox(
              height: 100,
              child: Center(child: CircularProgressIndicator()),
            ),
          ),
        ),
      ),
      error: (e, st) => Semantics(
        label: 'Error loading total saved amount',
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              'Error loading total: $e',
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActiveGoalsSection(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsStreamProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Active Goals',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        const SizedBox(height: 16),
        goalsAsync.when(
          data: (goals) {
            if (goals.isEmpty) {
              return _buildEmptyState(context);
            }
            return ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: goals.length,
              itemBuilder: (context, index) {
                final goal = goals[index];
                return _buildGoalCard(context, goal);
              },
            );
          },
          loading: () => Semantics(
            label: 'Loading savings goals',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 48),
                child: CircularProgressIndicator(),
              ),
            ),
          ),
          error: (e, st) => Semantics(
            label: 'Error loading savings goals',
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  'Error loading goals: $e',
                  style: const TextStyle(color: Colors.red),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGoalCard(BuildContext context, SavingsGoalModel goal) {
    final textScaler = MediaQuery.of(context).textScaler;
    double scaled(double value) => textScaler.scale(value);

    return Semantics(
      label:
          'Goal: ${goal.name}, ${goal.progressPercentage} saved of ${goal.formattedTargetNaira}',
      child: Card(
        margin: EdgeInsets.only(bottom: scaled(16)),
        child: Padding(
          padding: EdgeInsets.all(scaled(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          goal.name,
                          style: Theme.of(context).textTheme.titleMedium,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: scaled(4)),
                        Text(
                          goal.formattedTargetNaira,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: scaled(12)),
                  Semantics(
                    button: true,
                    label: 'Contribute to ${goal.name}',
                    enabled: true,
                    onTap: () => _showContributeModal(context, goal),
                    child: ElevatedButton(
                      onPressed: () => _showContributeModal(context, goal),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: scaled(16),
                          vertical: scaled(8),
                        ),
                      ),
                      child: Text(
                        'Contribute',
                        style: TextStyle(fontSize: scaled(12)),
                      ),
                    ),
                  ),
                ],
              ),
              // SizedBox(height: scaled(12)),
              Semantics(
                label: 'Target date for this goal.',
                button: false,
                readOnly: true,
                child: Text(DateFormat('DD-MMM-yyyy').format(goal.targetDate)),
              ),
              SizedBox(width: scaled(12)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    goal.progressPercentage,
                    style: Theme.of(context).textTheme.bodySmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    '${goal.formattedCurrentNaira} / ${goal.formattedTargetNaira}',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
              SizedBox(height: scaled(8)),
              Semantics(
                label: 'Progress: ${goal.progressPercentage} of goal completed',
                readOnly: true,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: goal.progressRatio,
                    minHeight: scaled(8),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.savings, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'No savings goals yet',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first goal to start saving',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showContributeModal(BuildContext context, SavingsGoalModel goal) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return ContributeModal(
          goal: goal,
          onSuccess: () {
            Navigator.of(modalContext).pop();
          },
        );
      },
    );
  }

  void _showCreateGoalModal(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext modalContext) {
        return CreateGoalModal(
          onSuccess: () {
            Navigator.of(modalContext).pop();
          },
        );
      },
    );
  }

  String _formatNairaForDisplay(double naira) {
    if (naira == 0) return '₦0.00';
    String formatted = naira.toStringAsFixed(2);
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];
    final buffer = StringBuffer();
    for (int i = 0; i < integerPart.length; i++) {
      if (i > 0 && (integerPart.length - i) % 3 == 0) {
        buffer.write(',');
      }
      buffer.write(integerPart[i]);
    }
    return '₦${buffer.toString()}.$decimalPart';
  }
}
