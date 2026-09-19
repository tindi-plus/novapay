// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nova_save_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// StreamProvider for active savings goals for current user.
///
/// Watches: auth state, repository, firestore sync service
/// Returns: `Stream<List<SavingsGoalModel>>` of user's goals

@ProviderFor(savingsGoalsStream)
final savingsGoalsStreamProvider = SavingsGoalsStreamProvider._();

/// StreamProvider for active savings goals for current user.
///
/// Watches: auth state, repository, firestore sync service
/// Returns: `Stream<List<SavingsGoalModel>>` of user's goals

final class SavingsGoalsStreamProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SavingsGoalModel>>,
          List<SavingsGoalModel>,
          Stream<List<SavingsGoalModel>>
        >
    with
        $FutureModifier<List<SavingsGoalModel>>,
        $StreamProvider<List<SavingsGoalModel>> {
  /// StreamProvider for active savings goals for current user.
  ///
  /// Watches: auth state, repository, firestore sync service
  /// Returns: `Stream<List<SavingsGoalModel>>` of user's goals
  SavingsGoalsStreamProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'savingsGoalsStreamProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$savingsGoalsStreamHash();

  @$internal
  @override
  $StreamProviderElement<List<SavingsGoalModel>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SavingsGoalModel>> create(Ref ref) {
    return savingsGoalsStream(ref);
  }
}

String _$savingsGoalsStreamHash() =>
    r'5317760d587aaebbc647a9ccd37720cf6ffa0e1a';

/// StreamProvider calculating total saved Kobo across all active goals.
///
/// Watches: savingsGoalsStreamProvider (via its underlying repository stream)
/// Returns: `Stream<int>` - total saved amount in kobo

@ProviderFor(totalSavedKobo)
final totalSavedKoboProvider = TotalSavedKoboProvider._();

/// StreamProvider calculating total saved Kobo across all active goals.
///
/// Watches: savingsGoalsStreamProvider (via its underlying repository stream)
/// Returns: `Stream<int>` - total saved amount in kobo

final class TotalSavedKoboProvider
    extends $FunctionalProvider<AsyncValue<int>, int, Stream<int>>
    with $FutureModifier<int>, $StreamProvider<int> {
  /// StreamProvider calculating total saved Kobo across all active goals.
  ///
  /// Watches: savingsGoalsStreamProvider (via its underlying repository stream)
  /// Returns: `Stream<int>` - total saved amount in kobo
  TotalSavedKoboProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'totalSavedKoboProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$totalSavedKoboHash();

  @$internal
  @override
  $StreamProviderElement<int> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<int> create(Ref ref) {
    return totalSavedKobo(ref);
  }
}

String _$totalSavedKoboHash() => r'155590368f8c61e229c071c4fd486242d5ee5f18';
