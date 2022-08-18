/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/add_activity_page_provider.dart
 * Created Date: 2022-08-11 11:12:00
 * Last Modified: 2022-08-18 13:35:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/model/rfc/et_staff_list_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_response_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_distance_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_item_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';

class AddActivityPageProvider extends ChangeNotifier {
  AddActivityKeyManResponseModel? keyManResponseModel;
  EtKunnrResponseModel? etKunnrResponseModel;
  SalesActivityDayResponseModel? editModel;
  AddActivityDistanceModel? distanceModel;
  AddActivityKeyManModel? selectedKeyMan;
  EtStaffListModel? anotherSaler;
  ActivityStatus? activityStatus;
  EtKunnrModel? selectedKunnr;
  String? reasonForinterviewFailure;
  String? selectedActionType;
  String? reasonForNotVisit;
  String? visitResultInput;
  String? leaderAdviceInput;
  List<String>? activityList;
  List<AddActivitySuggetionItemModel>? suggestedList;
  bool isVisit = false;
  bool isWithTeamLeader = false;
  int? index;
  int isInterviewIndex = 0;
  final _api = ApiService();
  String get dptnm => CacheService.getEsLogin()!.dptnm!;
  Future<ResultModel> initData(SalesActivityDayResponseModel fromParentModel,
      ActivityStatus status, int? indexx) async {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    activityStatus = status;
    index = indexx;
    if (index != null) {
      var temp = editModel!.table260![index!];
      isVisit = temp.xvisit != null && temp.xvisit == 'Y';
      selectedKunnr = EtKunnrModel();
      selectedKunnr!.name = temp.zskunnrNm;
      selectedKunnr!.kunnr = temp.zskunnr;
      selectedKunnr!.zskunnr = temp.zskunnr;
      selectedKunnr!.zaddName1 = temp.zaddr;
      selectedKunnr!.zstatus = temp.zstatus;
      selectedKeyMan = AddActivityKeyManModel();
      selectedKeyMan!.zkmnoNm = temp.zkmnoNm;
      distanceModel = AddActivityDistanceModel();
      distanceModel!.distance = '${temp.dist}';

      reasonForNotVisit = temp.visitRmk ?? '';
      reasonForinterviewFailure = temp.meetRmk ?? '';
      visitResultInput = '';
      leaderAdviceInput = '';
    }
    suggestedList = [];

    return ResultModel(true);
  }

  void setAnotherSaler(saler) {
    saler as EtStaffListModel?;
    anotherSaler = saler;
    notifyListeners();
  }

