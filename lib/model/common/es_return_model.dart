import 'package:json_annotation/json_annotation.dart';
part 'es_return_model.g.dart';

@JsonSerializable()
class EsReturnModel {
  @JsonKey(name: 'ARBGB')
  String? arbgb;
  @JsonKey(name: 'MSGNR')
  String? msgnr;
  @JsonKey(name: 'MTYPE')
  String? mtype;
  @JsonKey(name: 'MESSAGE')
  String? message;
  EsReturnModel(this.arbgb, this.msgnr, this.mtype, this.message);
  factory EsReturnModel.fromJson(Object? json) =>
      _$EsReturnModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$EsReturnModelToJson(this);
}
