import 'package:hive/hive.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:bpom/model/commonCode/common_object.dart';
part 't_values_model.g.dart';

@JsonSerializable()
@HiveType(typeId: 2)
class TValuesModel extends CommonCodeObject {
  @HiveField(1)
  @JsonKey(name: 'T_NAME')
  String? tname;
  @HiveField(2)
  @JsonKey(name: 'HELPVALUES')
  String? helpValues;

  TValuesModel({this.tname, this.helpValues});
  factory TValuesModel.fromJson(Object? json) =>
      _$TValuesModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$TValuesModelToJson(this);
}