  void removeAtSuggestedList(int indexx) {
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedList!];
    temp.removeAt(indexx);
    suggestedList = [...temp];
    notifyListeners();
  }

  void insertToSuggestedList() {
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedList!];
    temp.insert(temp.length == 0 ? 0 : temp.length,
        AddActivitySuggetionItemModel(isChecked: false));
    suggestedList = [...temp];
    notifyListeners();
  }

  void updateSuggestedList(int indexx,
      {AddActivitySuggetionItemModel? updateModel}) {
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedList!];
    var model = AddActivitySuggetionItemModel();
    if (updateModel == null) {
      // checkBox만 update
      model = AddActivitySuggetionItemModel.fromJson(temp[indexx].toJson());
      model.isChecked = model.isChecked == null ? true : !model.isChecked!;
    } else {
      // 모듈 내부 data update.
      model = AddActivitySuggetionItemModel.fromJson(updateModel.toJson());
      var isCheced = temp[indexx].isChecked;
      model.isChecked = isCheced;
    }
    temp.removeAt(indexx);
    temp.insert(indexx, model);
    suggestedList = [...temp];
    notifyListeners();
  }

  void setSelectedActionType(String? str) {
    selectedActionType = str;
    notifyListeners();
  }

  void setVisitResultInputText(String? str) {
    visitResultInput = str;
  }

  void setLeaderAdviceInputText(String? str) {
    leaderAdviceInput = str;
  }

  void setIsInterviewIndex(int indexx) {
    isInterviewIndex = indexx;
    notifyListeners();
  }

  void setReasonForInterviewFailure(String str) {
    reasonForinterviewFailure = str;
    notifyListeners();
  }

  void setReasonForNotVisit(String val) {
    reasonForNotVisit = val;
  }

  void setIsVisit(bool val) {
    isVisit = val;
    notifyListeners();
  }

  void setIsWithTeamLeader(bool? val) {
    isWithTeamLeader = val ?? false;
    notifyListeners();
  }

  void setCustomerModel(EtKunnrModel? model) {
    selectedKunnr = model;
    notifyListeners();
  }

  void setKeymanModel(AddActivityKeyManModel? model) {
    selectedKeyMan = model;
    notifyListeners();
  }

  Future<List<String>> getActivityType() async {
    if (activityList == null) {
      activityList = await HiveService.getActivityType();
    }
    var temp = <String>[];
    activityList!.forEach((item) {
      temp.add(item.substring(0, item.indexOf('-')));
    });
    temp.removeWhere((item) => item.contains('사용불가'));
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
      var coordinateResponseModel =
          SalseActivityCoordinateResponseModel.fromJson(result.body['data']);
      var model = coordinateResponseModel.result;
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

      var lat = tempLat ?? newLat ?? null;
      var lon = tempLon ?? newLon ?? null;
      return ResultModel(lat != null && lon != null,
          data: {'lat': lat, 'lon': lon});
    }
    return ResultModel(false);
  }

  SalesActivityDayTable260 _getLastVisitModel(
      List<SalesActivityDayTable260> visitList) {
    var model = SalesActivityDayTable260();
    visitList.forEach((item) {
      var temp = 0;
      var time = int.parse(item.aezet!);
      if (time > temp) {
        temp = time;
        model = item;
      }
    });
    return model;
  }

  Future<ResultModel> getDistance() async {
    assert(selectedKunnr != null && selectedKeyMan != null);
    var isNewActivity = index == null;
    var isTable260Null = editModel!.table260!.length == 0;
    var latLonResult = await getAddressLatLon(selectedKunnr!.zaddName1!);
    var startX = '';
    var startY = '';
    var stopX = '';
    var stopY = '';
    var startKunnr = '';
    var stopKunnr = '';
    var setStartLatLonFormTable250 = () {
      startX = '${editModel!.table250!.single.sxLatitude!}';
      startY = '${editModel!.table250!.single.syLongitude!}';
      stopX = latLonResult.data['lat'];
      stopY = latLonResult.data['lon'];
      startKunnr = '';
      stopKunnr = selectedKunnr!.kunnr!;
    };
    if (isNewActivity) {
      if (isTable260Null) {
        // 도착처리건 없으면 영업활동 첫건으로 판단해 table 250어서 영업활동 시작주소 가져옴.
        setStartLatLonFormTable250.call();
      } else {
        var visitList =
            editModel!.table260!.where((item) => item.xvisit == 'Y').toList();
        // 도착처리건 있으면. 마지막 도착 지점의 lat & lon 가져온다.
        if (visitList.isNotEmpty) {
          var lastVisitModel = _getLastVisitModel(visitList);
          startX = '${lastVisitModel.xLatitude}';
          startY = '${lastVisitModel.yLongitude}';
          stopX = latLonResult.data['lat'];
          stopY = latLonResult.data['lon'];
          startKunnr = lastVisitModel.zskunnr ?? '';
          stopKunnr = selectedKunnr!.kunnr!;
        } else {
          // 도착처리건 없으면 영업활동 첫건으로 판단해 table 250어서 영업활동 시작주소 가져옴.
          setStartLatLonFormTable250.call();
        }
      }
    } else {
      //  일별 영업활동 화면에서 List 클릭 후 진입시
      var model = editModel!.table260![index!];
      var visitList =
          editModel!.table260!.where((item) => item.xvisit == 'Y').toList();
      var lastVisitModel = _getLastVisitModel(visitList);
      startX = '${lastVisitModel.xLatitude}';
      startY = '${lastVisitModel.yLongitude}';
      stopX = '${model.xLatitude!}';
      stopY = '${model.yLongitude}';
      startKunnr = lastVisitModel.zskunnr ?? '';
      stopKunnr = selectedKunnr!.kunnr!;
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
    if (result != null && result.statusCode != 200) {
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      pr(result.body);
      distanceModel = AddActivityDistanceModel.fromJson(result.body['data']);
      isVisit = true;
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
