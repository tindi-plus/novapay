// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'nova_user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$NovaUser {

/// Firebase Authentication UID
 String get uid;/// User's email address
 String get email;/// Unique 10-digit account number for transactions
 String get accountNumber;/// User's first name
 String get firstName;/// User's middle name (optional)
 String? get middleName;/// User's last name
 String get lastName;/// Bank Verification Number (11 digits) - Nigerian identifier
 String get bvn;/// National Identification Number (11 digits) - Nigerian identifier
 String get nin;/// User's phone number
 String get phoneNumber;/// Account creation timestamp
@TimestampConverter() DateTime get createdAt;/// Account last update timestamp
@TimestampConverter() DateTime get updatedAt;/// Whether the user's email is verified
 bool get isEmailVerified;
/// Create a copy of NovaUser
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NovaUserCopyWith<NovaUser> get copyWith => _$NovaUserCopyWithImpl<NovaUser>(this as NovaUser, _$identity);

  /// Serializes this NovaUser to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NovaUser;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NovaUser&&(identical(other.uid, _this.uid) || other.uid == _this.uid)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.accountNumber, _this.accountNumber) || other.accountNumber == _this.accountNumber)&&(identical(other.firstName, _this.firstName) || other.firstName == _this.firstName)&&(identical(other.middleName, _this.middleName) || other.middleName == _this.middleName)&&(identical(other.lastName, _this.lastName) || other.lastName == _this.lastName)&&(identical(other.bvn, _this.bvn) || other.bvn == _this.bvn)&&(identical(other.nin, _this.nin) || other.nin == _this.nin)&&(identical(other.phoneNumber, _this.phoneNumber) || other.phoneNumber == _this.phoneNumber)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.isEmailVerified, _this.isEmailVerified) || other.isEmailVerified == _this.isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NovaUser;
  return Object.hash(runtimeType,_this.uid,_this.email,_this.accountNumber,_this.firstName,_this.middleName,_this.lastName,_this.bvn,_this.nin,_this.phoneNumber,_this.createdAt,_this.updatedAt,_this.isEmailVerified);
}



}

/// @nodoc
abstract mixin class $NovaUserCopyWith<$Res>  {
  factory $NovaUserCopyWith(NovaUser value, $Res Function(NovaUser) _then) = _$NovaUserCopyWithImpl;
@useResult
$Res call({
 String uid, String email, String accountNumber, String firstName, String? middleName, String lastName, String bvn, String nin, String phoneNumber,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, bool isEmailVerified
});




}
/// @nodoc
class _$NovaUserCopyWithImpl<$Res>
    implements $NovaUserCopyWith<$Res> {
  _$NovaUserCopyWithImpl(this._self, this._then);

  final NovaUser _self;
  final $Res Function(NovaUser) _then;

/// Create a copy of NovaUser
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? uid = null,Object? email = null,Object? accountNumber = null,Object? firstName = null,Object? middleName = freezed,Object? lastName = null,Object? bvn = null,Object? nin = null,Object? phoneNumber = null,Object? createdAt = null,Object? updatedAt = null,Object? isEmailVerified = null,}) {
  return _then(NovaUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,bvn: null == bvn ? _self.bvn : bvn // ignore: cast_nullable_to_non_nullable
as String,nin: null == nin ? _self.nin : nin // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [NovaUser].
extension NovaUserPatterns on NovaUser {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NovaUser value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NovaUser() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NovaUser value)  $default,){
final _that = this;
switch (_that) {
case _NovaUser():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NovaUser value)?  $default,){
final _that = this;
switch (_that) {
case _NovaUser() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String uid,  String email,  String accountNumber,  String firstName,  String? middleName,  String lastName,  String bvn,  String nin,  String phoneNumber, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  bool isEmailVerified)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NovaUser() when $default != null:
return $default(_that.uid,_that.email,_that.accountNumber,_that.firstName,_that.middleName,_that.lastName,_that.bvn,_that.nin,_that.phoneNumber,_that.createdAt,_that.updatedAt,_that.isEmailVerified);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String uid,  String email,  String accountNumber,  String firstName,  String? middleName,  String lastName,  String bvn,  String nin,  String phoneNumber, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  bool isEmailVerified)  $default,) {final _that = this;
switch (_that) {
case _NovaUser():
return $default(_that.uid,_that.email,_that.accountNumber,_that.firstName,_that.middleName,_that.lastName,_that.bvn,_that.nin,_that.phoneNumber,_that.createdAt,_that.updatedAt,_that.isEmailVerified);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String uid,  String email,  String accountNumber,  String firstName,  String? middleName,  String lastName,  String bvn,  String nin,  String phoneNumber, @TimestampConverter()  DateTime createdAt, @TimestampConverter()  DateTime updatedAt,  bool isEmailVerified)?  $default,) {final _that = this;
switch (_that) {
case _NovaUser() when $default != null:
return $default(_that.uid,_that.email,_that.accountNumber,_that.firstName,_that.middleName,_that.lastName,_that.bvn,_that.nin,_that.phoneNumber,_that.createdAt,_that.updatedAt,_that.isEmailVerified);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NovaUser extends NovaUser {
  const _NovaUser({required this.uid, required this.email, required this.accountNumber, required this.firstName, this.middleName, required this.lastName, required this.bvn, required this.nin, required this.phoneNumber, @TimestampConverter() required this.createdAt, @TimestampConverter() required this.updatedAt, this.isEmailVerified = false}): super._();
  factory _NovaUser.fromJson(Map<String, dynamic> json) => _$NovaUserFromJson(json);

/// Firebase Authentication UID
@override final  String uid;
/// User's email address
@override final  String email;
/// Unique 10-digit account number for transactions
@override final  String accountNumber;
/// User's first name
@override final  String firstName;
/// User's middle name (optional)
@override final  String? middleName;
/// User's last name
@override final  String lastName;
/// Bank Verification Number (11 digits) - Nigerian identifier
@override final  String bvn;
/// National Identification Number (11 digits) - Nigerian identifier
@override final  String nin;
/// User's phone number
@override final  String phoneNumber;
/// Account creation timestamp
@override@TimestampConverter() final  DateTime createdAt;
/// Account last update timestamp
@override@TimestampConverter() final  DateTime updatedAt;
/// Whether the user's email is verified
@override@JsonKey() final  bool isEmailVerified;

/// Create a copy of NovaUser
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NovaUserCopyWith<_NovaUser> get copyWith => __$NovaUserCopyWithImpl<_NovaUser>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NovaUserToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NovaUser&&(identical(other.uid, uid) || other.uid == uid)&&(identical(other.email, email) || other.email == email)&&(identical(other.accountNumber, accountNumber) || other.accountNumber == accountNumber)&&(identical(other.firstName, firstName) || other.firstName == firstName)&&(identical(other.middleName, middleName) || other.middleName == middleName)&&(identical(other.lastName, lastName) || other.lastName == lastName)&&(identical(other.bvn, bvn) || other.bvn == bvn)&&(identical(other.nin, nin) || other.nin == nin)&&(identical(other.phoneNumber, phoneNumber) || other.phoneNumber == phoneNumber)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isEmailVerified, isEmailVerified) || other.isEmailVerified == isEmailVerified));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,uid,email,accountNumber,firstName,middleName,lastName,bvn,nin,phoneNumber,createdAt,updatedAt,isEmailVerified);
}



}

