import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../common/models/user_model.dart';
import '../../authentication/providers/auth_providers.dart';
import '../providers/send_money_provider.dart';
import 'send_confirmation_modal.dart';

class SendMoneyScreen extends ConsumerStatefulWidget {
  const SendMoneyScreen({super.key});

  @override
  ConsumerState<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends ConsumerState<SendMoneyScreen> {
  late final TextEditingController _accountNumberController;
  late final TextEditingController _amountController;
  String? _recipientLookupError;
  String? _amountError;

  @override
  void initState() {
    super.initState();
    _accountNumberController = TextEditingController();
    _amountController = TextEditingController();
  }

  @override
  void dispose() {
    _accountNumberController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  /// Convert user input string to Kobo integer
  int? _parseAmountToKobo(String input) {
    if (input.isEmpty) return null;
    try {
      final doubleAmount = double.parse(input);
      return (doubleAmount * 100).round();
    } catch (_) {
      return null;
    }
  }

  void _handleRecipientSearch(String value) {
    setState(() {
      _recipientLookupError = null;
    });
  }

  void _handleAmountChange(String value) {
    setState(() {
      _amountError = null;
    });

    // Update controller state with parsed amount
    final amountInKobo = _parseAmountToKobo(value);
    if (amountInKobo != null) {
      ref.read(sendMoneyProvider.notifier).setAmountKobo(amountInKobo);
    }
  }

  Future<void> _handleConfirmSend() async {
    final accountNumber = _accountNumberController.text.trim();
    final amountInput = _amountController.text.trim();

    // Validate recipient
    if (accountNumber.isEmpty) {
      setState(() {
        _recipientLookupError = 'Please enter recipient account number';
      });
      return;
    }

    if (accountNumber.length != 10) {
      setState(() {
        _recipientLookupError = 'Account number must be 10 digits';
      });
      return;
    }

    // Validate amount
    final amountInKobo = _parseAmountToKobo(amountInput);
    if (amountInKobo == null) {
      setState(() {
        _amountError = 'Please enter a valid amount';
      });
      return;
    }

    // Get recipient from the lookup provider
    final recipient = ref
        .read(
          recipientLookupProvider(
            accountNumber: _accountNumberController.text.trim(),
          ),
        )
        .requireValue;

    if (recipient == null) {
      setState(() {
        _recipientLookupError =
            'Recipient not found. Please verify account number';
      });
      return;
    }

    // Show confirmation modal
    if (mounted) {
      showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (context) => SendConfirmationModal(
          recipient: recipient,
          amountInKobo: amountInKobo,
          onConfirm: () async {
            // Pop modal
            Navigator.of(context).pop();

            // Process transaction
            await ref
                .read(sendMoneyProvider.notifier)
                .processSendMoney(
                  recipient: recipient,
                  amountInKobo: amountInKobo,
                );

            // Check if success (pop to previous screen)
            final finalState = ref.read(sendMoneyProvider);
            if (finalState.error == null && finalState.idempotencyKey != null) {
              print("Money is sent successfully: Huraaaay!!");
              if (context.mounted) {
                context.pop();
              }
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(currentUserProfileStreamProvider);
    final recipientLookupAsync = ref.watch(
      recipientLookupProvider(
        accountNumber: _accountNumberController.text.trim(),
      ),
    );
    final formState = ref.watch(sendMoneyProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Send Money'), elevation: 0),
      body: userAsync.when(
        data: (user) => user == null
            ? Center(child: Text('User profile not found'))
            : _buildSendForm(context, user, recipientLookupAsync, formState),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
      ),
    );
  }

  Widget _buildSendForm(
    BuildContext context,
    UserModel user,
    AsyncValue<RecipientModel?> recipientLookupAsync,
    SendMoneyFormState formState,
  ) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Recipient', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 12),
          Semantics(
            label: 'Recipient NIBSS account number input field',
            child: TextField(
              controller: _accountNumberController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              onChanged: _handleRecipientSearch,
              decoration: InputDecoration(
                hintText: '1234567890',
                labelText: 'NIBSS Account (10 digits)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                errorText: _recipientLookupError,
              ),
            ),
          ),
          const SizedBox(height: 16),
          _buildRecipientCard(context, recipientLookupAsync),
          const SizedBox(height: 24),
          _buildAmountSection(context, user),
          const SizedBox(height: 32),
          _buildErrorDisplay(formState),
          _buildConfirmButton(formState),
        ],
      ),
    );
  }

  Widget _buildRecipientCard(
    BuildContext context,
    AsyncValue<RecipientModel?> recipientLookupAsync,
  ) {
    if (recipientLookupAsync.value == null) {
      return const SizedBox.shrink();
    }

    return Semantics(
      label: 'Recipient name: ${recipientLookupAsync.value?.fullName}',
      readOnly: true,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              const Icon(Icons.account_circle, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Recipient',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      recipientLookupAsync.value?.fullName ?? '',
                      style: Theme.of(context).textTheme.bodyLarge
                          ?.copyWith(fontWeight: FontWeight.w600),
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

  Widget _buildAmountSection(BuildContext context, UserModel user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Amount', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 12),
        Semantics(
          label: 'Amount in Naira. Available: ${user.formattedBalance}',
          child: TextField(
            controller: _amountController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: _handleAmountChange,
            decoration: InputDecoration(
              hintText: '0.00',
              labelText: 'Amount (₦)',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              prefixText: '₦ ',
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
              errorText: _amountError,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Semantics(
          label: 'Available balance ${user.formattedBalance}',
          readOnly: true,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Available Balance'),
              Text(
                user.formattedBalance,
                style: Theme.of(context).textTheme.bodyLarge
                    ?.copyWith(fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildErrorDisplay(SendMoneyFormState formState) {
    if (formState.error == null) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Semantics(
        label: 'Error: ${formState.error}',
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            border: Border.all(color: Colors.red.shade300),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            formState.error ?? '',
            style: TextStyle(color: Colors.red.shade700),
          ),
        ),
      ),
    );
  }

  Widget _buildConfirmButton(SendMoneyFormState formState) {
    return SizedBox(
      width: double.infinity,
      child: Semantics(
        button: true,
        label: 'Confirm and send money button',
        child: ElevatedButton(
          onPressed: formState.isLoading ? null : _handleConfirmSend,
          style: ElevatedButton.styleFrom(
            minimumSize: const Size(double.infinity, 48),
          ),
          child: formState.isLoading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : const Text('Confirm & Send'),
        ),
      ),
    );
  }
}
