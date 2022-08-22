/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-08-22 15:35:53
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
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/salse_activity_location_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

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
      coordinateResponseModel =
          SalseActivityCoordinateResponseModel.fromJson(result.body['data']);
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
      return ResultModel(lat != null && lon != null,
          data: {'lat': lat, 'lon': lon});
    }
    return ResultModel(false);
  }

  Future<double> _getTable260TotalDistance() async {
    var dist = 0.0;
    if (editDayModel!.table260!.isNotEmpty) {
      editDayModel!.table260!.forEach((item) {
        dist = item.dist! + dist;
      });
    }
    return dist;
  }

  Future<ResultModel> startOrStopActivity() async {
    isLoadData = true;
    notifyListeners();
    if (selectedAddress != null) {
      await getAddressLatLon(selectedAddress!);
    } else {
      pr('???');
      lat = lon = '0.00';
    }
    assert(lat != null && lon != null);
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    var t250Base64 = '';
    var temp = <Map<String, dynamic>>[];
    var t250 = SalesActivityDayTable250();
    var t260 = SalesActivityDayTable260();

    var time = DateUtil.getTimeNow();
    if (activityStatus == ActivityStatus.STARTED) {
      final totalDistance = await _getTable260TotalDistance();
      // 영업활동 시작 하였으면 >>>  영업활동 종료
      t250 = SalesActivityDayTable250.fromJson(
          editDayModel!.table250!.first.toJson());
      t250.totDist = totalDistance; // 총 거리 계산.
      t250.umode = 'U';
      t250.fcallType = 'M';
      t250.faddcat = locationType;
      t250.fxLatitude = double.parse(lat!.trim());
      t250.fylongitude = double.parse(lon!.trim());
      t250.ftime = DateUtil.getTimeNow();
      t250.fzaddr = selectedAddress;
    } else {
      // 영업활동 시작 하지 않았으면. >>> 영업활동 시작. table 신규 추가.
      t250.adate =
          FormatUtil.removeDash(DateUtil.getDateStr('', dt: DateTime.now()));
      t250.saddcat = locationType;
      t250.szaddr = selectedAddress!;
      t250.sxLatitude = double.parse(lat!.trim());
      t250.syLongitude = double.parse(lon!.trim());
      t250.stime = time;
      t250.scallType = 'M';
      t250.umode = 'I';
      t250.fxLatitude = double.parse('0.00');
      t250.fylongitude = double.parse('0.00');
    }
    temp.addAll([t250.toJson()]);
    t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    temp.clear();
    temp.addAll([t260.toJson()]);
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": "",
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
      pr(editDayModel?.toJson());
      pr(editDayModel?.table250!.first.toJson());
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
