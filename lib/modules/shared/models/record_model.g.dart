// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RecordModelImpl _$$RecordModelImplFromJson(Map<String, dynamic> json) =>
    _$RecordModelImpl(
      id: (json['id'] as num?)?.toInt() ?? 0,
      date: json['date'] as String? ?? "",
      day: json['day'] as String? ?? "",
      dialed: (json['dialed'] as num?)?.toInt() ?? 0,
      connected: (json['connected'] as num?)?.toInt() ?? 0,
      callbacks: (json['callbacks'] as num?)?.toInt() ?? 0,
      meetings: (json['meetings'] as num?)?.toInt() ?? 0,
      conversions: (json['conversions'] as num?)?.toInt() ?? 0,
      dial_to_connect: (json['dial_to_connect'] as num?)?.toInt() ?? 0,
      dial_to_meet: (json['dial_to_meet'] as num?)?.toInt() ?? 0,
      connect_to_meet: (json['connect_to_meet'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$RecordModelImplToJson(_$RecordModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'day': instance.day,
      'dialed': instance.dialed,
      'connected': instance.connected,
      'callbacks': instance.callbacks,
      'meetings': instance.meetings,
      'conversions': instance.conversions,
      'dial_to_connect': instance.dial_to_connect,
      'dial_to_meet': instance.dial_to_meet,
      'connect_to_meet': instance.connect_to_meet,
    };
