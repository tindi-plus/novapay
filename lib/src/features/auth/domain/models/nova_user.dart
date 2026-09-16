import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nova_user.freezed.dart';
part 'nova_user.g.dart';

/// Immutable user model for NovaPay fintech application
/// Generated with Freezed for immutability, JSON serialization, and copyWith support
@freezed
abstract class NovaUser with _$NovaUser{
  const factory NovaUser({
    /// Firebase Authentication UID
    required String uid,

    /// User's email address
    required String email,

    /// Unique 10-digit account number for transactions
    required String accountNumber,

    /// User's first name
    required String firstName,

    /// User's middle name (optional)
    String? middleName,

    /// User's last name
    required String lastName,

    /// Bank Verification Number (11 digits) - Nigerian identifier
    required String bvn,

    /// National Identification Number (11 digits) - Nigerian identifier
    required String nin,

    /// User's phone number
    required String phoneNumber,

    /// Account creation timestamp
    @TimestampConverter() required DateTime createdAt,

    /// Account last update timestamp
    @TimestampConverter() required DateTime updatedAt,

    /// Whether the user's email is verified
    @Default(false) bool isEmailVerified,
  }) = _NovaUser;

  const NovaUser._();

  /// Creates a NovaUser from a JSON object
  factory NovaUser.fromJson(Map<String, dynamic> json) =>
      _$NovaUserFromJson(json);

  /// Creates a NovaUser from a Firestore document snapshot
  factory NovaUser.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    return NovaUser.fromJson({...doc.data() ?? {}, 'uid': doc.id});
  }

  /// Creates a NovaUser from Firestore data map
  factory NovaUser.fromFirestoreMap(Map<String, dynamic> data, String uid) {
    return NovaUser.fromJson({...data, 'uid': uid});
  }

  /// Converts NovaUser to a JSON object suitable for storage
  @override
  Map<String, dynamic> toJson() => _$NovaUserToJson(this as _NovaUser);

  /// Converts NovaUser to a Firestore-compatible map (excludes uid)
  Map<String, dynamic> toFirestoreMap() {
    final json = toJson();
    json.remove('uid');
    return json;
  }

  /// Gets the user's full name
  String getFullName() {
    if (middleName != null && middleName!.isNotEmpty) {
      return '$firstName $middleName $lastName';
    }
    return '$firstName $lastName';
  }

  /// Gets a display name (first name + last initial)
  String getDisplayName() {
    final lastInitial = lastName.isNotEmpty ? lastName[0].toUpperCase() : '';
    return '$firstName $lastInitial.';
  }

  @override
  String toString() =>
      'NovaUser(uid: $uid, email: $email, accountNumber: $accountNumber, '
      'fullName: ${getFullName()}, accountStatus: active)';
}

/// Custom JSON converter for DateTime to handle Firestore Timestamp serialization
class TimestampConverter implements JsonConverter<DateTime, dynamic> {
  const TimestampConverter();

  @override
  DateTime fromJson(dynamic json) {
    if (json is int) {
      // Milliseconds since epoch
      return DateTime.fromMillisecondsSinceEpoch(json);
    } else if (json is String) {
      // ISO 8601 string
      return DateTime.parse(json);
    } else if (json is double) {
      // Seconds since epoch (Firestore Timestamp)
      return DateTime.fromMillisecondsSinceEpoch((json * 1000).toInt());
    }
    throw ArgumentError('Invalid DateTime format: $json');
  }

  @override
  dynamic toJson(DateTime value) {
    // Convert to milliseconds since epoch for JSON storage
    return value.millisecondsSinceEpoch;
  }
}
