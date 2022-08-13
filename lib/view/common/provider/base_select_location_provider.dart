/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-13 10:47:47
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class BaseSelectLocationProvider extends ChangeNotifier {
  SalseActivityCoordinateResponseModel? coordinateResponseModel;
  SalesActivityDayResponseModel? editDayModel;
  List<SalseActivityLocationModel>? locationList;
  final _api = ApiService();
  double height = 200;
  int selectedIndex = 0;
  bool isShowSelector = false;
  bool isNeedUpdate = false;
  bool isLoadData = false;
  String? selectedAddress;
  String? lat;
  String? lon;
  String get homeAddress =>
      locationList!.where((model) => model.addcat == 'H').single.zadd1!;
  String get officeAddress =>
      locationList!.where((model) => model.addcat == 'O').single.zadd1!;

  void initData(SalesActivityDayResponseModel fromParentModel,
      List<SalseActivityLocationModel> fromParentLocationList) {
    editDayModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    locationList = fromParentLocationList;
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
      var tempLat = model != null && model.lat != null && model.lon != null
          ? model.lat
          : null;
      var newLat = model != null && model.newLat != null && model.newLon != null
          ? model.newLat
          : null;
      var tempLon = model != null && model.lat != null && model.lon != null
          ? model.lon
          : null;
      var newLon = model != null && model.newLon != null && model.newLon != null
          ? model.newLon
          : null;
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
    //! 영업활동이 없으면 table 하나 만들고, 있으면 그데로base64로 보냄.
    //! 처음 table 만들떄 UMODE = I ; 아니면 U;
    var t260Base64 = '';
    List<Map<String, dynamic>> temp = [];

    // if (condition) {
    //   temp.addAll([headerTable.toJson()]);
    // }
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
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
      pr(result.body);
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
