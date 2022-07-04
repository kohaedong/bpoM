// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'et_vkgrp_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EtVkgrpModel _$EtVkgrpModelFromJson(Map<String, dynamic> json) => EtVkgrpModel(
      json['VKGRP'] as String?,
      json['ACHNG'] as String?,
      json['AREAD'] as String?,
      json['VKGRP_NM'] as String?,
    );

Map<String, dynamic> _$EtVkgrpModelToJson(EtVkgrpModel instance) =>
    <String, dynamic>{
      'VKGRP': instance.vkgrp,
      'VKGRP_NM': instance.vkgrpNm,
      'AREAD': instance.aread,
      'ACHNG': instance.achng,
    };
