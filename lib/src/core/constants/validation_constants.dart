/// Validation constants and patterns used throughout the authentication feature

class ValidationConstants {
  ValidationConstants._(); // Private constructor to prevent instantiation

  // Password validation
  static const int minPasswordLength = 8;
  static const int maxPasswordLength = 128;

  // Name validation
  static const int minNameLength = 2;
  static const int maxNameLength = 50;

  // Phone number validation
  static const int nigerianPhoneMinLength = 10;
  static const int nigerianPhoneMaxLength = 15;

  // BVN/NIN validation
  static const int bvnLength = 11;
  static const int ninLength = 11;

  // Email validation pattern (RFC 5322 simplified)
  static const String emailPattern =
      r'^[a-zA-Z0-9.!#$%&*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$';

  // Numeric pattern for BVN/NIN
  static const String numericPattern = r'^\d+$';

  // Account number format (10 digits)
  static const int accountNumberLength = 10;
}

/// Validation error messages
class ValidationMessages {
  ValidationMessages._();

  // Email messages
  static const String emailRequired = 'Email is required';
  static const String emailInvalid = 'Please enter a valid email address';

  // Password messages
  static const String passwordRequired = 'Password is required';
  static const String passwordTooShort =
      'Password must be at least ${ValidationConstants.minPasswordLength} characters';
  static const String passwordNoMatch = 'Passwords do not match';

  // Name messages
  static const String firstNameRequired = 'First name is required';
  static const String lastNameRequired = 'Last name is required';
  static const String nameInvalid = 'Name must be between ${ValidationConstants.minNameLength} and ${ValidationConstants.maxNameLength} characters';

  // Phone messages
  static const String phoneRequired = 'Phone number is required';
  static const String phoneInvalid =
      'Please enter a valid Nigerian phone number';

  // BVN/NIN messages
  static const String bvnRequired = 'BVN is required';
  static const String bvnInvalid = 'BVN must be exactly ${ValidationConstants.bvnLength} digits';
  static const String ninRequired = 'NIN is required';
  static const String ninInvalid = 'NIN must be exactly ${ValidationConstants.ninLength} digits';

  // Confirm password message
  static const String confirmPasswordRequired = 'Please confirm your password';
}
