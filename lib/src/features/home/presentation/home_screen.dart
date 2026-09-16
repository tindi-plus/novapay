import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/user_model.dart';
import '../../authentication/providers/auth_providers.dart';
import '../../offline_sync/services/sync_engine.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileStreamProvider);
    final authController = ref.read(authControllerProvider.notifier);
    // Initialize the Background Replay Sync Engine on app boot
    ref.watch(syncEngineProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('NovaPay'),
        actions: [
          IconButton(
            onPressed: () async {
              await authController.signOut();
              if (context.mounted) context.go('/login');
            },
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: userAsync.when(
        data: (user) => user == null 
            ? const Center(child: Text('No profile found'))
            : _buildHomeContent(context, ref, user, authController),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading profile: $e')),
      ),
    );
  }

  Widget _buildHomeContent(
    BuildContext context, 
    WidgetRef ref, 
    UserModel user, 
    AuthController authController,
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
              label: 'Current balance ${user.formattedBalance}',
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
                        style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Semantics(
              label: 'Account number ${user.accountNumber}',
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
            const SizedBox(height: 48),
            Center(
              child: Semantics(
                button: true,
                label: 'Logout',
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await authController.signOut();
                    if (context.mounted) context.go('/login');
                  },
                  icon: const Icon(Icons.logout),
                  label: const Text('Logout'),
                  style: OutlinedButton.styleFrom(minimumSize: const Size(200, 48)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
