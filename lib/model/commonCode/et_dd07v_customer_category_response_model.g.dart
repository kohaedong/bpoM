// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_dd07v_customer_category_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtDd07vCustomerCategoryResponseModel
    _$EtDd07vCustomerCategoryResponseModelFromJson(Map<String, dynamic> json) =>
        EtDd07vCustomerCategoryResponseModel(
          (json['ET_DD07V_TAB'] as List<dynamic>?)
              ?.map((e) => TCustomerCustomsModel.fromJson(e as Object))
              .toList(),
        );

Map<String, dynamic> _$EtDd07vCustomerCategoryResponseModelToJson(
        EtDd07vCustomerCategoryResponseModel instance) =>
    <String, dynamic>{
      'ET_DD07V_TAB': instance.modelList?.map((e) => e.toJson()).toList(),
    };
