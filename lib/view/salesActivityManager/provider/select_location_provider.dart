/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/select_location_provider.dart
 * Created Date: 2022-08-07 20:01:39
 * Last Modified: 2022-11-05 22:49:44
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/styles/app_size.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/globalProvider/activity_state_provder.dart';
import 'package:medsalesportal/model/rfc/add_activity_distance_model.dart';
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
  AddActivityDistanceModel? distanceModel;
  SalesActivityDayResponseModel? editDayModel;
  List<SalseActivityLocationModel>? locationList;
  ActivityStatus? activityStatus;
  final _api = ApiService();
  double height = AppSize.addressPopupHeight;
  int selectedIndex = 0;
  bool isShowSelector = false;
  bool isLoadData = false;
  String? selectedAddress;
  String? lat;
  String? lon;

  bool get isHomeAddressEmpty =>
      locationList!.where((model) => model.addcat == 'H').isEmpty;
  bool get isOfficeAddressEmpty =>
      locationList!.where((model) => model.addcat != 'H').isEmpty;
  String get homeAddress {
    var list = locationList!.where((model) => model.addcat == 'H').toList();
    return list.isNotEmpty ? list.single.zadd1! : '';
  }

  List<SalseActivityLocationModel> get officeAddres =>
      locationList!.where((model) => model.addcat != 'H').toList();
  String get locationType => selectedIndex == 0
      ? 'H'
      : selectedIndex == 1
          ? 'O'
          : 'C';

  void initData(
      SalesActivityDayResponseModel fromParentModel,
      List<SalseActivityLocationModel> fromParentLocationList,
      ActivityStatus status) {
    editDayModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    locationList = fromParentLocationList;
    if (!isHomeAddressEmpty) {
      selectedAddress = homeAddress;
    }
    activityStatus = status;
  }

  Future<List<String>> getAddress() async {
    var temp = <String>[];
    locationList!.forEach((model) {
      if (model.addcat != 'H') {
        temp.add(model.zadd1!);
      }
    });
    return temp;
  }

  Future<ResultModel> getAddressLatLon(String addr) async {
    _api.init(RequestType.GET_LAT_AND_LON);
    Map<String, dynamic> _body = {"departure": addr};
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
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

  Future<ResultModel> getDistance() async {
    var isActivityEndByZeroLatLon = selectedIndex == 2;
    var isTable260Null = editDayModel!.table260!.isEmpty;
    if (isActivityEndByZeroLatLon || isTable260Null) {
      // 거리 계산 안함.
      return ResultModel(true);
    }
    var startX = '';
    var startY = '';
    var stopX = '';
    var stopY = '';
    var startKunnr = '';
    var stopKunnr = '';

    var visitList =
        editDayModel!.table260!.where((item) => item.xvisit == 'Y').toList();
    // 도착처리건 있으면. 마지막 도착 지점의 lat & lon 가져온다.
    if (visitList.isNotEmpty) {
      var getLastVist = () {
        var index = 0;
        var time = 0;
        visitList.asMap().entries.forEach((map) {
          if (int.tryParse(map.value.atime!) != null) {
            var temp = int.parse(map.value.atime!);
            if (temp > time) {
              time = temp;
              index = map.key;
            }
          }
        });
        return visitList[index];
      };
      var lastVisitModel =
          visitList.length == 1 ? visitList.single : getLastVist();
      var latLonResult = await getAddressLatLon(selectedAddress!);
      startX = '${lastVisitModel.xLatitude}';
      startY = '${lastVisitModel.yLongitude}';
      stopX = latLonResult.data['lat'];
      stopY = latLonResult.data['lon'];
      startKunnr = lastVisitModel.zskunnr ?? '';
      pr('시작지점의 거래처 번호:: $stopKunnr');
      stopKunnr = '';
    } else {
      // 도착처리건 없으면 영업활동 첫건으로 판단해 table 250어서 영업활동 시작주소 가져옴.
      return ResultModel(true);
    }
    _api.init(RequestType.GET_DISTANCE);
    Map<String, dynamic> _body = {
      "departureCode": startKunnr,
      "departureX": startX,
      "departureY": startY,
      "destinationCode": stopKunnr,
      "destinationX": stopX,
      "destinationY": stopY
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      distanceModel = AddActivityDistanceModel.fromJson(result.body['data']);
      pr(distanceModel!.toJson());
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  Future<ResultModel> getDayData() async {
    var ap =
        KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_ADATE": FormatUtil.removeDash(DateUtil.getDateStr('',
            dt: activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
                    activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED
                ? await ap.previousWorkingDay
                : DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final dayResult = await _api.request(body: _body);
    if (dayResult == null || dayResult.statusCode != 200) {
      return ResultModel(false,
          isNetworkError: dayResult?.statusCode == -2,
          isServerError: dayResult?.statusCode == -1);
    }
    if (dayResult.statusCode == 200) {
      pr(dayResult.body);
      editDayModel =
          SalesActivityDayResponseModel.fromJson(dayResult.body['data']);
      return ResultModel(true);
    }
    return ResultModel(false);
  }

  double totoalDistans(double t250Dist) {
    var total = 0.0;
    if (editDayModel!.table260!.isNotEmpty) {
      var visitList = editDayModel!.table260!
          .where((model) => model.xvisit == 'Y')
          .toList();
      visitList.forEach((visitModel) {
        total += visitModel.dist!;
      });
    }
    return FormatUtil.asFixed('${total + t250Dist}', 1);
  }

  // Future<double> _getDistanceForFinishCourse() async {}
  Future<ResultModel> startOrStopActivity(int indexx) async {
    isLoadData = true;
    notifyListeners();
    pr(activityStatus);
    pr(activityStatus);
    if (activityStatus == ActivityStatus.STARTED ||
        activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED) {
      await getDayData();
      await getDistance();
    }
    if (selectedAddress != null) {
      await getAddressLatLon(selectedAddress!);
    } else {
      lat = '0.00';
      lon = '0.00';
    }
    assert(lat != null && lon != null);
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    var esLogin = CacheService.getEsLogin();
    var t250Base64 = '';
    var t260Base64 = '';
    var t280Base64 = '';
    var t361Base64 = '';
    var temp = <Map<String, dynamic>>[];
    var t250 = SalesActivityDayTable250();
    var time = DateUtil.getTimeNow();
    if (activityStatus == ActivityStatus.STARTED ||
        activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED) {
      // 영업활동 시작 하였으면 >>>  영업활동 종료
      t250 = SalesActivityDayTable250.fromJson(
          editDayModel!.table250!.single.toJson());
      t250.umode = 'U';
      t250.fcallType = 'M';
      t250.rtnDist = indexx != 2
          ? distanceModel != null
              ? FormatUtil.asFixed(distanceModel!.distance!, 1)
              : 0
          : 0;
      t250.totDist = totoalDistans(t250.rtnDist!);
      pr('t250.rtnDist::: ${t250.rtnDist}');
      t250.faddcat = locationType;
      t250.fxLatitude = double.parse(lat!.trim());
      t250.fylongitude = double.parse(lon!.trim());
      t250.ftime = activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED
          ? '235900'
          : DateUtil.getTimeNow();
      t250.fzaddr = indexx != 2 ? selectedAddress : '';
    } else {
      // 영업활동 시작 하지 않았으면. >>> 영업활동 시작. table 신규 추가.
      t250.adate =
          FormatUtil.removeDash(DateUtil.getDateStr('', dt: DateTime.now()));
      t250.aezet = DateUtil.getTimeNow(isNotWithColon: true);
      t250.saddcat = locationType;
      t250.szaddr = indexx != 2 ? selectedAddress : '';
      t250.ernam = esLogin!.ename;
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
    pr('250base64$t250Base64');
    if (editDayModel!.table260!.isNotEmpty) {
      temp.clear();
      temp.addAll([...editDayModel!.table260!.map((e) => e.toJson())]);
      t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }
    if (editDayModel!.table280!.isNotEmpty) {
      temp.clear();
      temp.addAll([...editDayModel!.table280!.map((e) => e.toJson())]);
      t280Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }
    if (editDayModel!.table361!.isNotEmpty) {
      temp.clear();
      temp.addAll([...editDayModel!.table361!.map((e) => e.toJson())]);
      t361Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    var ap =
        KeyService.baseAppKey.currentContext!.read<ActivityStateProvider>();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
        "T_ZLTSP0280S": t280Base64,
        "T_ZLTSP0361S": t361Base64,
        "IV_ADATE": FormatUtil.removeDash(DateUtil.getDateStr('',
            dt: activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
                    activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED
                ? await ap.previousWorkingDay
                : DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final result = await _api.request(body: _body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false,
          isNetworkError: result?.statusCode == -2,
          isServerError: result?.statusCode == -1);
    }
    if (result.statusCode == 200) {
      pr(result.body);
      editDayModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);
      pr(editDayModel?.toJson());
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false, errorMassage: result.errorMessage);
  }

  void setHeight(double val) {
    height = val;
    notifyListeners();
  }

  void setSelectedAddress(String? str, {bool? isMounted}) {
    selectedAddress = str;
    if (isMounted == null) {
      notifyListeners();
    }
  }

  void setSelectedIndex(int val) {
    selectedIndex = val;
    if (selectedIndex == 2) {
      selectedAddress = null;
    }
    if (selectedIndex == 1) {
      if (officeAddres.isNotEmpty) {
        isShowSelector = officeAddres.length > 1;
        if (isShowSelector) {
          height = AppSize.addressPopupHeight2;
        }
        selectedAddress = officeAddres.first.zadd1;
      }
    } else {
      isShowSelector = false;
      height = AppSize.addressPopupHeight;
    }
    notifyListeners();
  }

  void setIsShowSelector(bool val) {
    isShowSelector = val;
    notifyListeners();
  }
}
