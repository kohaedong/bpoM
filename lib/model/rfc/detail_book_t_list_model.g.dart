/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/rfc/detail_book_t_list_model.g.dart
 * Created Date: 2022-07-28 12:30:24
 * Last Modified: 2022-08-01 11:02:24
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detail_book_t_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetailBookTListModel _$DetailBookTListModelFromJson(
        Map<String, dynamic> json) =>
    DetailBookTListModel(
      json['AEDAT'] as String?,
      json['AENAM'] as String?,
      json['AEWID'] as String?,
      json['AEZET'] as String?,
      json['ERDAT'] as String?,
      json['ERNAM'] as String?,
      json['FILEID'] as String?,
      json['ERWID'] as String?,
      json['ERZET'] as String?,
      json['FNAME'] as String?,
      json['ICLS'] as String?,
      json['ICLSNM'] as String?,
      json['ITEM'] as String?,
      json['ITEMNM'] as String?,
      json['LVORM'] as String?,
    );

Map<String, dynamic> _$DetailBookTListModelToJson(
        DetailBookTListModel instance) =>
    <String, dynamic>{
      'ICLS': instance.icls,
      'ITEM': instance.item,
      'ICLSNM': instance.iclsnm,
      'ITEMNM': instance.itemnm,
      'FNAME': instance.fname,
      'FILEID': instance.fileid,
      'LVORM': instance.lvorm,
      'ERDAT': instance.erdat,
      'ERZET': instance.erzet,
      'ERNAM': instance.ernam,
      'ERWID': instance.erwid,
      'AEDAT': instance.aedat,
      'AEZET': instance.aezet,
      'AENAM': instance.aenam,
      'AEWID': instance.aewid,
    };
