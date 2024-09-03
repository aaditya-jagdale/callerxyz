import 'package:freezed_annotation/freezed_annotation.dart';

part 'client_model.freezed.dart';
part 'client_model.g.dart';

@freezed
class ClientModel with _$ClientModel {
  const factory ClientModel({
    @Default("") String name,
    @Default("") String position,
    @Default("") String company,
    @Default("") String notes,
    @Default("") String status,
    @Default("") String reminder,
    @Default("") String recording,
    @Default("") String document,
  }) = _ClientModel;

  factory ClientModel.fromJson(Map<String, dynamic> json) => _$ClientModelFromJson(json);
}
