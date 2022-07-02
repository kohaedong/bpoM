import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/commonCode/t_code_model.dart';
import 'package:medsalesportal/model/commonCode/t_values_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'common_code_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class CommonCodeResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_CODE')
  List<TCodeModel>? tCodeModel;
  @JsonKey(name: 'T_VALUES')
  List<TValuesModel>? tValuesModel;

  CommonCodeResponseModel(this.esReturn, this.tCodeModel, this.tValuesModel);
  factory CommonCodeResponseModel.fromJson(Object? json) =>
      _$CommonCodeResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CommonCodeResponseModelToJson(this);
}
