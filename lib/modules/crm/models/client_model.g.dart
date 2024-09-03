// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ClientModelImpl _$$ClientModelImplFromJson(Map<String, dynamic> json) =>
    _$ClientModelImpl(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      position: json['position'] as String? ?? "",
      company: json['company'] as String? ?? "",
      notes: json['notes'] as String? ?? "",
      phone_number: json['phone_number'] as String? ?? "",
      status: json['status'] as String? ?? "",
      reminder: json['reminder'] as String? ?? "",
      recording: json['recording'] as String? ?? "",
      document: json['document'] as String? ?? "",
    );

Map<String, dynamic> _$$ClientModelImplToJson(_$ClientModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'position': instance.position,
      'company': instance.company,
      'notes': instance.notes,
      'phone_number': instance.phone_number,
      'status': instance.status,
      'reminder': instance.reminder,
      'recording': instance.recording,
      'document': instance.document,
    };
