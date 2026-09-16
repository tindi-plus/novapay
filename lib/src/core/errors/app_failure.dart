/// Base failure class used across the app (extended by auth and send_money).
sealed class AppFailure implements Exception {
  final String message;
  final Exception? cause;

  const AppFailure({required this.message, this.cause});

  @override
  String toString() => message;
}
