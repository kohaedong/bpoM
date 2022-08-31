/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/menu_provider.dart
 * Created Date: 2022-08-04 23:17:24
 * Last Modified: 2022-08-31 14:43:30
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_361.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_response_model.dart';

// ----------------- discription ----------------------
//     ______________________
//    |                      | --->>> 일별  provider.
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |                      |
//    |           최종활동삭제  |
//    |           영업활동추가  |--->>> 영업활동 시작 or 엉업활동 추가 누를때  location 선택 popup으로  editModel 전달 (from this provider)
//    |           영업활동시작  |       // 전달 목적 :  영업활동 위치 선택후 바로 table 저장 작업 있기 때문이다. table저장에 성공하면 영업활동 등록 화면으로 간다.
//    |                      |                    table 내용이 변경되면 isNeedUpdate = true ; (부모창에서 이 값에 따라 update 여부 판단 한다.)
//    |           (추가/닫기)  | --->>> 추가눌러 popup 열때 model 전달 (from 일별provider).
//    | _____________________| --->>> 닫기눌러 popup 닫힐 때 result로(isNeedUpdate) 부모창에 update여부를 알려준다. update가 필요하면 부모창에서 최신 일별데이터를 가져온다.

class ActivityMenuProvider extends ChangeNotifier {
  SalesActivityDayResponseModel? editModel;
  SalseActivityLocationResponseModel? officeAddressResponseModel;
  final _api = ApiService();
  bool isNeedUpdate = false;
  ActivityStatus? activityStatus;
  bool isLoadData = false;

  void setActivityStatus(ActivityStatus? status) {
    activityStatus = status;
    notifyListeners();
  }

  void setIsNeedUpdate(bool val) {
    isNeedUpdate = val;
    try {
      notifyListeners();
    } catch (e) {
      pr(e);
    }
  }

  Future<void> initData(SalesActivityDayResponseModel fromParentWindowModel,
      ActivityStatus? status,
      {SalseActivityLocationResponseModel? officeAddress,
      bool? isMounted}) async {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentWindowModel.toJson());
    if (officeAddress != null) {
      officeAddressResponseModel = officeAddress;
    }
    pr('??? status $status');
    activityStatus = status;
    if (isMounted != null && isMounted) {
      notifyListeners();
    }
  }

  Future<ResultModel> deletLastActivity() async {
    isLoadData = true;
    notifyListeners();
    assert(editModel!.table260!.isNotEmpty);
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    var t250Base64 = '';
    var t260Base64 = '';
    var t280Base64 = '';
    var t361Base64 = '';
    var temp = <Map<String, dynamic>>[];
    var t250 =
        SalesActivityDayTable250.fromJson(editModel!.table250!.single.toJson());
    var t260List = <SalesActivityDayTable260>[];
    var t280List = <SalesActivityDayTable280>[];
    var t361List = <SalesActivityDayTable361>[];
    temp.addAll([t250.toJson()]);
    t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);

    editModel!.table260!.forEach((tableItem) {
      t260List.add(SalesActivityDayTable260.fromJson(tableItem.toJson()));
    });

    var deleteEntity = t260List.last;
    // deleteEntity.mandt = '100';
    // deleteEntity.bzactno = editModel!.table250!.first.bzactno;
    deleteEntity.umode = 'D';
    temp.clear();
    temp.addAll([...t260List.map((table) => table.toJson())]);

    if (t260List.isNotEmpty) {
      t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    editModel!.table280!.forEach((table) {
      if (table.bzactno == deleteEntity.bzactno &&
          table.seqno == deleteEntity.seqno) {
        table.umode = 'D';
        pr('deleted');
      }
      t280List.add(SalesActivityDayTable280.fromJson(table.toJson()));
    });
    temp.clear();
    temp.addAll([...t280List.map((table) => table.toJson())]);
    if (t280List.isNotEmpty) {
      t280Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    editModel!.table361!.forEach((table) {
      if (table.bzactno == deleteEntity.bzactno &&
          table.zkmno == deleteEntity.zkmno &&
          table.zskunnr == deleteEntity.zskunnr) {
        table.umode = 'D';
        pr('deleted2');
      }
      t361List.add(SalesActivityDayTable361.fromJson(table.toJson()));
    });
    temp.clear();
    temp.addAll([...t361List.map((table) => table.toJson())]);
    if (t361List.isNotEmpty) {
      t361Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
        "T_ZLTSP0280S": t280Base64,
        "T_ZLTSP0361S": t361Base64,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false, errorMassage: result.errorMessage);
    }
    if (result != null && result.statusCode == 200) {
      var beforeLength = editModel?.table260?.length;
      editModel = SalesActivityDayResponseModel.fromJson(result.body['data']);
      pr('delete successful ????${beforeLength != editModel!.table260!.length}');
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false, errorMassage: result!.errorMessage);
  }
}
