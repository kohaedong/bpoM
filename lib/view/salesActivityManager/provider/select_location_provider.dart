/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-14 20:48:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_270.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_290.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_291.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_300.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_301.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_310.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_320.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_321.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_330.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_340.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_350.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_430.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';

// ---------------  description  --------------------
// 1. [ActivityMenuProvider]에서  model 가져와 editDayModel에 저장한다.
// 2. 영업활동 시작시 250table 신규저장후 result를  editDayModel에 저장한다.(update)
// 3. 영업활동 등록페이지로 이동시 editDayModel을 전달한다.
// 4. 영업활동 등록페이지에서 신규 260table 만들때 editDayModel에 있는 250table 활용해 필요한 데이터 가져온다.
// 5. 영업활동 페이지가 닫힐때 ::
//      - 영업활동 시작 했을 경우: 영업활동이 시작 하였음으로 신규 영업활동 추가 하던 안하던 부모창에서는 업데이트 한다.
//      - 영업활동 시작 안했을 경우: 부모창 업데이트 안함.
//      - 마지막 영업활동 삭제 했을 경우: 부모창에서 최신데이터 반영한다.
class SelectLocationProvider extends ChangeNotifier {
  SalseActivityCoordinateResponseModel? coordinateResponseModel;
  SalesActivityDayResponseModel? editDayModel;
  List<SalseActivityLocationModel>? locationList;
  ActivityStatus? activityStatus;
  final _api = ApiService();
  double height = 200;
  int selectedIndex = 0;
  bool isShowSelector = false;
  bool isLoadData = false;
  String? selectedAddress;
  String? lat;
  String? lon;
  String get homeAddress =>
      locationList!.where((model) => model.addcat == 'H').single.zadd1!;
  String get officeAddress =>
      locationList!.where((model) => model.addcat == 'O').single.zadd1!;
  String get locationType => locationList!
      .where((model) => model.zadd1 == selectedAddress)
      .first
      .addcat!;
  void initData(
      SalesActivityDayResponseModel fromParentModel,
      List<SalseActivityLocationModel> fromParentLocationList,
      ActivityStatus status) {
    editDayModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    locationList = fromParentLocationList;
    activityStatus = status;
    isShowSelector =
        locationList!.where((model) => model.addcat == 'O').toList().length > 1;
  }

  Future<List<String>> getAddress(
      List<SalseActivityLocationModel> locationList) async {
    var temp = <String>[];
    locationList.forEach((model) {
      if (model.addcat == 'O') {
        temp.add(model.zadd1!);
      }
    });
    return temp;
  }

