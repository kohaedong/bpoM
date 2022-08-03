/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_file_key_response_model.dart
 * Created Date: 2022-08-03 15:14:50
 * Last Modified: 2022-08-03 15:17:28
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/detail_book_attach_info_model.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
part 'detail_book_file_key_response_model.g.dart';

@JsonSerializable()
class DetailBookFileKeyResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturnModel;
  @JsonKey(name: 'ATTACH_INFO')
  DetailBookAttachInfoModel? attachInfo;

  DetailBookFileKeyResponseModel(this.esReturnModel, this.attachInfo);
  factory DetailBookFileKeyResponseModel.fromJson(Object? json) =>
      _$DetailBookFileKeyResponseModelFromJson(json as Map<String, dynamic>);

  Map<String, dynamic> toJson() => _$DetailBookFileKeyResponseModelToJson(this);
}