/// @nodoc
abstract mixin class _$NovaUserCopyWith<$Res> implements $NovaUserCopyWith<$Res> {
  factory _$NovaUserCopyWith(_NovaUser value, $Res Function(_NovaUser) _then) = __$NovaUserCopyWithImpl;
@override @useResult
$Res call({
 String uid, String email, String accountNumber, String firstName, String? middleName, String lastName, String bvn, String nin, String phoneNumber,@TimestampConverter() DateTime createdAt,@TimestampConverter() DateTime updatedAt, bool isEmailVerified
});




}
/// @nodoc
class __$NovaUserCopyWithImpl<$Res>
    implements _$NovaUserCopyWith<$Res> {
  __$NovaUserCopyWithImpl(this._self, this._then);

  final _NovaUser _self;
  final $Res Function(_NovaUser) _then;

/// Create a copy of NovaUser
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? uid = null,Object? email = null,Object? accountNumber = null,Object? firstName = null,Object? middleName = freezed,Object? lastName = null,Object? bvn = null,Object? nin = null,Object? phoneNumber = null,Object? createdAt = null,Object? updatedAt = null,Object? isEmailVerified = null,}) {
  return _then(_NovaUser(
uid: null == uid ? _self.uid : uid // ignore: cast_nullable_to_non_nullable
as String,email: null == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String,accountNumber: null == accountNumber ? _self.accountNumber : accountNumber // ignore: cast_nullable_to_non_nullable
as String,firstName: null == firstName ? _self.firstName : firstName // ignore: cast_nullable_to_non_nullable
as String,middleName: freezed == middleName ? _self.middleName : middleName // ignore: cast_nullable_to_non_nullable
as String?,lastName: null == lastName ? _self.lastName : lastName // ignore: cast_nullable_to_non_nullable
as String,bvn: null == bvn ? _self.bvn : bvn // ignore: cast_nullable_to_non_nullable
as String,nin: null == nin ? _self.nin : nin // ignore: cast_nullable_to_non_nullable
as String,phoneNumber: null == phoneNumber ? _self.phoneNumber : phoneNumber // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isEmailVerified: null == isEmailVerified ? _self.isEmailVerified : isEmailVerified // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
