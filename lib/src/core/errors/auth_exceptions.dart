/// Typed exceptions for authentication operations
/// Provides specific error handling for different auth failure scenarios

/// Base exception class for all authentication-related errors
sealed class AuthException implements Exception {
  /// Human-readable error message
  final String message;

  /// Optional underlying exception cause
  final Exception? cause;

  AuthException({
    required this.message,
    this.cause,
  });

  @override
  String toString() => message;
}

/// Thrown when a user attempts to sign up with an email that already exists
class EmailAlreadyInUseException extends AuthException {
  EmailAlreadyInUseException({
    String message = 'This email is already registered. Please login or use a different email.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when login credentials are invalid
class InvalidCredentialsException extends AuthException {
  InvalidCredentialsException({
    String message = 'Invalid email or password. Please try again.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when a user account is not found
class UserNotFoundException extends AuthException {
  UserNotFoundException({
    String message = 'User account not found.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when a network error occurs
class NetworkException extends AuthException {
  NetworkException({
    String message = 'Network error. Please check your internet connection.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when an unknown authentication error occurs
class UnknownAuthException extends AuthException {
  UnknownAuthException({
    String message = 'An unexpected error occurred. Please try again.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when password validation fails
class WeakPasswordException extends AuthException {
  WeakPasswordException({
    String message = 'Password must be at least 8 characters long.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}

/// Thrown when an operation times out
class TimeoutException extends AuthException {
  TimeoutException({
    String message = 'Operation timed out. Please try again.',
    Exception? cause,
  }) : super(message: message, cause: cause);
}
