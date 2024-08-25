import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_model.freezed.dart';
part 'record_model.g.dart';

@freezed
abstract class RecordModel with _$RecordModel {
  const factory RecordModel({
    @Default(0) int id,
    @Default("") String date,
    @Default("") String day,
    @Default(0) int dialed,
    @Default(0) int connected,
    @Default(0) int callbacks,
    @Default(0) int meetings,
    @Default(0) int conversions,
    @Default(0) int dial_to_connect,
    @Default(0) int dial_to_meet,
    @Default(0) int connect_to_meet,
  }) = _RecordModel;

  factory RecordModel.fromJson(Map<String, dynamic> json) =>
      _$RecordModelFromJson(json);
}
