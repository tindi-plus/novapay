import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../common/models/transaction_model.dart';
import '../../../core/database/app_database.dart';

class TransactionDetailsScreen extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailsScreen({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final txAsync = ref.watch(_transactionDetailsProvider(transactionId));
    return Scaffold(
      appBar: AppBar(title: const Text('Transaction Details')),
      body: txAsync.when(
        data: (tx) => tx == null
            ? const Center(child: Text('Not found'))
            : _buildContent(context, tx),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildContent(BuildContext context, TransactionModel tx) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildStatusCard(context, tx),
            const SizedBox(height: 24),
            _detailRow(context, 'Amount', tx.formattedAmountWithSign, color: tx.displayColor),
            _detailRow(context, 'Type', tx.typeEnum.displayName),
            _detailRow(context, 'Date', DateFormat('MMM d, y • h:mm a').format(tx.createdAt)),
            _detailRow(context, 'ID', tx.id, isCopy: true),
            _detailRow(context, 'Description', tx.title),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context, TransactionModel tx) {
    final status = tx.statusEnum;
    final color = status == TransactionStatusType.completed
        ? const Color(0xFF66BB6A)
        : status == TransactionStatusType.pending
            ? Colors.orange
            : const Color(0xFFEF5350);
    final icon = status == TransactionStatusType.completed
        ? Icons.check_circle
        : status == TransactionStatusType.pending
            ? Icons.schedule
            : Icons.cancel;

    return Card(
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Status',
                    style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 8),
                Text(status.displayName,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold)),
              ],
            ),
            Icon(icon, color: Colors.white, size: 48),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(BuildContext context, String label, String value,
      {Color? color, bool isCopy = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis),
            ),
            if (isCopy)
              IconButton(
                icon: const Icon(Icons.copy, size: 20),
                onPressed: () => ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Copied'))),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Divider(height: 1, color: Colors.grey.withValues(alpha: 0.2)),
        const SizedBox(height: 16),
      ],
    );
  }
}

final _transactionDetailsProvider =
    FutureProvider.family<TransactionModel?, String>((ref, txId) async {
  final db = ref.watch(databaseProvider);
  final recentTxs = await db.watchRecentTransactions().first;
  for (final tx in recentTxs) {
    if (tx.id == txId) {
      return TransactionModel(
          id: tx.id,
          amountInKobo: tx.amountInKobo.toInt(),
          type: tx.type,
          title: tx.title,
          status: tx.status,
          createdAt: tx.createdAt);
    }
  }
  final pending = await db.watchPendingQueueItems().first;
  for (final item in pending) {
    if (item.id == txId) {
      return TransactionModel(
          id: item.id,
          amountInKobo: 0,
          type: 'debit',
          title: 'Pending',
          status: 'pending',
          createdAt: item.createdAt);
    }
  }
  return null;
});

