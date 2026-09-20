// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:go_router/go_router.dart';

// import '../../../common/models/transaction_model.dart';
// import '../../../common/models/user_model.dart';
// import '../../../router/app_router.dart';
// import '../../authentication/providers/auth_providers.dart';
// import '../../offline_sync/services/sync_engine.dart';
// import '../../nova_save/providers/nova_save_provider.dart';
// import '../data/recent_transactions_repository.dart';

// class HomeScreen extends ConsumerWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final userAsync = ref.watch(currentUserProfileStreamProvider);
//     final authController = ref.read(authControllerProvider.notifier);
//     ref.watch(syncEngineProvider);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('NovaPay'),
//         actions: [
//           IconButton(
//             onPressed: () async {
//               await authController.signOut();
//               if (context.mounted) context.go(loginPath);
//             },
//             icon: const Icon(Icons.logout),
//             tooltip: 'Logout',
//           ),
//         ],
//       ),
//       body: userAsync.when(
//         data: (user) => user == null
//             ? const Center(child: Text('No profile found'))
//             : _buildHomeContent(context, ref, user),
//         loading: () => const Center(child: CircularProgressIndicator()),
//         error: (e, _) => Center(child: Text('Error: $e')),
//       ),
//     );
//   }

//   Widget _buildHomeContent(
//     BuildContext context,
//     WidgetRef ref,
//     UserModel user,
//   ) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         padding: const EdgeInsets.all(24),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Semantics(
//               header: true,
//               child: Text(
//                 'Welcome, ${user.fullName}',
//                 style: Theme.of(context).textTheme.headlineMedium,
//               ),
//             ),
//             const SizedBox(height: 32),
//             Semantics(
//               label: 'Current balance',
//               readOnly: true,
//               child: Card(
//                 child: Padding(
//                   padding: const EdgeInsets.all(20),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const Text('Balance'),
//                       Text(
//                         user.formattedBalance,
//                         style: const TextStyle(
//                           fontSize: 32,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 24),
//             Semantics(
//               label: 'Account details',
//               readOnly: true,
//               child: Card(
//                 child: ListTile(
//                   leading: const Icon(Icons.account_balance),
//                   title: const Text('NIBSS Account'),
//                   subtitle: Text(user.accountNumber),
//                   trailing: Chip(label: Text('Tier ${user.kycTier}')),
//                 ),
//               ),
//             ),
//             const SizedBox(height: 32),
//             _buildNavActions(context),
//             const SizedBox(height: 32),
//             _buildNovaSaveSummaryCard(context, ref),
//             const SizedBox(height: 32),
//             _buildTransactionSection(context, ref),
//           ],
//         ),
//       ),
//     );
//   }

