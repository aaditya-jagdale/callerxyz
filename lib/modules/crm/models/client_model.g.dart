// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientModelImpl _$$ClientModelImplFromJson(Map<String, dynamic> json) =>
    _$ClientModelImpl(
      name: json['name'] as String? ?? "",
      position: json['position'] as String? ?? "",
      company: json['company'] as String? ?? "",
      notes: json['notes'] as String? ?? "",
      status: json['status'] as String? ?? "",
      reminder: json['reminder'] as String? ?? "",
      recording: json['recording'] as String? ?? "",
      document: json['document'] as String? ?? "",
    );

Map<String, dynamic> _$$ClientModelImplToJson(_$ClientModelImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'position': instance.position,
      'company': instance.company,
      'notes': instance.notes,
      'status': instance.status,
      'reminder': instance.reminder,
      'recording': instance.recording,
      'document': instance.document,
    };
