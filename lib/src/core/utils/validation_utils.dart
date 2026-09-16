import 'package:novapay/src/core/constants/validation_constants.dart';

/// Utility class for input validation across the application
class ValidationUtils {
  ValidationUtils._(); // Private constructor to prevent instantiation

  /// Validates email format
  /// Returns null if valid, error message if invalid
  static String? validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return ValidationMessages.emailRequired;
    }

    final emailRegex = RegExp(ValidationConstants.emailPattern);
    if (!emailRegex.hasMatch(email)) {
      return ValidationMessages.emailInvalid;
    }

    return null;
  }

  /// Validates password strength
  /// Returns null if valid, error message if invalid
  static String? validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return ValidationMessages.passwordRequired;
    }

    if (password.length < ValidationConstants.minPasswordLength) {
      return ValidationMessages.passwordTooShort;
    }

    return null;
  }

  /// Validates that password and confirmation match
  /// Returns null if valid, error message if invalid
  static String? validatePasswordMatch(String? password, String? confirmPassword) {
    if (confirmPassword == null || confirmPassword.isEmpty) {
      return ValidationMessages.confirmPasswordRequired;
    }

    if (password != confirmPassword) {
      return ValidationMessages.passwordNoMatch;
    }

    return null;
  }

  /// Validates first name
  /// Returns null if valid, error message if invalid
  static String? validateFirstName(String? name) {
    if (name == null || name.isEmpty) {
      return ValidationMessages.firstNameRequired;
    }

    if (name.length < ValidationConstants.minNameLength ||
        name.length > ValidationConstants.maxNameLength) {
      return ValidationMessages.nameInvalid;
    }

    return null;
  }

  /// Validates last name
  /// Returns null if valid, error message if invalid
  static String? validateLastName(String? name) {
    if (name == null || name.isEmpty) {
      return ValidationMessages.lastNameRequired;
    }

    if (name.length < ValidationConstants.minNameLength ||
        name.length > ValidationConstants.maxNameLength) {
      return ValidationMessages.nameInvalid;
    }

    return null;
  }

  /// Validates phone number (Nigerian format)
  /// Returns null if valid, error message if invalid
  static String? validatePhoneNumber(String? phone) {
    if (phone == null || phone.isEmpty) {
      return ValidationMessages.phoneRequired;
    }

    // Remove common separators
    final cleanPhone = phone.replaceAll(RegExp(r'[\s\-\+]'), '');

    if (cleanPhone.length < ValidationConstants.nigerianPhoneMinLength ||
        cleanPhone.length > ValidationConstants.nigerianPhoneMaxLength) {
      return ValidationMessages.phoneInvalid;
    }

    // Check if it's numeric
    if (!RegExp(ValidationConstants.numericPattern).hasMatch(cleanPhone)) {
      return ValidationMessages.phoneInvalid;
    }

    return null;
  }

  /// Validates BVN (11 digits)
  /// Returns null if valid, error message if invalid
  static String? validateBVN(String? bvn) {
    if (bvn == null || bvn.isEmpty) {
      return ValidationMessages.bvnRequired;
    }

    if (bvn.length != ValidationConstants.bvnLength) {
      return ValidationMessages.bvnInvalid;
    }

    if (!RegExp(ValidationConstants.numericPattern).hasMatch(bvn)) {
      return ValidationMessages.bvnInvalid;
    }

    return null;
  }

  /// Validates NIN (11 digits)
  /// Returns null if valid, error message if invalid
  static String? validateNIN(String? nin) {
    if (nin == null || nin.isEmpty) {
      return ValidationMessages.ninRequired;
    }

    if (nin.length != ValidationConstants.ninLength) {
      return ValidationMessages.ninInvalid;
    }

    if (!RegExp(ValidationConstants.numericPattern).hasMatch(nin)) {
      return ValidationMessages.ninInvalid;
    }

    return null;
  }

  /// Validates all signup fields at once
  /// Returns a map of field names to error messages
  static Map<String, String> validateSignupForm({
    required String email,
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String bvn,
    required String nin,
    required String password,
    required String confirmPassword,
  }) {
    final errors = <String, String>{};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final firstNameError = validateFirstName(firstName);
    if (firstNameError != null) errors['firstName'] = firstNameError;

    final lastNameError = validateLastName(lastName);
    if (lastNameError != null) errors['lastName'] = lastNameError;

    final phoneError = validatePhoneNumber(phoneNumber);
    if (phoneError != null) errors['phoneNumber'] = phoneError;

    final bvnError = validateBVN(bvn);
    if (bvnError != null) errors['bvn'] = bvnError;

    final ninError = validateNIN(nin);
    if (ninError != null) errors['nin'] = ninError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    final passwordMatchError = validatePasswordMatch(password, confirmPassword);
    if (passwordMatchError != null) errors['confirmPassword'] = passwordMatchError;

    return errors;
  }

  /// Validates login form fields
  /// Returns a map of field names to error messages
  static Map<String, String> validateLoginForm({
    required String email,
    required String password,
  }) {
    final errors = <String, String>{};

    final emailError = validateEmail(email);
    if (emailError != null) errors['email'] = emailError;

    final passwordError = validatePassword(password);
    if (passwordError != null) errors['password'] = passwordError;

    return errors;
  }
}
