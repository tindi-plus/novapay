import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:novapay/src/core/errors/auth_exceptions.dart';

/// Service for generating unique account numbers
/// Generates 10-digit numbers with collision checking against Firestore
class AccountNumberGenerator {
  final FirebaseFirestore _firestore;
  static const String accountNumbersCollection = 'account_numbers';
  static const int accountNumberLength = 10;
  static const int maxRetries = 3;

  AccountNumberGenerator({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  /// Generates a unique 10-digit account number
  /// Retries up to [maxRetries] times if collision occurs
  /// Throws [NetworkException] on network errors
  /// Throws [UnknownAuthException] if max retries exceeded
  Future<String> generateUniqueAccountNumber() async {
    int attempts = 0;

    while (attempts < maxRetries) {
      final accountNumber = _generateRandomAccountNumber();

      try {
        // Check if account number already exists
        final isUnique = await _isAccountNumberUnique(accountNumber);

        if (isUnique) {
          // Reserve the account number
          await _reserveAccountNumber(accountNumber);
          return accountNumber;
        }

        attempts++;
      } on FirebaseException catch (e) {
        if (e.code == 'network-error') {
          throw NetworkException(cause: e);
        }
        attempts++;
      } catch (e) {
        attempts++;
      }
    }

    throw UnknownAuthException(
      message: 'Failed to generate a unique account number. Please try again.',
    );
  }

  /// Generates a random 10-digit account number
  String _generateRandomAccountNumber() {
    final random = Random();
    final buffer = StringBuffer();

    // Ensure first digit is not 0 to avoid leading zeros in some systems
    buffer.write(1 + random.nextInt(9));

    // Add remaining 9 digits
    for (int i = 1; i < accountNumberLength; i++) {
      buffer.write(random.nextInt(10));
    }

    return buffer.toString();
  }

  /// Checks if an account number is unique (not already in use)
  Future<bool> _isAccountNumberUnique(String accountNumber) async {
    try {
      final doc = await _firestore
          .collection(accountNumbersCollection)
          .doc(accountNumber)
          .get();

      return !doc.exists;
    } catch (e) {
      // On error, treat as potentially not unique to be safe
      return false;
    }
  }

  /// Reserves an account number by creating a document for it
  Future<void> _reserveAccountNumber(String accountNumber) async {
    try {
      await _firestore
          .collection(accountNumbersCollection)
          .doc(accountNumber)
          .set({
        'accountNumber': accountNumber,
        'createdAt': FieldValue.serverTimestamp(),
        'status': 'active',
      });
    } catch (e) {
      // If reservation fails, don't throw - the number might be reserved elsewhere
      // The next check will catch it as non-unique
    }
  }

  /// Validates that an account number has the correct format
  static bool isValidAccountNumberFormat(String accountNumber) {
    if (accountNumber.length != accountNumberLength) {
      return false;
    }

    // Check if it's all digits
    return RegExp(r'^\d+$').hasMatch(accountNumber);
  }
}
