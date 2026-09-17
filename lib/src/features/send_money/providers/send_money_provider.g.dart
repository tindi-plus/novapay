// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'send_money_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Recipient lookup from Firestore by 10-digit NIBSS account number

@ProviderFor(recipientLookup)
final recipientLookupProvider = RecipientLookupFamily._();

/// Recipient lookup from Firestore by 10-digit NIBSS account number

final class RecipientLookupProvider
    extends
        $FunctionalProvider<
          AsyncValue<RecipientModel?>,
          RecipientModel?,
          FutureOr<RecipientModel?>
        >
    with $FutureModifier<RecipientModel?>, $FutureProvider<RecipientModel?> {
  /// Recipient lookup from Firestore by 10-digit NIBSS account number
  RecipientLookupProvider._({
    required RecipientLookupFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'recipientLookupProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$recipientLookupHash();

  @override
  String toString() {
    return r'recipientLookupProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<RecipientModel?> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<RecipientModel?> create(Ref ref) {
    final argument = this.argument as String;
    return recipientLookup(ref, accountNumber: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is RecipientLookupProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$recipientLookupHash() => r'c30427a0268b77fc5df9f940723dea08883ca653';

/// Recipient lookup from Firestore by 10-digit NIBSS account number

final class RecipientLookupFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<RecipientModel?>, String> {
  RecipientLookupFamily._()
    : super(
        retry: null,
        name: r'recipientLookupProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Recipient lookup from Firestore by 10-digit NIBSS account number

  RecipientLookupProvider call({required String accountNumber}) =>
      RecipientLookupProvider._(argument: accountNumber, from: this);

  @override
  String toString() => r'recipientLookupProvider';
}

/// Validates amount in Kobo against user's wallet balance

@ProviderFor(validateAmountKobo)
final validateAmountKoboProvider = ValidateAmountKoboFamily._();

/// Validates amount in Kobo against user's wallet balance

final class ValidateAmountKoboProvider
    extends $FunctionalProvider<AsyncValue<String?>, String?, FutureOr<String?>>
    with $FutureModifier<String?>, $FutureProvider<String?> {
  /// Validates amount in Kobo against user's wallet balance
  ValidateAmountKoboProvider._({
    required ValidateAmountKoboFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'validateAmountKoboProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$validateAmountKoboHash();

  @override
  String toString() {
    return r'validateAmountKoboProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<String?> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<String?> create(Ref ref) {
    final argument = this.argument as int;
    return validateAmountKobo(ref, amountInKobo: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is ValidateAmountKoboProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$validateAmountKoboHash() =>
    r'c20ab8788f0c2c8733e8614f7a7bd16c83abf121';

/// Validates amount in Kobo against user's wallet balance

final class ValidateAmountKoboFamily extends $Family
    with $FunctionalFamilyOverride<FutureOr<String?>, int> {
  ValidateAmountKoboFamily._()
    : super(
        retry: null,
        name: r'validateAmountKoboProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Validates amount in Kobo against user's wallet balance

  ValidateAmountKoboProvider call({required int amountInKobo}) =>
      ValidateAmountKoboProvider._(argument: amountInKobo, from: this);

  @override
  String toString() => r'validateAmountKoboProvider';
}

/// Riverpod provider for SendMoney form state machine

@ProviderFor(SendMoney)
final sendMoneyProvider = SendMoneyProvider._();

/// Riverpod provider for SendMoney form state machine
final class SendMoneyProvider
    extends $NotifierProvider<SendMoney, SendMoneyFormState> {
  /// Riverpod provider for SendMoney form state machine
  SendMoneyProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sendMoneyProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sendMoneyHash();

  @$internal
  @override
  SendMoney create() => SendMoney();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SendMoneyFormState value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SendMoneyFormState>(value),
    );
  }
}

String _$sendMoneyHash() => r'30c89bb89cd01f86eccd68b69dacc904a505854d';

/// Riverpod provider for SendMoney form state machine

abstract class _$SendMoney extends $Notifier<SendMoneyFormState> {
  SendMoneyFormState build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<SendMoneyFormState, SendMoneyFormState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<SendMoneyFormState, SendMoneyFormState>,
              SendMoneyFormState,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
