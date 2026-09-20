import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/security/biometric_service.dart';
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
  late final BiometricService _biometricService;

  @override
  void initState() {
    super.initState();
    _biometricService = BiometricService();
  }

  String _formatKoboToNaira(int kobo) {
    final naira = kobo / 100;
    return NumberFormat.currency(
      locale: 'en_NG',
      symbol: '₦',
      decimalDigits: 2,
    ).format(naira);
  }

  /// Check if transaction amount exceeds the biometric verification threshold
  /// Threshold: NGN 5,000 (500,000 Kobo)
  bool _isHighValueTransaction() {
    const highValueThresholdKobo = 500000; // ₦5,000.00
    return widget.amountInKobo > highValueThresholdKobo;
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

  /// Handle confirmation with biometric verification for high-value transactions
  Future<void> _handleConfirm() async {
    setState(() {
      _isProcessing = true;
    });

    try {
      // Check if transaction exceeds high-value threshold
      if (_isHighValueTransaction()) {
        final amountNaira = _formatKoboToNaira(widget.amountInKobo);

        // Attempt biometric verification
        final biometricsAvailable = await _biometricService.checkBiometricsAvailable();

        if (!mounted) return;

        if (biometricsAvailable) {
          // Display accessibility-wrapped biometric authentication prompt
          final authenticationReason =
              'Please verify your fingerprint/biometrics to approve transfer of $amountNaira';

          final isAuthenticated = await _showBiometricVerification(
            authenticationReason,
            amountNaira,
          );

          if (!isAuthenticated) {
            // Authentication failed or was cancelled
            if (mounted) {
              setState(() {
                _isProcessing = false;
              });
              _showBiometricErrorDialog(amountNaira);
            }
            return;
          }
        } else {
          // No biometric hardware/enrollment - show alert
          if (mounted) {
            setState(() {
              _isProcessing = false;
            });
            _showNoBiometricDialog(amountNaira);
          }
          return;
        }
      }

      // Biometric verification passed (or transaction is under threshold)
      // Proceed with transaction dispatch
      widget.onConfirm();
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  /// Show biometric verification dialog with accessibility support
  Future<bool> _showBiometricVerification(
    String authenticationReason,
    String amountNaira,
  ) async {
    // Create accessibility-wrapped prompt
    final result = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        title: Semantics(
          label: 'High value transaction step: Biometric authentication requested for transfer of $amountNaira',
          child: const Text('Verify Identity'),
        ),
        content: Semantics(
          label: 'A biometric verification is required to complete this high-value transfer',
          child: Text(authenticationReason),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Perform biometric authentication
              try {
                final authenticated = await _biometricService.authenticateForTransaction(
                  localizedReason: authenticationReason,
                );

                // Use mounted check and navigator within the context where it's safe
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(dialogContext).pop(authenticated);
              } catch (e) {
                // Use mounted check and navigator within the context where it's safe
                if (!mounted) return;
                // ignore: use_build_context_synchronously
                Navigator.of(dialogContext).pop(false);
              }
            },
            child: const Text('Authenticate'),
          ),
        ],
      ),
    );
    
    return result ?? false;
  }

  /// Show error dialog when biometric verification fails
  void _showBiometricErrorDialog(String amountNaira) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Authentication Failed'),
        content: Semantics(
          label: 'Biometric verification required for transfers over ₦5,000.00',
          child: Text(
            'Biometric verification required for transfers over $amountNaira.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  /// Show alert when device doesn't have biometric capabilities
  void _showNoBiometricDialog(String amountNaira) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Biometric Not Available'),
        content: Semantics(
          label: 'Biometric verification required for transfers over ₦5,000.00',
          child: Text(
            'This is a high-value transfer requiring biometric verification. '
            'Your device does not have biometric authentication available. '
            'Please enroll a biometric method in your device settings to proceed with transfers over $amountNaira.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}