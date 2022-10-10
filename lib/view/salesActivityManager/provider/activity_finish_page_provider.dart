/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/activit_finish_page_provider.dart
 * Created Date: 2022-10-11 06:15:51
 * Last Modified: 2022-10-11 06:45:19
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_item_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_361.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/view/salesActivityManager/provider/add_activity_page_provider.dart';

class ActivityFinishPageProvider extends ChangeNotifier {
  SalesActivityDayTable260? t260;
  SalesActivityDayTable280? t280;
  SalesActivityDayTable361? t361;
  SalesActivityDayResponseModel? dayResponseModel;
  List<AddActivitySuggetionItemModel> suggestedItemList = [];
  bool isHasSugessionItem = false;
  bool isWithTeamLeader = false;
  String resultDescription = '';
  String review = '';
  String leaderAdvice = '';

  Future<ResultModel> init(SalesActivityDayResponseModel dayModel,
      SalesActivityDayTable260 t260Model) async {
    try {
      dayResponseModel =
          SalesActivityDayResponseModel.fromJson(dayModel.toJson());
      t260 = SalesActivityDayTable260.fromJson(t260Model.toJson());
      review = t260!.comntM ?? '';
      resultDescription = t260!.rslt ?? '';
      leaderAdvice = t260!.comnt ?? '';
      ;
      isWithTeamLeader =
          (t260!.accompany == 'D001' || t260!.accompany == 'E002');
      isHasSugessionItem = dayModel.table280!.isNotEmpty &&
          dayModel.table280!
              .where((table) => table.seqno == t260!.seqno)
              .isNotEmpty;
      if (isWithTeamLeader) {
        t361 = dayModel.table361!
            .where((table) => table.seqno == t260!.seqno)
            .single;
      }
      if (isHasSugessionItem) {
        t280 = dayModel.table280!
            .where((table) => table.seqno == t260!.seqno)
            .single;
        List.generate(3, (index) async {
          switch (index) {
            case 0:
              if (t280!.matnr1!.isNotEmpty) {
                var model = AddActivitySuggetionItemModel();
                model.matnr = t280!.matnr1;
                model.maktx = t280!.maktx1;
                model.matkl = t280!.zmatkl1;
                model.isChecked = t280!.xsampl1 == 'X';
                suggestedItemList.add(model);
              } else {
                suggestedItemList.add(AddActivitySuggetionItemModel());
              }
              break;
            case 1:
              if (t280!.matnr2!.isNotEmpty) {
                var model = AddActivitySuggetionItemModel();
                model.matnr = t280!.matnr2;
                model.maktx = t280!.maktx2;
                model.matkl = t280!.zmatkl2;
                model.isChecked = t280!.xsampl2 == 'X';
                suggestedItemList.add(model);
              } else {
                suggestedItemList.add(AddActivitySuggetionItemModel());
              }
              break;
            case 2:
              if (t280!.matnr3!.isNotEmpty) {
                var model = AddActivitySuggetionItemModel();
                model.matnr = t280!.matnr3;
                model.maktx = t280!.maktx3;
                model.matkl = t280!.zmatkl3;
                model.isChecked = t280!.xsampl3 == 'X';
                suggestedItemList.add(model);
              } else {
                suggestedItemList.add(AddActivitySuggetionItemModel());
              }
              break;
          }
        });
      }
      final activityProvider = AddActivityPageProvider();
      await Future.forEach(suggestedItemList, (item) async {
        item as AddActivitySuggetionItemModel;
        if (item.matnr != null &&
            item.matnr!.isNotEmpty &&
            item.maktx!.isEmpty) {
          // 제품명 null 체크.
          item.maktx = await activityProvider
              .searchSuggetionItem(item.matnr!)
              .then((model) => model != null ? model.maktx : '');
        }
      }).whenComplete(() => activityProvider.dispose());
    } catch (e) {
      pr(e);
    }
    return ResultModel(true);
  }
}
