/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/add_activity_page_provider.dart
 * Created Date: 2022-08-11 11:12:00
 * Last Modified: 2022-08-24 09:07:14
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
import 'package:medsalesportal/model/rfc/et_kunnr_response_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_distance_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_280.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_361.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_250.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_table_260.dart';
import 'package:medsalesportal/model/rfc/add_activity_suggetion_item_model.dart';
import 'package:medsalesportal/model/rfc/sales_activity_day_response_model.dart';
import 'package:medsalesportal/model/rfc/add_activity_key_man_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

typedef IncrementSeqNo = String Function();

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
  String? seletedAmount;
  List<String>? activityList;
  List<AddActivitySuggetionItemModel>? suggestedList;
  bool isLoadData = false;
  bool isVisit = false;
  bool isWithTeamLeader = false;
  bool isUpdate = false;
  int? index;
  int isInterviewIndex = 0;
  final _api = ApiService();
  String get dptnm => CacheService.getEsLogin()!.dptnm!;
  Future<ResultModel> initData(SalesActivityDayResponseModel fromParentModel,
      ActivityStatus status, int? indexx) async {
    editModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    activityStatus = status;
    pr(activityStatus);
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
      selectedKeyMan!.zkmnoNm =
          temp.zkmnoNm != null && temp.zkmnoNm!.trim().isEmpty
              ? null
              : temp.zkmnoNm;
      selectedKeyMan!.zkmno =
          temp.zkmno != null && temp.zkmno!.trim().isEmpty ? null : temp.zkmno;
      distanceModel = AddActivityDistanceModel();
      distanceModel!.distance = '${temp.dist}';
      reasonForNotVisit = temp.visitRmk ?? '';
      reasonForinterviewFailure = temp.meetRmk ?? '';
      visitResultInput = temp.rslt ?? '';
      leaderAdviceInput = temp.comnt ?? '';
      isVisit = temp.xvisit == 'Y';
      isInterviewIndex = temp.xmeet == 'Y' ? 0 : 1;
    }
    suggestedList = [];

    return ResultModel(true);
  }

  void setAnotherSaler(saler) {
    saler as EtStaffListModel?;
    anotherSaler = saler;
    notifyListeners();
  }

  void setAmount(String? str) {
    seletedAmount = str;
    pr(seletedAmount);
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
    // suggestedList?.clear();
    notifyListeners();
  }

  void setVisitResultInputText(String? str) {
    visitResultInput = str;
    pr(visitResultInput);
    notifyListeners();
  }

  void setLeaderAdviceInputText(String? str) {
    leaderAdviceInput = str;
    pr(leaderAdviceInput);
    notifyListeners();
  }

  void setIsInterviewIndex(int indexx) {
    isInterviewIndex = indexx;
    notifyListeners();
  }

  void setReasonForInterviewFailure(String str) {
    reasonForinterviewFailure = str;
    pr(reasonForinterviewFailure);
  }

  void setReasonForNotVisit(String val) {
    reasonForNotVisit = val;
    pr(reasonForNotVisit);
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
    selectedKeyMan = null;
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

  Future<ResultModel> saveTable() async {
    isLoadData = true;
    notifyListeners();

    var isLogin = CacheService.getIsLogin();
    var t250Base64 = ''; // 영업활동 시작/종료
    var t260Base64 = ''; // 영업활동 상세
    var t280Base64 = ''; // 활동유형
    var t361Base64 = ''; // 동행
    var temp = <Map<String, dynamic>>[];
    var t250 = SalesActivityDayTable250();
    var t260 = SalesActivityDayTable260();
    var t280 = SalesActivityDayTable280();
    var t361 = SalesActivityDayTable361();
    var time = DateUtil.getTimeNow();
    t250 =
        SalesActivityDayTable250.fromJson(editModel!.table250!.first.toJson());
    temp.addAll([t250.toJson()]);
    t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    var now = DateTime.now();
    var esLogin = CacheService.getEsLogin();
    var t260List = <SalesActivityDayTable260>[];
    var t280List = <SalesActivityDayTable280>[];
    var t361List = <SalesActivityDayTable361>[];

    var newT260 = ({required bool isFirstEntity}) async {
      isFirstEntity // first Activity
          ? () {
              t260.erdat = t250.erdat;
              t260.erzet = t250.erzet;
              t260.ernam = t250.ernam;
              t260.erwid = t250.erwid;
              t260.aedat = t250.aedat;
              t260.aezet = t250.aezet;
              t260.aenam = t250.aenam;
              t260.aewid = t250.aewid;
              t260.mandt = t250.mandt;
              t260.bzactno = t250.bzactno;
            }()
          : () {
              index == null // new activity.
                  ? () {
                      t260.erdat = DateUtil.getDateStr(now.toIso8601String());
                      t260.erzet = DateUtil.getTimeNow(isNotWithColon: true);
                      t260.ernam = esLogin!.ename;
                      t260.erwid = esLogin.logid;
                      t260.aedat = DateUtil.getDateStr(now.toIso8601String());
                      t260.aezet = DateUtil.getTimeNow(isNotWithColon: true);
                      t260.aenam = esLogin.ename;
                      t260.aewid = esLogin.logid;
                      t260.mandt = t250.mandt;
                      t260.bzactno = t250.bzactno;
                    }()
                  : () {
                      // update activity
                      t260 = SalesActivityDayTable260.fromJson(
                          editModel!.table260![index!].toJson());
                    }();
            }();

      IncrementSeqNo incrementSeqno = () {
        var lastSeqno = int.parse(editModel!.table260!.last.seqno!);
        lastSeqno++;
        var repairLenght = 4 - '$lastSeqno'.length;
        var newSeqno = '';
        for (var i = 0; i < repairLenght; i++) {
          newSeqno += '0';
        }
        newSeqno = '$newSeqno$lastSeqno';
        return newSeqno;
      };
      // 화면 수정사항.
      var latLonMap = await getAddressLatLon(selectedKunnr!.zaddName1!)
          .then((result) => result.data);

      t260.adate = DateUtil.getDateStr(DateTime.now().toIso8601String());
      t260.xLatitude = isVisit ? double.parse(latLonMap['lat']) : 0.00;
      t260.yLongitude = isVisit ? double.parse(latLonMap['lon']) : 0.00;
      t260.dist = isVisit ? double.parse(distanceModel!.distance!) : 0.0;
      t260.seqno = isFirstEntity
          ? '0001'
          : index == null
              ? incrementSeqno()
              : t260.seqno;
      t260.umode = isFirstEntity ? 'I' : 'U';
      t260.isGps = 'X';
      t260.callType = 'M';
      t260.zskunnr = selectedKunnr!.kunnr;
      t260.zskunnrNm = selectedKunnr!.name;
      t260.zaddName1 = selectedKunnr!.zaddName1;
      t260.xvisit = isVisit ? 'Y' : 'N';
      t260.zstatus = selectedKunnr!.zstatus;
      t260.zkmno = selectedKeyMan!.zkmno;
      t260.zkmnoNm = selectedKeyMan!.zkmnoNm;
      t260.visitRmk = isVisit ? '' : reasonForNotVisit ?? '';
      t260.xmeet = isInterviewIndex == 0 ? 'Y' : 'N';
      t260.meetRmk =
          isInterviewIndex == 0 ? '' : reasonForinterviewFailure ?? '';
      t260.rslt = visitResultInput ?? '';
      t260.comnt = leaderAdviceInput ?? '';

      // 동행 처리.

      // 활동 유형 추가.
    };

    if (editModel!.table260!.isEmpty) {
      await newT260(isFirstEntity: true).then((_) => t260List.add(t260));
    } else {
      editModel!.table260!.forEach((table) {
        t260List.add(SalesActivityDayTable260.fromJson(table.toJson()));
      });
      await newT260(isFirstEntity: false).then((_) => t260List.add(t260));
    }
    temp.clear();
    temp.addAll([...t260List.map((table) => table.toJson())]);
    t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);

    var newT361 = () async {
      var isFirstEntity = editModel!.table361!
          .where((table) => table.seqno == t260.seqno)
          .toList()
          .isNotEmpty;
      isFirstEntity
          ? () {
              // insert
            }()
          : () {
              // update
            }();
    };
    if (editModel!.table260!.isEmpty) {
      await newT361().then((_) => t361List.add(t361));
    } else {
      editModel!.table361!.forEach((table) {
        t361List.add(SalesActivityDayTable361.fromJson(table.toJson()));
      });
      await newT361().then((_) => t361List.add(t361));
    }
    temp.clear();
    temp.addAll([...t361List.map((table) => table.toJson())]);
    t361Base64 = await EncodingUtils.base64ConvertForListMap(temp);

    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "IV_ADATE": FormatUtil.removeDash(
            DateUtil.getDateStr(DateTime.now().toIso8601String())),
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
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
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      pr(result.body);
      editModel = SalesActivityDayResponseModel.fromJson(result.body['data']);
      pr(editModel?.toJson());
      isLoadData = false;
      // notifyListeners();
      isUpdate = true;
      notifyListeners();
      return ResultModel(true);
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false, errorMassage: result?.errorMessage);
  }

  Future<ResultModel> getAddressLatLon(String addr) async {
    _api.init(RequestType.GET_LAT_AND_LON);
    Map<String, dynamic> _body = {"departure": addr};
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
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
      distanceModel = AddActivityDistanceModel.fromJson(result.body['data']);
      isVisit = true;
      notifyListeners();
      return ResultModel(true);
    }
    return ResultModel(false);
  }
}
