// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recent_transactions_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Riverpod provider for RecentTransactionsRepository.

@ProviderFor(recentTransactionsRepository)
final recentTransactionsRepositoryProvider =
    RecentTransactionsRepositoryProvider._();

/// Riverpod provider for RecentTransactionsRepository.

final class RecentTransactionsRepositoryProvider
    extends
        $FunctionalProvider<
          RecentTransactionsRepository,
          RecentTransactionsRepository,
          RecentTransactionsRepository
        >
    with $Provider<RecentTransactionsRepository> {
  /// Riverpod provider for RecentTransactionsRepository.
  RecentTransactionsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentTransactionsRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentTransactionsRepositoryHash();

  @$internal
  @override
  $ProviderElement<RecentTransactionsRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  RecentTransactionsRepository create(Ref ref) {
    return recentTransactionsRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(RecentTransactionsRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<RecentTransactionsRepository>(value),
    );
  }
}

String _$recentTransactionsRepositoryHash() =>
    r'0a647468defa570f8fb1e8a8709e2f0995d145bb';

/// StreamProvider that exposes recent transactions to the UI.
/// Automatically watches Drift cache and Firestore updates.
/// Also includes pending transactions from the offline queue.
///
/// IMPORTANT: All provider watching is done here at the Riverpod provider level
/// to ensure proper dependency tracking and prevent multiple database instances.

@ProviderFor(recentTransactionsProvider)
final recentTransactionsProviderProvider =
    RecentTransactionsProviderProvider._();

/// StreamProvider that exposes recent transactions to the UI.
/// Automatically watches Drift cache and Firestore updates.
/// Also includes pending transactions from the offline queue.
///
/// IMPORTANT: All provider watching is done here at the Riverpod provider level
/// to ensure proper dependency tracking and prevent multiple database instances.

final class RecentTransactionsProviderProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TransactionModel>>,
          List<TransactionModel>,
          Stream<List<TransactionModel>>
        >
    with
        $FutureModifier<List<TransactionModel>>,
        $StreamProvider<List<TransactionModel>> {
  /// StreamProvider that exposes recent transactions to the UI.
  /// Automatically watches Drift cache and Firestore updates.
  /// Also includes pending transactions from the offline queue.
  ///
  /// IMPORTANT: All provider watching is done here at the Riverpod provider level
  /// to ensure proper dependency tracking and prevent multiple database instances.
  RecentTransactionsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'recentTransactionsProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$recentTransactionsProviderHash();

  @$internal
  @override
  $StreamProviderElement<List<TransactionModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<TransactionModel>> create(Ref ref) {
    return recentTransactionsProvider(ref);
  }
}

String _$recentTransactionsProviderHash() =>
    r'e9efb187aa3cf0df3c2d9d01391299e2eeb759d8';
