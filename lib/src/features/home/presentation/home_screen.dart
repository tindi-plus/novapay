import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/user_model.dart';
import '../../../router/app_router.dart';
import '../../authentication/providers/auth_providers.dart';
import '../../offline_sync/services/sync_engine.dart';
import '../data/recent_transactions_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileStreamProvider);
    final authController = ref.read(authControllerProvider.notifier);
    ref.watch(syncEngineProvider);
    print("Home screen is active now.....!!!!!.......!!!!");
    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaPay'),
        actions: [
          IconButton(
            onPressed: () async {
              await authController.signOut();
              if (context.mounted) context.go(loginPath);
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => user == null
            ? const Center(child: Text('No profile found'))
            : _buildHomeContent(context, ref, user),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context,
    WidgetRef ref,
    UserModel user,
  ) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Semantics(
              header: true,
              child: Text(
                'Welcome, ${user.fullName}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
            ),
            const SizedBox(height: 32),
            Semantics(
              label: 'Current balance',
              readOnly: true,
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Balance'),
                      Text(
                        user.formattedBalance,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              label: 'Account details',
              readOnly: true,
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.account_balance),
                  title: const Text('NIBSS Account'),
                  subtitle: Text(user.accountNumber),
                  trailing: Chip(label: Text('Tier ${user.kycTier}')),
                ),
              ),
            ),
            const SizedBox(height: 32),
            _buildNavActions(context),
            const SizedBox(height: 32),
            _buildTransactionSection(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildNavActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Quick Actions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: Semantics(
                button: true,
                label: 'Send Money',
                enabled: true,
                child: Card(
                  child: InkWell(
                    onTap: () => context.push(sendMoneyPath),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.send,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text('Send Money', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Semantics(
                button: true,
                label: 'Nova Save',
                enabled: true,
                child: Card(
                  child: InkWell(
                    onTap: () => context.push(savePath),
                    borderRadius: BorderRadius.circular(12),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          Icon(
                            Icons.savings,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(height: 8),
                          Text('Nova Save', textAlign: TextAlign.center),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionSection(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(recentTransactionsProviderProvider);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Recent Transactions',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        txAsync.when(
          data: (txList) {
            if (txList.isEmpty) {
              return Semantics(
                label: 'No transactions',
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    'No transactions yet',
                    textAlign: TextAlign.center,
                  ),
                ),
              );
            }
            return RefreshIndicator(
              onRefresh: () async {
                await ref
                    .read(recentTransactionsRepositoryProvider)
                    .refreshTransactions();
              },
              child: SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: txList.length,
                  itemBuilder: (c, i) {
                    final tx = txList[i];
                    return Semantics(
                      label: tx.accessibilityLabel,
                      readOnly: true,
                      child: Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: ListTile(
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: tx.displayColor.withValues(alpha: 0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_downward,
                              color: tx.displayColor,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            tx.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          subtitle: Text(
                            tx.formattedDate,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          trailing: Text(
                            tx.formattedAmountWithSign,
                            style: TextStyle(
                              color: tx.displayColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          },
          loading: () => const SizedBox(
            height: 100,
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, st) => Center(child: Text('Error: $e')),
        ),
      ],
    );
  }
}
