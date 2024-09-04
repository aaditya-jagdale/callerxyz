import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class ClientModel with _$ClientModel {
  const factory ClientModel({
    required int id,
    required String name,
    @Default("") String position,
    @Default("") String company,
    @Default("") String notes,
    @Default("") String phone_number,
    @Default(0) int status,
    @Default("") String reminder,
    @Default("") String recording,
    @Default("") String document,
    @Default("") String createdAt,
  }) = _ClientModel;

  factory ClientModel.fromJson(Map<String, dynamic> json) =>
      _$ClientModelFromJson(json);
}