  Future<ResultModel> getAddressLatLon(String addr) async {
    _api.init(RequestType.GET_LAT_AND_LON);
    Map<String, dynamic> _body = {"departure": addr};
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      pr(result.body);
      coordinateResponseModel =
          SalseActivityCoordinateResponseModel.fromJson(result.body['data']);
      pr(coordinateResponseModel?.toJson());
      var model = coordinateResponseModel?.result;
      var newLatLonNotNull = model != null &&
          model.newLat != null &&
          model.newLat!.isNotEmpty &&
          model.newLon != null &&
          model.newLon!.isNotEmpty;

      var latLonNotNull = model != null &&
          model.lat != null &&
          model.lat!.isNotEmpty &&
          model.lon != null &&
          model.lon!.isNotEmpty;

      var tempLat = latLonNotNull ? model.lat : null;
      var tempLon = latLonNotNull ? model.lon : null;

      var newLat = newLatLonNotNull ? model.newLat : null;
      var newLon = newLatLonNotNull ? model.newLon : null;

      lat = tempLat ?? newLat ?? null;
      lon = tempLon ?? newLon ?? null;
      return ResultModel(lat != null && lon != null);
    }
    return ResultModel(false);
  }

  Future<ResultModel> saveBaseTable() async {
    isLoadData = true;
    notifyListeners();
    if (selectedAddress != null) {
      await getAddressLatLon(selectedAddress!);
    } else {
      lat = lon = '0.00';
    }
    assert(lat != null && lon != null);
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    var t250Base64 = '';
    var t260Base64 = '';
    var t270Base64 = '';
    var t280Base64 = '';
    var t290Base64 = '';
    var t291Base64 = '';
    var t300Base64 = '';
    var t301Base64 = '';
    var t310Base64 = '';
    var t320Base64 = '';
    var t321Base64 = '';
    var t330Base64 = '';
    var t340Base64 = '';
    var t350Base64 = '';
    var t430Base64 = '';
    var temp = <Map<String, dynamic>>[];
    var t250 = SalesActivityDayTable250();
    var t260 = SalesActivityDayTable260();
    var t270 = SalesActivityDayTable270();
    var t280 = SalesActivityDayTable280();
    var t290 = SalesActivityDayTable290();
    var t291 = SalesActivityDayTable291();
    var t300 = SalesActivityDayTable300();
    var t301 = SalesActivityDayTable301();
    var t310 = SalesActivityDayTable310();
    var t320 = SalesActivityDayTable320();
    var t321 = SalesActivityDayTable321();
    var t330 = SalesActivityDayTable330();
    var t340 = SalesActivityDayTable340();
    var t350 = SalesActivityDayTable350();
    var t430 = SalesActivityDayTable430();
    var date = t250.adate =
        FormatUtil.removeDash(DateUtil.getDateStr('', dt: DateTime.now()));
    var time = DateUtil.getTimeNow();

    var esLogin = CacheService.getEsLogin();

    if (activityStatus == ActivityStatus.STARTED) {
      // 영업활동 시작 하였으면 >>>  영업활동 종료
      t250.umode = 'U';
      t250.fcallType = 'M';
      t250.adate = date;
      t250.faddcat = locationType;
      t250.fxLatitude = double.parse('0.00');
      t250.fylongitude = double.parse('0.00');
      t250.ftime = DateUtil.getTimeNow();
      t250.fzaddr = selectedAddress;
    } else {
      // 영업활동 시작 하지 않았으면. >>> 영업활동 시작. table 신규 추가.
      t250.umode = 'I';
      t250.scallType = 'M';
      t250.adate = date;
      t250.aedat = date;
      t250.aezet = time;
      t250.aenam = esLogin!.ename;

      t250.erdat = date;
      t250.ernam = esLogin.ename;
      t250.erwid = esLogin.logid!.toUpperCase();
      t250.saddcat = locationType;
      t250.sxLatitude = double.parse(lat!.trim());
      t250.syLongitude = double.parse(lon!.trim());
      t250.stime = time;
      t250.szaddr = selectedAddress;

      // t260.umode = 'I';
      // t260.seqno = '0001';
      // t260.callType = 'M';
      // t260.isGps = 'X';
      // t260.xLatitude = double.parse('0.00');
      // t260.yLongitude = double.parse('0.00');
      // t260.erdat = t250.erdat;
    }
    temp.addAll([t250.toJson()]);
    t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t260.toJson()]);
    t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t270.toJson()]);
    t270Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t280.toJson()]);
    t280Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t290.toJson()]);
    t290Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t291.toJson()]);
    t291Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t300.toJson()]);
    t300Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t301.toJson()]);
    t301Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t310.toJson()]);
    t310Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t320.toJson()]);
    t320Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t321.toJson()]);
    t321Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t330.toJson()]);
    t330Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t340.toJson()]);
    t340Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t350.toJson()]);
    t350Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t430.toJson()]);
    t430Base64 = await EncodingUtils.base64ConvertForListMap(temp);

    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "I",
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
        "T_ZLTSP0270S": t270Base64,
        "T_ZLTSP0280S": t280Base64,
        "T_ZLTSP0290S": t290Base64,
        "T_ZLTSP0291S": t291Base64,
        "T_ZLTSP0300S": t300Base64,
        "T_ZLTSP0301S": t301Base64,
        "T_ZLTSP0310S": t310Base64,
        "T_ZLTSP0320S": t320Base64,
        "T_ZLTSP0321S": t321Base64,
        "T_ZLTSP0330S": t330Base64,
        "T_ZLTSP0340S": t340Base64,
        "T_ZLTSP0350S": t350Base64,
        "T_ZLTSP0430S": t430Base64,
        "IV_ADATE":
            FormatUtil.removeDash(DateUtil.getDateStr('', dt: DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      editDayModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);
      pr('result::: ${editDayModel?.toJson()}');
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false, errorMassage: result?.errorMessage);
  }

  void setHeight(double val) {
    height = val;
    notifyListeners();
  }

  void setSelectedAddress(String? str) {
    selectedAddress = str;
    notifyListeners();
  }

  void setSelectedIndex(int val) {
    selectedIndex = val;
    notifyListeners();
  }

  void setIsShowSelector(bool val) {
    isShowSelector = val;
    notifyListeners();
  }
}
