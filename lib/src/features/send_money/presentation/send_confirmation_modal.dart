// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';

// import '../providers/send_money_provider.dart';

// class SendConfirmationModal extends StatefulWidget {
//   final RecipientModel recipient;
//   final int amountInKobo;
//   final VoidCallback onConfirm;

//   const SendConfirmationModal({
//     super.key,
//     required this.recipient,
//     required this.amountInKobo,
//     required this.onConfirm,
//   });

//   @override
//   State<SendConfirmationModal> createState() => _SendConfirmationModalState();
// }

// class _SendConfirmationModalState extends State<SendConfirmationModal> {
//   bool _isProcessing = false;

//   String _formatKoboToNaira(int kobo) {
//     final naira = kobo / 100;
//     return NumberFormat.currency(
//       locale: 'en_NG',
//       symbol: '₦',
//       decimalDigits: 2,
//     ).format(naira);
//   }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final amountNaira = _formatKoboToNaira(widget.amountInKobo);

//     return SingleChildScrollView(
//       child: Padding(
//         padding: EdgeInsets.only(
//           left: 24,
//           right: 24,
//           top: 24,
//           bottom: MediaQuery.of(context).viewInsets.bottom + 24,
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Semantics(
//               header: true,
//               child: Text(
//                 'Confirm Transaction',
//                 style: theme.textTheme.headlineSmall,
//                 textAlign: TextAlign.center,
//               ),
//             ),
//             const SizedBox(height: 32),
//             _buildTransactionCard(context, theme, amountNaira),
//             const SizedBox(height: 32),
//             _buildConfirmButton(),
//             const SizedBox(height: 12),
//             _buildCancelButton(context),
//             const SizedBox(height: 12),
//             _buildDisclaimer(theme),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildTransactionCard(BuildContext context, ThemeData theme, String amountNaira) {
//     return Semantics(
//       label: 'Transaction details card',
//       child: Card(
//         elevation: 0,
//         color: Colors.grey.shade50,
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               _buildDetailRow(
//                 label: 'Recipient',
//                 value: widget.recipient.fullName,
//                 theme: theme,
//               ),
//               const SizedBox(height: 16),
//               _buildDetailRow(
//                 label: 'Account Number',
//                 value: widget.recipient.accountNumber,
//                 theme: theme,
//               ),
//               const SizedBox(height: 24),
//               Container(height: 1, color: Colors.grey.shade300),
//               const SizedBox(height: 24),
//               Semantics(
//                 label: 'Amount to send: $amountNaira',
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     const Text('Amount'),
//                     Text(
//                       amountNaira,
//                       style: theme.textTheme.headlineSmall?.copyWith(
//                         fontWeight: FontWeight.bold,
//                         color: Colors.green.shade700,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow({
//     required String label,
//     required String value,
//     required ThemeData theme,
//   }) {
//     return Semantics(
//       label: '$label: $value',
//       readOnly: true,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Text(label, style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600)),
//           Text(value, style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
//         ],
//       ),
//     );
//   }

//   Widget _buildConfirmButton() {
//     return Semantics(
//       button: true,
//       label: 'Confirm and send money button',
//       child: SizedBox(
//         height: 48,
//         child: ElevatedButton(
//           onPressed: _isProcessing ? null : _handleConfirm,
//           child: _isProcessing
//               ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
//               : const Text('Confirm & Send'),
//         ),
//       ),
//     );
//   }

//   Widget _buildCancelButton(BuildContext context) {
//     return Semantics(
//       button: true,
//       label: 'Cancel button',
//       child: SizedBox(
//         height: 48,
//         child: OutlinedButton(
//           onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
//           child: const Text('Cancel'),
//         ),
//       ),
//     );
//   }

//   Widget _buildDisclaimer(ThemeData theme) {
//     return Semantics(
//       label: 'Disclaimer text',
//       child: Text(
//         'Please review the transaction details carefully before confirming. This action cannot be undone.',
//         style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
//         textAlign: TextAlign.center,
//       ),
//     );
//   }

//   Future<void> _handleConfirm() async {
//     setState(() {
//       _isProcessing = true;
//     });

//     try {
//       widget.onConfirm();
//     } finally {
//       if (mounted) {
//         setState(() {
//           _isProcessing = false;
//         });
//       }
//     }
//   }
// }


import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../providers/send_money_provider.dart';

class SendConfirmationModal extends StatefulWidget {
  final RecipientModel recipient;
  final int amountInKobo;
  final VoidCallback onConfirm;

  const SendConfirmationModal({
    super.key,
    required this.recipient,
    required this.amountInKobo,
    required this.onConfirm,
  });

  @override
  State<SendConfirmationModal> createState() => _SendConfirmationModalState();
}

class _SendConfirmationModalState extends State<SendConfirmationModal> {
  bool _isProcessing = false;

  String _formatKoboToNaira(int kobo) {
    final naira = kobo / 100;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final amountNaira = _formatKoboToNaira(widget.amountInKobo);

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
            Semantics(
              header: true,
              child: Text(
                'Confirm Transaction',
                style: theme.textTheme.headlineSmall,
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 32),
            _buildTransactionCard(context, theme, amountNaira),
            const SizedBox(height: 32),
            _buildConfirmButton(),
            const SizedBox(height: 12),
            _buildCancelButton(context),
            const SizedBox(height: 12),
            _buildDisclaimer(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(BuildContext context, ThemeData theme, String amountNaira) {
    return Semantics(
      label: 'Transaction details card',
      child: Card(
        elevation: 0,
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailRow(
                label: 'Recipient',
                value: widget.recipient.fullName,
                theme: theme,
              ),
              const SizedBox(height: 16),
              _buildDetailRow(
                label: 'Account Number',
                value: widget.recipient.accountNumber,
                theme: theme,
              ),
              const SizedBox(height: 24),
              Container(height: 1, color: Colors.grey.shade300),
              const SizedBox(height: 24),
              Semantics(
                label: 'Amount to send: $amountNaira',
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  runSpacing: 4,
                  children: [
                    Text('Amount', style: theme.textTheme.bodyMedium),
                    Text(
                      amountNaira,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required String label,
    required String value,
    required ThemeData theme,
  }) {
    return Semantics(
      label: '$label: $value',
      readOnly: true,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 4,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(color: Colors.grey.shade600),
          ),
          Text(
            value,
            style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildConfirmButton() {
    return Semantics(
      button: true,
      label: 'Confirm and send money button',
      child: ElevatedButton(
        onPressed: _isProcessing ? null : _handleConfirm,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          minimumSize: const Size.fromHeight(48),
        ),
        child: _isProcessing
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Text(
                'Confirm & Send',
                textAlign: TextAlign.center,
              ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Cancel button',
      child: OutlinedButton(
        onPressed: _isProcessing ? null : () => Navigator.of(context).pop(),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          minimumSize: const Size.fromHeight(48),
        ),
        child: const Text(
          'Cancel',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildDisclaimer(ThemeData theme) {
    return Semantics(
      label: 'Disclaimer text',
      child: Text(
        'Please review the transaction details carefully before confirming. This action cannot be undone.',
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade600),
        textAlign: TextAlign.center,
      ),
    );
  }

  Future<void> _handleConfirm() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      widget.onConfirm();
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
}