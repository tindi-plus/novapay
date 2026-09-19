// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'savings_goal_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SavingsGoalModel {

 String get id; String get userId; String get name; int get targetAmountInKobo; int get currentAmountInKobo; DateTime get targetDate; DateTime get createdAt;
/// Create a copy of SavingsGoalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SavingsGoalModelCopyWith<SavingsGoalModel> get copyWith => _$SavingsGoalModelCopyWithImpl<SavingsGoalModel>(this as SavingsGoalModel, _$identity);

  /// Serializes this SavingsGoalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SavingsGoalModel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SavingsGoalModel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.targetAmountInKobo, _this.targetAmountInKobo) || other.targetAmountInKobo == _this.targetAmountInKobo)&&(identical(other.currentAmountInKobo, _this.currentAmountInKobo) || other.currentAmountInKobo == _this.currentAmountInKobo)&&(identical(other.targetDate, _this.targetDate) || other.targetDate == _this.targetDate)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SavingsGoalModel;
  return Object.hash(runtimeType,_this.id,_this.userId,_this.name,_this.targetAmountInKobo,_this.currentAmountInKobo,_this.targetDate,_this.createdAt);
}

@override
String toString() {
  final _this = this as SavingsGoalModel;
  return 'SavingsGoalModel(id: ${_this.id}, userId: ${_this.userId}, name: ${_this.name}, targetAmountInKobo: ${_this.targetAmountInKobo}, currentAmountInKobo: ${_this.currentAmountInKobo}, targetDate: ${_this.targetDate}, createdAt: ${_this.createdAt})';
}


}

/// @nodoc
abstract mixin class $SavingsGoalModelCopyWith<$Res>  {
  factory $SavingsGoalModelCopyWith(SavingsGoalModel value, $Res Function(SavingsGoalModel) _then) = _$SavingsGoalModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String name, int targetAmountInKobo, int currentAmountInKobo, DateTime targetDate, DateTime createdAt
});




}
/// @nodoc
class _$SavingsGoalModelCopyWithImpl<$Res>
    implements $SavingsGoalModelCopyWith<$Res> {
  _$SavingsGoalModelCopyWithImpl(this._self, this._then);

  final SavingsGoalModel _self;
  final $Res Function(SavingsGoalModel) _then;

/// Create a copy of SavingsGoalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmountInKobo = null,Object? currentAmountInKobo = null,Object? targetDate = null,Object? createdAt = null,}) {
  return _then(SavingsGoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmountInKobo: null == targetAmountInKobo ? _self.targetAmountInKobo : targetAmountInKobo // ignore: cast_nullable_to_non_nullable
as int,currentAmountInKobo: null == currentAmountInKobo ? _self.currentAmountInKobo : currentAmountInKobo // ignore: cast_nullable_to_non_nullable
as int,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [SavingsGoalModel].
extension SavingsGoalModelPatterns on SavingsGoalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SavingsGoalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SavingsGoalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SavingsGoalModel value)  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SavingsGoalModel value)?  $default,){
final _that = this;
switch (_that) {
case _SavingsGoalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int targetAmountInKobo,  int currentAmountInKobo,  DateTime targetDate,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SavingsGoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmountInKobo,_that.currentAmountInKobo,_that.targetDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String name,  int targetAmountInKobo,  int currentAmountInKobo,  DateTime targetDate,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _SavingsGoalModel():
return $default(_that.id,_that.userId,_that.name,_that.targetAmountInKobo,_that.currentAmountInKobo,_that.targetDate,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String name,  int targetAmountInKobo,  int currentAmountInKobo,  DateTime targetDate,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _SavingsGoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.name,_that.targetAmountInKobo,_that.currentAmountInKobo,_that.targetDate,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SavingsGoalModel extends SavingsGoalModel {
  const _SavingsGoalModel({required this.id, required this.userId, required this.name, required this.targetAmountInKobo, required this.currentAmountInKobo, required this.targetDate, required this.createdAt}): super._();
  factory _SavingsGoalModel.fromJson(Map<String, dynamic> json) => _$SavingsGoalModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String name;
@override final  int targetAmountInKobo;
@override final  int currentAmountInKobo;
@override final  DateTime targetDate;
@override final  DateTime createdAt;

/// Create a copy of SavingsGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SavingsGoalModelCopyWith<_SavingsGoalModel> get copyWith => __$SavingsGoalModelCopyWithImpl<_SavingsGoalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SavingsGoalModelToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SavingsGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.name, name) || other.name == name)&&(identical(other.targetAmountInKobo, targetAmountInKobo) || other.targetAmountInKobo == targetAmountInKobo)&&(identical(other.currentAmountInKobo, currentAmountInKobo) || other.currentAmountInKobo == currentAmountInKobo)&&(identical(other.targetDate, targetDate) || other.targetDate == targetDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,userId,name,targetAmountInKobo,currentAmountInKobo,targetDate,createdAt);
}

@override
String toString() {
    return 'SavingsGoalModel(id: $id, userId: $userId, name: $name, targetAmountInKobo: $targetAmountInKobo, currentAmountInKobo: $currentAmountInKobo, targetDate: $targetDate, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$SavingsGoalModelCopyWith<$Res> implements $SavingsGoalModelCopyWith<$Res> {
  factory _$SavingsGoalModelCopyWith(_SavingsGoalModel value, $Res Function(_SavingsGoalModel) _then) = __$SavingsGoalModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String name, int targetAmountInKobo, int currentAmountInKobo, DateTime targetDate, DateTime createdAt
});




}
/// @nodoc
class __$SavingsGoalModelCopyWithImpl<$Res>
    implements _$SavingsGoalModelCopyWith<$Res> {
  __$SavingsGoalModelCopyWithImpl(this._self, this._then);

  final _SavingsGoalModel _self;
  final $Res Function(_SavingsGoalModel) _then;

/// Create a copy of SavingsGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? name = null,Object? targetAmountInKobo = null,Object? currentAmountInKobo = null,Object? targetDate = null,Object? createdAt = null,}) {
  return _then(_SavingsGoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,targetAmountInKobo: null == targetAmountInKobo ? _self.targetAmountInKobo : targetAmountInKobo // ignore: cast_nullable_to_non_nullable
as int,currentAmountInKobo: null == currentAmountInKobo ? _self.currentAmountInKobo : currentAmountInKobo // ignore: cast_nullable_to_non_nullable
as int,targetDate: null == targetDate ? _self.targetDate : targetDate // ignore: cast_nullable_to_non_nullable
as DateTime,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
