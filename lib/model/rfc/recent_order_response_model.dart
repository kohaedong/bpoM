/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/recent_order_response_model.dart
 * Created Date: 2022-09-05 10:18:49
 * Last Modified: 2022-09-05 10:39:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:json_annotation/json_annotation.dart';
import 'package:medsalesportal/model/rfc/es_return_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_head_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_item_model.dart';
import 'package:medsalesportal/model/rfc/recent_order_t_text_model.dart';

part 'recent_order_response_model.g.dart';

@JsonSerializable(explicitToJson: true)
class RecentOrderResponseModel {
  @JsonKey(name: 'ES_RETURN')
  EsReturnModel? esReturn;
  @JsonKey(name: 'T_HEAD')
  List<RecentOrderHeadModel>? tHead;
  @JsonKey(name: 'T_ITEM')
  List<RecentOrderTItemModel>? tItem;
  @JsonKey(name: 'T_TEXT')
  List<RecentOrderTTextModel>? tText;
  RecentOrderResponseModel(this.esReturn, this.tHead, this.tItem, this.tText);
  factory RecentOrderResponseModel.fromJson(Object? json) =>
      _$RecentOrderResponseModelFromJson(json as Map<String, dynamic>);
  Map<String, dynamic> toJson() => _$RecentOrderResponseModelToJson(this);
}