//   /// Builds a dynamic Nova Save summary card showing total goals and saved amount
//   Widget _buildNovaSaveSummaryCard(BuildContext context, WidgetRef ref) {
//     final goalsAsync = ref.watch(savingsGoalsStreamProvider);
//     final totalSavedAsync = ref.watch(totalSavedKoboProvider);

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Semantics(
//           header: true,
//           child: Text(
//             'Nova Save',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//         ),
//         const SizedBox(height: 12),
//         goalsAsync.when(
//           data: (goals) {
//             return totalSavedAsync.when(
//               data: (totalKobo) {
//                 final naira = totalKobo / 100.0;
//                 final formattedAmount = _formatNairaForDisplay(naira);

//                 return Semantics(
//                   label:
//                       'Nova Save: ${goals.length} active goals, $formattedAmount total saved',
//                   child: Card(
//                     child: InkWell(
//                       onTap: () => context.push(savePath),
//                       borderRadius: BorderRadius.circular(12),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       '${goals.length} Active Goals',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .titleSmall
//                                           ?.copyWith(fontWeight: FontWeight.bold),
//                                     ),
//                                     const SizedBox(height: 4),
//                                     Text(
//                                       'Saved: $formattedAmount',
//                                       style: Theme.of(context)
//                                           .textTheme
//                                           .bodySmall
//                                           ?.copyWith(
//                                             color: Theme.of(context)
//                                                 .colorScheme
//                                                 .primary,
//                                           ),
//                                     ),
//                                   ],
//                                 ),
//                                 Icon(
//                                   Icons.arrow_forward,
//                                   color: Theme.of(context).colorScheme.primary,
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//               loading: () => Semantics(
//                 label: 'Loading Nova Save summary',
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: SizedBox(
//                       height: 60,
//                       child: Center(
//                         child: CircularProgressIndicator(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//               error: (e, st) => Semantics(
//                 label: 'Error loading Nova Save summary',
//                 child: Card(
//                   child: Padding(
//                     padding: const EdgeInsets.all(16),
//                     child: Text('Error loading Nova Save', style: TextStyle(color: Colors.red)),
//                   ),
//                 ),
//               ),
//             );
//           },
//           loading: () => Semantics(
//             label: 'Loading Nova Save summary',
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: SizedBox(
//                   height: 60,
//                   child: Center(
//                     child: CircularProgressIndicator(),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           error: (e, st) => Semantics(
//             label: 'Error loading Nova Save summary',
//             child: Card(
//               child: Padding(
//                 padding: const EdgeInsets.all(16),
//                 child: Text('Error loading Nova Save', style: TextStyle(color: Colors.red)),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildNavActions(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Semantics(
//           header: true,
//           child: Text(
//             'Quick Actions',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Row(
//           children: [
//             Expanded(
//               child: Semantics(
//                 button: true,
//                 label: 'Send Money',
//                 enabled: true,
//                 child: Card(
//                   child: InkWell(
//                     onTap: () => context.push(sendMoneyPath),
//                     borderRadius: BorderRadius.circular(12),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.send,
//                             size: 32,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(height: 8),
//                           Text('Send Money', textAlign: TextAlign.center),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Expanded(
//               child: Semantics(
//                 button: true,
//                 label: 'Nova Save',
//                 enabled: true,
//                 child: Card(
//                   child: InkWell(
//                     onTap: () => context.push(savePath),
//                     borderRadius: BorderRadius.circular(12),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16),
//                       child: Column(
//                         children: [
//                           Icon(
//                             Icons.savings,
//                             size: 32,
//                             color: Theme.of(context).colorScheme.primary,
//                           ),
//                           const SizedBox(height: 8),
//                           Text('Nova Save', textAlign: TextAlign.center),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildTransactionSection(BuildContext context, WidgetRef ref) {
//     final txAsync = ref.watch(recentTransactionsProviderProvider);
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Semantics(
//           header: true,
//           child: Text(
//             'Recent Transactions',
//             style: Theme.of(context).textTheme.titleMedium,
//           ),
//         ),
//         const SizedBox(height: 12),
//         txAsync.when(
//           data: (txList) {
//             if (txList.isEmpty) {
//               return Semantics(
//                 label: 'No transactions',
//                 child: Container(
//                   padding: const EdgeInsets.all(24),
//                   child: Text(
//                     'No transactions yet',
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               );
//             }
//             return RefreshIndicator(
//               onRefresh: () async {
//                 await ref
//                     .read(recentTransactionsRepositoryProvider)
//                     .refreshTransactions();
//               },
//               child: SizedBox(
//                 height: 300,
//                 child: ListView.builder(
//                   itemCount: txList.length,
//                   itemBuilder: (c, i) {
//                     final tx = txList[i];
//                     return Semantics(
//                       label: tx.accessibilityLabel,
//                       readOnly: true,
//                       child: Card(
//                         margin: const EdgeInsets.only(bottom: 8),
//                         child: InkWell(
//                           onTap: () => context.push('/transaction-details/${tx.id}'),
//                           child: ListTile(
//                             leading: Container(
//                               width: 48,
//                               height: 48,
//                               decoration: BoxDecoration(
//                                 color: tx.displayColor.withValues(alpha: 0.1),
//                                 shape: BoxShape.circle,
//                               ),
//                               child: Icon(
//                                 Icons.arrow_downward,
//                                 color: tx.displayColor,
//                                 size: 20,
//                               ),
//                             ),
//                             title: Text(
//                               tx.title,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                             ),
//                             subtitle: Row(
//                               children: [
//                                 Expanded(
//                                   child: Text(
//                                     tx.formattedDate,
//                                     maxLines: 1,
//                                     overflow: TextOverflow.ellipsis,
//                                   ),
//                                 ),
//                                 const SizedBox(width: 8),
//                                 _buildStatusBadge(tx),
//                               ],
//                             ),
//                             trailing: Text(
//                               tx.formattedAmountWithSign,
//                               style: TextStyle(
//                                 color: tx.displayColor,
//                                 fontWeight: FontWeight.bold,
//                               ),
//                             ),
//                           ),
//                         ),
//                       ),
//                     );
//                   },
//                 ),
//               ),
//             );
//           },
//           loading: () => const SizedBox(
//             height: 100,
//             child: Center(child: CircularProgressIndicator()),
//           ),
//           error: (e, st) => Center(child: Text('Error: $e')),
//         ),
//       ],
//     );
//   }

//   /// Builds a status badge for the transaction
//   Widget _buildStatusBadge(TransactionModel tx) {
//     final statusEnum = tx.statusEnum;
//     final statusColor = statusEnum == TransactionStatusType.completed
//         ? const Color(0xFF66BB6A)
//         : statusEnum == TransactionStatusType.pending
//             ? Colors.orange
//             : const Color(0xFFEF5350);

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: statusColor.withValues(alpha: 0.1),
//         borderRadius: BorderRadius.circular(4),
//         border: Border.all(color: statusColor, width: 0.5),
//       ),
//       child: Text(
//         statusEnum.displayName,
//         style: TextStyle(
//           color: statusColor,
//           fontSize: 12,
//           fontWeight: FontWeight.w500,
//         ),
//       ),
//     );
//   }

//   /// Formats Kobo amount to Naira string with currency symbol for display
//   String _formatNairaForDisplay(double naira) {
//     if (naira == 0) return '₦0.00';
    
//     String formatted = naira.toStringAsFixed(2);
//     // Add thousand separators
//     final parts = formatted.split('.');
//     final integerPart = parts[0];
//     final decimalPart = parts[1];
    
//     // Add commas to integer part
//     final buffer = StringBuffer();
//     for (int i = 0; i < integerPart.length; i++) {
//       if (i > 0 && (integerPart.length - i) % 3 == 0) {
//         buffer.write(',');
//       }
//       buffer.write(integerPart[i]);
//     }
    
//     return '₦${buffer.toString()}.$decimalPart';
//   }
// }


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/transaction_model.dart';
import '../../../common/models/user_model.dart';
import '../../../router/app_router.dart';
import '../../authentication/providers/auth_providers.dart';
import '../../offline_sync/services/sync_engine.dart';
import '../../nova_save/providers/nova_save_provider.dart';
import '../data/recent_transactions_repository.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userAsync = ref.watch(currentUserProfileStreamProvider);
    final authController = ref.read(authControllerProvider.notifier);
    ref.watch(syncEngineProvider);
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
      child: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(recentTransactionsRepositoryProvider)
              .refreshTransactions();
        },
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverToBoxAdapter(
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
                              const SizedBox(height: 4),
                              Text(
                                user.formattedBalance,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
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
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading: const Icon(Icons.account_balance),
                            title: const Text('NIBSS Account'),
                            subtitle: Text(user.accountNumber),
                            trailing: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Chip(label: Text('Tier ${user.kycTier}')),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    _buildNavActions(context),
                    const SizedBox(height: 32),
                    _buildNovaSaveSummaryCard(context, ref),
                    const SizedBox(height: 32),
                    Semantics(
                      header: true,
                      child: Text(
                        'Recent Transactions',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            _buildTransactionSliverSection(context, ref),
            const SliverToBoxAdapter(
              child: SizedBox(height: 24),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a dynamic Nova Save summary card showing total goals and saved amount
  Widget _buildNovaSaveSummaryCard(BuildContext context, WidgetRef ref) {
    final goalsAsync = ref.watch(savingsGoalsStreamProvider);
    final totalSavedAsync = ref.watch(totalSavedKoboProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Semantics(
          header: true,
          child: Text(
            'Nova Save',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        const SizedBox(height: 12),
        goalsAsync.when(
          data: (goals) {
            return totalSavedAsync.when(
              data: (totalKobo) {
                final naira = totalKobo / 100.0;
                final formattedAmount = _formatNairaForDisplay(naira);

                return Semantics(
                  label:
                      'Nova Save: ${goals.length} active goals, $formattedAmount total saved',
                  child: Card(
                    child: InkWell(
                      onTap: () => context.push(savePath),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Wrap(
                          alignment: WrapAlignment.spaceBetween,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${goals.length} Active Goals',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Saved: $formattedAmount',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                ),
                              ],
                            ),
                            Icon(
                              Icons.arrow_forward,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
              loading: () => Semantics(
                label: 'Loading Nova Save summary',
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
              ),
              error: (e, st) => Semantics(
                label: 'Error loading Nova Save summary',
                child: const Card(
                  child: Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Error loading Nova Save',
                        style: TextStyle(color: Colors.red)),
                  ),
                ),
              ),
            );
          },
          loading: () => Semantics(
            label: 'Loading Nova Save summary',
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ),
          error: (e, st) => Semantics(
            label: 'Error loading Nova Save summary',
            child: const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Text('Error loading Nova Save',
                    style: TextStyle(color: Colors.red)),
              ),
            ),
          ),
        ),
      ],
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
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - 12) / 2;
            return Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                SizedBox(
                  width: cardWidth < 140 ? constraints.maxWidth : cardWidth,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.send,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              const Text('Send Money',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: cardWidth < 140 ? constraints.maxWidth : cardWidth,
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
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.savings,
                                size: 32,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                              const SizedBox(height: 8),
                              const Text('Nova Save',
                                  textAlign: TextAlign.center),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _buildTransactionSliverSection(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(recentTransactionsProviderProvider);

    return txAsync.when(
      data: (txList) {
        if (txList.isEmpty) {
          return SliverToBoxAdapter(
            child: Semantics(
              label: 'No transactions',
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                child: const Text(
                  'No transactions yet',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }
        return SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (c, i) {
                final tx = txList[i];
                return Semantics(
                  label: tx.accessibilityLabel,
                  readOnly: true,
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: InkWell(
                      onTap: () =>
                          context.push('/transaction-details/${tx.id}'),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
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
                          title: Text(tx.title),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 8,
                              runSpacing: 4,
                              children: [
                                Text(tx.formattedDate),
                                _buildStatusBadge(tx),
                              ],
                            ),
                          ),
                          trailing: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              tx.formattedAmountWithSign,
                              style: TextStyle(
                                color: tx.displayColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
              childCount: txList.length,
            ),
          ),
        );
      },
      loading: () => const SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (e, st) => SliverToBoxAdapter(
        child: Center(child: Text('Error: $e')),
      ),
    );
  }

  /// Builds a status badge for the transaction
  Widget _buildStatusBadge(TransactionModel tx) {
    final statusEnum = tx.statusEnum;
    final statusColor = statusEnum == TransactionStatusType.completed
        ? const Color(0xFF66BB6A)
        : statusEnum == TransactionStatusType.pending
            ? Colors.orange
            : const Color(0xFFEF5350);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: statusColor, width: 0.5),
      ),
      child: Text(
        statusEnum.displayName,
        style: TextStyle(
          color: statusColor,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// Formats Kobo amount to Naira string with currency symbol for display
  String _formatNairaForDisplay(double naira) {
    if (naira == 0) return '₦0.00';

    String formatted = naira.toStringAsFixed(2);
    // Add thousand separators
    final parts = formatted.split('.');
    final integerPart = parts[0];
    final decimalPart = parts[1];

    // Add commas to integer part
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
