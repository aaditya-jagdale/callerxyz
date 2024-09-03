// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'client_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) {
  return _ClientModel.fromJson(json);
}

/// @nodoc
mixin _$ClientModel {
  String get name => throw _privateConstructorUsedError;
  String get position => throw _privateConstructorUsedError;
  String get company => throw _privateConstructorUsedError;
  String get notes => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String get reminder => throw _privateConstructorUsedError;
  String get recording => throw _privateConstructorUsedError;
  String get document => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ClientModelCopyWith<ClientModel> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ClientModelCopyWith<$Res> {
  factory $ClientModelCopyWith(
          ClientModel value, $Res Function(ClientModel) then) =
      _$ClientModelCopyWithImpl<$Res, ClientModel>;
  @useResult
  $Res call(
      {String name,
      String position,
      String company,
      String notes,
      String status,
      String reminder,
      String recording,
      String document});
}

/// @nodoc
class _$ClientModelCopyWithImpl<$Res, $Val extends ClientModel>
    implements $ClientModelCopyWith<$Res> {
  _$ClientModelCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? company = null,
    Object? notes = null,
    Object? status = null,
    Object? reminder = null,
    Object? recording = null,
    Object? document = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reminder: null == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as String,
      recording: null == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as String,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ClientModelImplCopyWith<$Res>
    implements $ClientModelCopyWith<$Res> {
  factory _$$ClientModelImplCopyWith(
          _$ClientModelImpl value, $Res Function(_$ClientModelImpl) then) =
      __$$ClientModelImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String position,
      String company,
      String notes,
      String status,
      String reminder,
      String recording,
      String document});
}

/// @nodoc
class __$$ClientModelImplCopyWithImpl<$Res>
    extends _$ClientModelCopyWithImpl<$Res, _$ClientModelImpl>
    implements _$$ClientModelImplCopyWith<$Res> {
  __$$ClientModelImplCopyWithImpl(
      _$ClientModelImpl _value, $Res Function(_$ClientModelImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? position = null,
    Object? company = null,
    Object? notes = null,
    Object? status = null,
    Object? reminder = null,
    Object? recording = null,
    Object? document = null,
  }) {
    return _then(_$ClientModelImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      position: null == position
          ? _value.position
          : position // ignore: cast_nullable_to_non_nullable
              as String,
      company: null == company
          ? _value.company
          : company // ignore: cast_nullable_to_non_nullable
              as String,
      notes: null == notes
          ? _value.notes
          : notes // ignore: cast_nullable_to_non_nullable
              as String,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as String,
      reminder: null == reminder
          ? _value.reminder
          : reminder // ignore: cast_nullable_to_non_nullable
              as String,
      recording: null == recording
          ? _value.recording
          : recording // ignore: cast_nullable_to_non_nullable
              as String,
      document: null == document
          ? _value.document
          : document // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ClientModelImpl implements _ClientModel {
  const _$ClientModelImpl(
      {this.name = "",
      this.position = "",
      this.company = "",
      this.notes = "",
      this.status = "",
      this.reminder = "",
      this.recording = "",
      this.document = ""});

  factory _$ClientModelImpl.fromJson(Map<String, dynamic> json) =>
      _$$ClientModelImplFromJson(json);

  @override
  @JsonKey()
  final String name;
  @override
  @JsonKey()
  final String position;
  @override
  @JsonKey()
  final String company;
  @override
  @JsonKey()
  final String notes;
  @override
  @JsonKey()
  final String status;
  @override
  @JsonKey()
  final String reminder;
  @override
  @JsonKey()
  final String recording;
  @override
  @JsonKey()
  final String document;

  @override
  String toString() {
    return 'ClientModel(name: $name, position: $position, company: $company, notes: $notes, status: $status, reminder: $reminder, recording: $recording, document: $document)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ClientModelImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.position, position) ||
                other.position == position) &&
            (identical(other.company, company) || other.company == company) &&
            (identical(other.notes, notes) || other.notes == notes) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.reminder, reminder) ||
                other.reminder == reminder) &&
            (identical(other.recording, recording) ||
                other.recording == recording) &&
            (identical(other.document, document) ||
                other.document == document));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, name, position, company, notes,
      status, reminder, recording, document);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ClientModelImplCopyWith<_$ClientModelImpl> get copyWith =>
      __$$ClientModelImplCopyWithImpl<_$ClientModelImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ClientModelImplToJson(
      this,
    );
  }
}

abstract class _ClientModel implements ClientModel {
  const factory _ClientModel(
      {final String name,
      final String position,
      final String company,
      final String notes,
      final String status,
      final String reminder,
      final String recording,
      final String document}) = _$ClientModelImpl;

  factory _ClientModel.fromJson(Map<String, dynamic> json) =
      _$ClientModelImpl.fromJson;

  @override
  String get name;
  @override
  String get position;
  @override
  String get company;
  @override
  String get notes;
  @override
  String get status;
  @override
  String get reminder;
  @override
  String get recording;
  @override
  String get document;
  @override
  @JsonKey(ignore: true)
  _$$ClientModelImplCopyWith<_$ClientModelImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
