import 'package:flutter_test/flutter_test.dart';
import 'package:novapay/src/features/send_money/providers/send_money_provider.dart';

void main() {
  group('RecipientModel', () {
    test('creates RecipientModel with required properties', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      expect(recipient.accountNumber, equals('0987654321'));
      expect(recipient.fullName, equals('Jane Smith'));
      expect(recipient.userId, equals('user-456'));
    });

    test('handles special characters in full name', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: "O'Brien-Smith's",
        userId: 'user-456',
      );

      expect(recipient.fullName, equals("O'Brien-Smith's"));
    });

    test('handles long full names', () {
      const longName = 'Very Long Recipient Name With Multiple Words';
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: longName,
        userId: 'user-456',
      );

      expect(recipient.fullName, equals(longName));
    });

    test('handles numeric account numbers', () {
      final recipient = RecipientModel(
        accountNumber: '1234567890',
        fullName: 'Test User',
        userId: 'user-123',
      );

      expect(recipient.accountNumber, equals('1234567890'));
    });
  });

  group('SendMoneyFormState', () {
    test('creates default SendMoneyFormState', () {
      final formState = SendMoneyFormState();

      expect(formState.recipient, isNull);
      expect(formState.amountInKobo, isNull);
      expect(formState.idempotencyKey, isNull);
      expect(formState.error, isNull);
      expect(formState.isLoading, isFalse);
    });

    test('creates SendMoneyFormState with all properties', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      final formState = SendMoneyFormState(
        recipient: recipient,
        amountInKobo: 150000,
        idempotencyKey: 'key-123',
        error: null,
        isLoading: false,
      );

      expect(formState.recipient, equals(recipient));
      expect(formState.amountInKobo, equals(150000));
      expect(formState.idempotencyKey, equals('key-123'));
      expect(formState.error, isNull);
      expect(formState.isLoading, isFalse);
    });

    test('copyWith updates specific fields', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      final formState1 = SendMoneyFormState(recipient: recipient);
      final formState2 = formState1.copyWith(
        amountInKobo: 150000,
        isLoading: true,
      );

      expect(formState2.recipient, equals(recipient));
      expect(formState2.amountInKobo, equals(150000));
      expect(formState2.isLoading, isTrue);
    });

    test('copyWith preserves unchanged fields', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      final formState1 = SendMoneyFormState(
        recipient: recipient,
        amountInKobo: 100000,
        error: 'Previous error',
      );

      final formState2 = formState1.copyWith(isLoading: true);

      expect(formState2.recipient, equals(recipient));
      expect(formState2.amountInKobo, equals(100000));
      expect(formState2.isLoading, isTrue);
    });

    test('copyWith clears error when null', () {
      final formState1 = SendMoneyFormState(error: 'Some error');
      final formState2 = formState1.copyWith(error: null);

      expect(formState1.error, equals('Some error'));
      expect(formState2.error, isNull);
    });
  });

  group('SendMoneyFormState - Amount Handling', () {
    test('handles large amount in Kobo', () {
      final formState = SendMoneyFormState(
        amountInKobo: 999999999,
      );

      expect(formState.amountInKobo, equals(999999999));
    });

    test('handles minimum amount in Kobo', () {
      final formState = SendMoneyFormState(
        amountInKobo: 1,
      );

      expect(formState.amountInKobo, equals(1));
    });

    test('handles zero amount in Kobo', () {
      final formState = SendMoneyFormState(
        amountInKobo: 0,
      );

      expect(formState.amountInKobo, equals(0));
    });

    test('preserves amount on copyWith', () {
      final formState1 = SendMoneyFormState(amountInKobo: 150000);
      final formState2 = formState1.copyWith(isLoading: true);

      expect(formState2.amountInKobo, equals(150000));
    });

    test('updates amount when specified', () {
      final formState1 = SendMoneyFormState(amountInKobo: 100000);
      final formState2 = formState1.copyWith(amountInKobo: 200000);

      expect(formState1.amountInKobo, equals(100000));
      expect(formState2.amountInKobo, equals(200000));
    });
  });

  group('SendMoneyFormState - Error Handling', () {
    test('stores various error messages', () {
      final errors = [
        'Account not found',
        'Insufficient balance',
        'Network connection failed',
        'Transaction timeout',
        'Invalid account number',
      ];

      for (final error in errors) {
        final formState = SendMoneyFormState(error: error);
        expect(formState.error, equals(error));
      }
    });

    test('clears error on state update', () {
      final formState1 = SendMoneyFormState(
        error: 'Initial error',
        isLoading: false,
      );

      final formState2 = formState1.copyWith(
        error: null,
        isLoading: true,
      );

      expect(formState1.error, equals('Initial error'));
      expect(formState2.error, isNull);
    });

    test('distinguishes between null and empty error', () {
      final formState1 = SendMoneyFormState(error: null);
      final formState2 = SendMoneyFormState(error: '');

      expect(formState1.error, isNull);
      expect(formState2.error, equals(''));
    });
  });

  group('SendMoneyFormState - Loading State', () {
    test('defaults to not loading', () {
      final formState = SendMoneyFormState();
      expect(formState.isLoading, isFalse);
    });

    test('can be set to loading', () {
      final formState = SendMoneyFormState(isLoading: true);
      expect(formState.isLoading, isTrue);
    });

    test('loading state persists on copyWith', () {
      final formState1 = SendMoneyFormState(isLoading: true);
      final formState2 = formState1.copyWith();

      expect(formState2.isLoading, isTrue);
    });

    test('loading state can be toggled', () {
      final formState1 = SendMoneyFormState(isLoading: true);
      final formState2 = formState1.copyWith(isLoading: false);

      expect(formState1.isLoading, isTrue);
      expect(formState2.isLoading, isFalse);
    });
  });

  group('SendMoneyFormState - Idempotency', () {
    test('stores idempotency key', () {
      final key = 'unique-key-12345';
      final formState = SendMoneyFormState(
        idempotencyKey: key,
      );

      expect(formState.idempotencyKey, equals(key));
    });

    test('preserves idempotency key on copyWith', () {
      final key = 'unique-key-12345';
      final formState1 = SendMoneyFormState(idempotencyKey: key);
      final formState2 = formState1.copyWith(isLoading: true);

      expect(formState2.idempotencyKey, equals(key));
    });

    test('updates idempotency key when specified', () {
      final key1 = 'key-1';
      final key2 = 'key-2';

      final formState1 = SendMoneyFormState(idempotencyKey: key1);
      final formState2 = formState1.copyWith(idempotencyKey: key2);

      expect(formState1.idempotencyKey, equals(key1));
      expect(formState2.idempotencyKey, equals(key2));
    });
  });

  group('SendMoneyFormState - Recipient Handling', () {
    test('preserves recipient on copyWith', () {
      final recipient = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      final formState1 = SendMoneyFormState(recipient: recipient);
      final formState2 = formState1.copyWith(isLoading: true);

      expect(formState2.recipient, equals(recipient));
    });

    test('can update recipient', () {
      final recipient1 = RecipientModel(
        accountNumber: '1234567890',
        fullName: 'John Doe',
        userId: 'user-123',
      );

      final recipient2 = RecipientModel(
        accountNumber: '0987654321',
        fullName: 'Jane Smith',
        userId: 'user-456',
      );

      final formState1 = SendMoneyFormState(recipient: recipient1);
      final formState2 = formState1.copyWith(recipient: recipient2);

      expect(formState1.recipient?.fullName, equals('John Doe'));
      expect(formState2.recipient?.fullName, equals('Jane Smith'));
    });
  });
}

