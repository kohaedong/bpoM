/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-13 14:24:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/util/date_util.dart';
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
    //! 영업활동이 없으면 table 하나 만들고 base64로 보냄. 있으면 그데로base64로 변경후 보냄.
    //! 처음 table 만들떄  UMODE = I ; 아니면 U;
    var t260Base64 = '';
    List<Map<String, dynamic>> temp = [];

    if (editDayModel!.table250!.isEmpty) {
      var t250 = SalesActivityDayTable250();
      t250.umode = 'I';
      t250.sxLatitude = double.parse(lat!.trim());
      t250.sxLongitude = double.parse(lon!.trim());
      t250.stime = DateUtil.getTimeNow();
      t250.scallType = 'M';
      t250.szaddr = selectedAddress;
      pr(t250.toJson());
    } else {}

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
      editDayModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);
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
