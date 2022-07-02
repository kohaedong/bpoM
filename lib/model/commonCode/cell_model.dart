import 'package:json_annotation/json_annotation.dart';
part 'cell_model.g.dart';

@JsonSerializable()
class CellModel {
  String? column1;
  String? column2;
  String? column3;
  CellModel(
      {required this.column1, required this.column2, required this.column3});
  factory CellModel.fromJson(Object? json) =>
      _$CellModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$CellModelToJson(this);
}
