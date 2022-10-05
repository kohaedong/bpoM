/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/salesActivityManager/provider/add_activity_page_provider.dart
 * Created Date: 2022-08-11 11:12:00
 * Last Modified: 2022-10-06 08:32:29
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/util/date_util.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/enums/activity_status.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/rfc/et_kunnr_model.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
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
import 'package:medsalesportal/model/rfc/add_activity_suggetion_response_model.dart';
import 'package:medsalesportal/model/rfc/salse_activity_coordinate_response_model.dart';

typedef IncrementSeqNo = String Function(String);
typedef IsThisActivityFrom361 = bool Function(SalesActivityDayTable361);
typedef IsThisActivityFrom280 = bool Function(SalesActivityDayTable280);

class AddActivityPageProvider extends ChangeNotifier {
  AddActivityKeyManResponseModel? keyManResponseModel;
  AddActivitySuggetionResponseModel? suggetionResponseModel;
  SalesActivityDayResponseModel? fromParentResponseModel;
  List<AddActivitySuggetionItemModel>? suggestedItemList;
  EtKunnrResponseModel? etKunnrResponseModel;
  SalesActivityDayTable260? editModel260;
  AddActivityDistanceModel? distanceModel;
  AddActivityKeyManModel? selectedKeyMan;
  EtStaffListModel? anotherSaller;
  ActivityStatus? activityStatus;
  EtKunnrModel? selectedKunnr;
  String? reasonForinterviewFailure;
  String? selectedActionType;
  String? reasonForNotVisit;
  String? visitResultInput;
  String? leaderAdviceInput;
  String? seletedAmount;
  String? lastSeqNo;
  String? review;
  List<String>? activityList;

  bool? isLockOtherSalerSelector;
  bool isLoadData = false;
  bool isModified = false;
  bool isVisit = false;
  bool isWithTeamLeader = false;
  bool isUpdate = false;
  int isInterviewIndex = 0;
  int? index;
  final _api = ApiService();
  bool get isModifiyByNewCase => isModified;
  String get dptnm => CacheService.getEsLogin()!.dptnm!;
  bool get isUpdattt => isUpdate;
  bool get isDoNothing =>
      activityStatus == ActivityStatus.NONE ||
      activityStatus == ActivityStatus.FINISH;
  IncrementSeqNo incrementSeqno = (String seqno) {
    var recentSeqno = int.parse(seqno); //

    recentSeqno++;
    var repairLenght = 4 - '$recentSeqno'.length;
    var newSeqno = '';
    for (var i = 0; i < repairLenght; i++) {
      newSeqno += '0';
    }
    newSeqno = '$newSeqno$recentSeqno';
    return newSeqno;
  };
  DateTime? goinToMenuTime;
  bool get isDifreentGoinTime => goinToMenuTime!.day != DateTime.now().day;
  bool get isModifiedByEntity {
    if (index != null) {
      var original = fromParentResponseModel!.table260![index!];
      var v1 = original.zskunnr != selectedKunnr?.zskunnr;
      var v2 = original.zskunnrNm != selectedKunnr?.name;
      var v3 = original.zaddr != selectedKunnr?.zaddName1;
      var v4 = original.xvisit != (isVisit ? 'Y' : 'N');
      var v5 = original.zkmno != selectedKeyMan?.zkmno;
      var v6 = original.zkmnoNm != selectedKeyMan?.zkmnoNm;
      var v7 = original.visitRmk != reasonForNotVisit;
      var v9 = original.meetRmk != reasonForinterviewFailure;
      var v10 = original.rslt != visitResultInput;
      var v11 = original.comnt != leaderAdviceInput;

      var trueLIst = <bool>[];
      trueLIst.addAll([v1, v2, v3, v4, v5, v6, v7, v9, v10, v11]);
      pr(trueLIst);
      pr('trueLIst.contains(true)${trueLIst.contains(true)}');
      pr('editModel260 == null  ${editModel260 == null}');
      pr('sb ${editModel260 == null ? trueLIst.contains(true) : true}');
      return (trueLIst.contains(true));
    } else {
      return false;
    }
  }

  Future<ResultModel> initData(
    SalesActivityDayResponseModel fromParentModel,
    ActivityStatus status,
    int? indexx,
  ) async {
    goinToMenuTime = DateTime.now();
    distanceModel = AddActivityDistanceModel();
    fromParentResponseModel =
        SalesActivityDayResponseModel.fromJson(fromParentModel.toJson());
    activityStatus = status;
    pr(activityStatus);
    fromParentModel.table250!.asMap().entries.forEach((map) {
      pr('250:: index: ${map.key} -  ${map.value.toJson()}');
    });
    fromParentModel.table260!.asMap().entries.forEach((map) {
      pr('260:: index: ${map.key} -  ${map.value.toJson()}');
    });
    index = indexx;
    if (index != null) {
      lastSeqNo = getLastSeqNo();

      var temp = fromParentResponseModel!.table260![index!];
      if (index != null) {
        editModel260 = SalesActivityDayTable260.fromJson(
            fromParentResponseModel?.table260?[index!].toJson());
      }
      isVisit = temp.xvisit != null && temp.xvisit == 'Y';
      review = temp.comntM;
      selectedKunnr = EtKunnrModel();
      selectedKunnr!.name = temp.zskunnrNm;
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

      distanceModel!.distance = '${temp.dist}';
      reasonForNotVisit = temp.visitRmk ?? '';
      reasonForinterviewFailure = temp.meetRmk ?? '';
      visitResultInput = temp.rslt ?? '';
      leaderAdviceInput = temp.comnt ?? '';
      isVisit = temp.xvisit == 'Y';
      isInterviewIndex = temp.xmeet == 'S' ? 0 : 1;
      suggestedItemList ??= [];

      // 동행 초기화.
      var saveAnotherSaller = () {
        IsThisActivityFrom361 isThisActivityFor361 =
            (SalesActivityDayTable361 table) {
          return table.bzactno == temp.bzactno && table.seqno == temp.seqno;
        };
        var temp361 = fromParentResponseModel!.table361!
            .where((table) => isThisActivityFor361(table))
            .toList();
        if (temp361.isNotEmpty) {
          var model = SalesActivityDayTable361.fromJson(temp361.last.toJson());
          anotherSaller = EtStaffListModel();
          anotherSaller!.sname = model.sname;
          anotherSaller!.logid = model.logid;
          isLockOtherSalerSelector = true;
        }
      };
      // 동행 주요 로직.
      switch (temp.accompany?.trim()) {
        case 'E001':
          saveAnotherSaller();
          break;
        case 'D001':
          isWithTeamLeader = true;
          break;
        case 'E002':
          isWithTeamLeader = true;
          saveAnotherSaller();
          break;
        default:
      }
      // 활동유형. 초기화.(제안품목이 3개라도 활동유형은 1개  --- actcat2..actcat3 비움.)
      if (temp.actcat1!.isNotEmpty) {
        await getActivityType().then((_) {
          var tempStr = activityList!
              .where((actity) => actity.contains(temp.actcat1!))
              .single;
          selectedActionType = tempStr.substring(0, tempStr.indexOf('-'));
        });
      }

      // 활동 유형 및 제안제품 초기화.
      var saveActivityType = () async {
        IsThisActivityFrom280 isThisActivityFor280 =
            (SalesActivityDayTable280 table) {
          return table.bzactno == temp.bzactno && table.seqno == temp.seqno;
        };
        var temp280List = fromParentResponseModel!.table280!
            .where((table) => isThisActivityFor280(table))
            .toList();
        if (temp280List.isNotEmpty) {
          // only one!
          var data = SalesActivityDayTable280();
          temp280List.forEach((element) {
            pr('###${element.toJson()}');
          });
          try {
            //! more
            data = temp280List.last;
            seletedAmount = data.amount1 != null ? '${data.amount1}' : '0';
          } catch (e) {
            pr(e);
          }
          // 추천품목.
          List.generate(3, (index) async {
            switch (index) {
              case 0:
                if (data.matnr1!.isNotEmpty) {
                  var model = AddActivitySuggetionItemModel();
                  model.matnr = data.matnr1;
                  model.maktx = data.maktx1;
                  model.matkl = data.zmatkl1;
                  model.isChecked = data.xsampl1 == 'X';
                  suggestedItemList!.add(model);
                }
                break;
              case 1:
                if (data.matnr2!.isNotEmpty) {
                  var model = AddActivitySuggetionItemModel();
                  model.matnr = data.matnr2;
                  model.maktx = data.maktx2;
                  model.matkl = data.zmatkl2;
                  model.isChecked = data.xsampl2 == 'X';
                  suggestedItemList!.add(model);
                }
                break;
              case 2:
                if (data.matnr3!.isNotEmpty) {
                  var model = AddActivitySuggetionItemModel();
                  model.matnr = data.matnr3;
                  model.maktx = data.maktx3;
                  model.matkl = data.zmatkl3;
                  model.isChecked = data.xsampl3 == 'X';
                  suggestedItemList!.add(model);
                }
                break;
            }
          });
          await Future.forEach(suggestedItemList!, (item) async {
            item as AddActivitySuggetionItemModel;
            if (item.maktx!.isEmpty) {
              // 제품명 null 체크.
              item.maktx = await searchSuggetionItem(item.matnr!)
                  .then((model) => model != null ? model.maktx : '');
            }
          });
        }
      };

      await saveActivityType().then((value) => pr(suggestedItemList));
    } else {
      await getDayData();
      suggestedItemList ??= [];
      distanceModel!.distance = '0.0';
    }
    isModified = false;
    return ResultModel(true);
  }

  void setAnotherSaler(saler) {
    isModified = true;
    saler as EtStaffListModel?;
    anotherSaller = saler;
    notifyListeners();
  }

  void setAmount(String? str) {
    isModified = true;
    seletedAmount = str;
    pr(seletedAmount);
    notifyListeners();
  }

  void removeAtSuggestedList(int indexx) {
    isModified = true;
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedItemList!];
    temp.removeAt(indexx);
    suggestedItemList = [...temp];
    notifyListeners();
  }

  void setReview(String str) {
    review = str;
    notifyListeners();
  }

  void insertToSuggestedList() {
    isModified = true;
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedItemList!];
    temp.insert(temp.length == 0 ? 0 : temp.length,
        AddActivitySuggetionItemModel(isChecked: false));
    suggestedItemList = [...temp];
    notifyListeners();
  }

  void updateSuggestedList(int indexx,
      {AddActivitySuggetionItemModel? updateModel}) {
    isModified = true;
    var temp = <AddActivitySuggetionItemModel>[];
    temp = [...suggestedItemList!];
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
    suggestedItemList = [...temp];
    notifyListeners();
  }

  void setSelectedActionType(String? str) {
    isModified = true;
    selectedActionType = str;
    if (suggestedItemList == null || suggestedItemList!.isEmpty) {
      insertToSuggestedList();
    }
    notifyListeners();
  }

  void setVisitResultInputText(String? str) {
    isModified = true;
    visitResultInput = str;
    pr(visitResultInput);
    notifyListeners();
  }

  void setLeaderAdviceInputText(String? str) {
    isModified = true;
    leaderAdviceInput = str;
    pr(leaderAdviceInput);
    notifyListeners();
  }

  void setIsInterviewIndex(int indexx) {
    isModified = true;
    isInterviewIndex = indexx;
    //실패시 제안품목과 활동유형 삭제처리
    if (indexx == 1) {
      selectedActionType = null;
      suggestedItemList = [];
      seletedAmount = null;
    }
    notifyListeners();
  }

  void setReasonForInterviewFailure(String str) {
    isModified = true;
    reasonForinterviewFailure = str;
    pr(reasonForinterviewFailure);
  }

  void setReasonForNotVisit(String val) {
    isModified = true;
    reasonForNotVisit = val;
    pr(reasonForNotVisit);
  }

  void setIsVisit(bool val) {
    isModified = true;
    isVisit = val;
    notifyListeners();
  }

  void setIsWithTeamLeader(bool? val) {
    isModified = true;
    isWithTeamLeader = val ?? false;
    notifyListeners();
  }

  void setCustomerModel(EtKunnrModel? model) {
    isModified = true;
    selectedKunnr = model;
    selectedKeyMan = null;
    notifyListeners();
  }

  void setKeymanModel(AddActivityKeyManModel? model) {
    isModified = true;
    selectedKeyMan = model;
    notifyListeners();
  }

  Future<ResultModel> getDayData() async {
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    var isLogin = CacheService.getIsLogin();
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_ADATE":
            FormatUtil.removeDash(DateUtil.getDateStr('', dt: DateTime.now())),
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    final dayResult = await _api.request(body: _body);
    if (dayResult != null && dayResult.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (dayResult != null && dayResult.statusCode == 200) {
      fromParentResponseModel =
          SalesActivityDayResponseModel.fromJson(dayResult.body['data']);
      return ResultModel(true);
    }
    return ResultModel(false);
  }

// 제안품목명 구하기 위한 api.
  Future<AddActivitySuggetionItemModel?> searchSuggetionItem(
      String matnr) async {
    var _api = ApiService();
    _api.init(RequestType.SEARCH_SUGGETION_ITEM);
    Map<String, dynamic>? _body;
    _body = {
      "methodName": RequestType.SEARCH_SUGGETION_ITEM.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "R",
        "IV_MATNR": matnr,
        "IV_MAKTX": "",
        "IV_MATKL": "",
        "IV_WGBEZ": "",
        "IV_MTART": "",
        "IS_LOGIN": CacheService.getIsLogin(),
        "resultTables": RequestType.SEARCH_SUGGETION_ITEM.resultTable,
        "functionName": RequestType.SEARCH_SUGGETION_ITEM.serverMethod
      }
    };
    _api.init(RequestType.SEARCH_END_OR_DELIVERY_CUSTOMER);
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return null;
    }
    if (result != null && result.statusCode == 200) {
      suggetionResponseModel =
          AddActivitySuggetionResponseModel.fromJson(result.body['data']);
      return suggetionResponseModel!.etOutput!.single;
    }
    return null;
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

  String getCode(List<String> list, String val) {
    if (val != tr('all')) {
      var data = list
          .where((item) => item.contains(val) && !item.contains('사용불가'))
          .single;
      return data.substring(data.indexOf('-') + 1);
    }
    return '';
  }

  String getLastSeqNo() {
    var number = 0;
    fromParentResponseModel!.table260!.forEach((table) {
      if (int.tryParse(table.seqno!) != null) {
        var tempSeqNo = int.parse(table.seqno!);
        if (tempSeqNo > number) {
          number = tempSeqNo;
        }
      }
    });
    var repairLenght = 4 - '$number'.length;
    var newSeqno = '';
    for (var i = 0; i < repairLenght; i++) {
      newSeqno += '0';
    }
    newSeqno = '$newSeqno$number';
    return '$newSeqno';
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
    var t260List = <SalesActivityDayTable260>[];
    var t280List = <SalesActivityDayTable280>[];
    var t361List = <SalesActivityDayTable361>[];
    SalesActivityDayTable280? t280; // data 무조건 1개 밖에 없음.
    SalesActivityDayTable361? t361; // data 무조건 1개 밖에 없음.
    var esLogin = CacheService.getEsLogin();
    var now = DateTime.now();

    IsThisActivityFrom361 isTable361MatchThisCondition =
        (SalesActivityDayTable361 table) {
      return table.seqno == t260.seqno;
    };
    IsThisActivityFrom280 isTable280MatchThisCondition =
        (SalesActivityDayTable280 table) {
      return table.bzactno == t260.bzactno && table.seqno == t260.seqno;
    };
    t250 = SalesActivityDayTable250.fromJson(
        fromParentResponseModel!.table250!.single.toJson());
    t250.aedat =
        FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
    t250.aezet = DateUtil.getTimeNow(isNotWithColon: true);
    t250.aenam = esLogin!.ename;
    temp.addAll([t250.toJson()]);
    t250Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    // 영업활동 처리. - 260
    var newT260 = ({required bool isEditModel}) async {
      isEditModel
          ? () async {
              if (editModel260 != null) {
                t260 =
                    SalesActivityDayTable260.fromJson(editModel260!.toJson());
              } else {
                t260 = SalesActivityDayTable260.fromJson(
                    fromParentResponseModel!.table260![index!].toJson());
              }
              t260.umode = 'U';
            }()
          : () async {
              // 첫번째 데이터
              if (editModel260 == null) {
                var isFirstEntity = fromParentResponseModel!.table260!.isEmpty;
                t260.umode = 'I';
                pr('empty????');

                if (isFirstEntity) {
                  lastSeqNo = '0000';
                } else {
                  lastSeqNo = getLastSeqNo();
                }
                pr('lastSeqNo:::${lastSeqNo}');

                t260.seqno = incrementSeqno(lastSeqNo!);
                t260.erdat = FormatUtil.removeDash(
                    DateUtil.getDateStr(DateTime.now().toIso8601String()));
                t260.erzet = DateUtil.getTimeNow(isNotWithColon: true);
                t260.ernam = esLogin.ename;
                t260.erwid = esLogin.logid;
                t260.aenam = esLogin.ename;
                t260.aewid = esLogin.logid;
                t260.adate = FormatUtil.removeDash(
                    DateUtil.getDateStr(DateTime.now().toIso8601String()));
              } else {
                t260 =
                    SalesActivityDayTable260.fromJson(editModel260!.toJson());
                t260.umode = 'U';
                t260.aenam = esLogin.ename;
                t260.aewid = esLogin.logid;
              }
            }();
      //! 화면 수정사항.
      t260.aedat =
          FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
      t260.aezet = DateUtil.getTimeNow(isNotWithColon: true);
      // 도착할때만 저장.

      if ((t260.atime == null ||
              (t260.atime != null && t260.atime!.trim().isEmpty)) &&
          isVisit) {
        var isPrevdate =
            (activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED ||
                activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED);
        var prevDay = DateUtil.getDate(t260.erdat!);
        var today = DateTime.now();
        t260.atime = DateUtil.getTimeNow2(
            isNotWithColon: true,
            dt: isPrevdate
                ? DateTime(prevDay.year, prevDay.month, prevDay.day, 23, 59, 00)
                : today);
        t260.sminute = '1';
        pr('t260.atime  ${t260.atime}');
      }

      var latLonMap = await getAddressLatLon(selectedKunnr!.zaddName1!)
          .then((result) => result.data);

      t260.xLatitude = isVisit ? double.parse(latLonMap['lat']) : 0.00;
      t260.yLongitude = isVisit ? double.parse(latLonMap['lon']) : 0.00;
      t260.dist = isVisit ? double.parse(distanceModel!.distance!) : 0.0;
      t260.isGps = 'X';
      t260.callType = 'M';
      t260.comntM = review ?? '';
      t260.zskunnr = selectedKunnr!.zskunnr;
      t260.zskunnrNm = selectedKunnr!.name;
      t260.zaddr = selectedKunnr!.zaddName1;
      t260.xvisit = isVisit ? 'Y' : 'N';
      t260.zstatus = selectedKunnr!.zstatus;
      t260.zkmno = selectedKeyMan!.zkmno;
      t260.zkmnoNm = selectedKeyMan!.zkmnoNm;
      t260.visitRmk = isVisit ? '' : reasonForNotVisit ?? '';
      t260.xmeet = isInterviewIndex == 0 ? 'S' : 'F';
      t260.meetRmk =
          isInterviewIndex == 0 ? '' : reasonForinterviewFailure ?? '';
      t260.rslt = visitResultInput ?? '';
      t260.comnt = leaderAdviceInput ?? '';
      var withLeaderOnly = isWithTeamLeader && anotherSaller == null;
      var withLeaderAndSaller = isWithTeamLeader && anotherSaller != null;
      var withSallerOnly = !isWithTeamLeader && anotherSaller != null;
      t260.accompany = withLeaderOnly
          ? 'D001'
          : withSallerOnly
              ? 'E001'
              : withLeaderAndSaller
                  ? 'E002'
                  : '';

      // if (suggestedItemList != null && suggestedItemList!.isNotEmpty) {
      //   t260.actcat1 = getCode(activityList!, selectedActionType!);
      // }
      if (activityList != null && selectedActionType != null) {
        t260.actcat1 = getCode(activityList!, selectedActionType!);
      }
    };

    // create table 260 table List
    if (index == null) {
      await newT260(isEditModel: false).then((_) => t260List.add(t260));
    } else {
      try {
        var currentActivity = fromParentResponseModel!.table260![index!];
        fromParentResponseModel!.table260!.forEach((table) {
          if (table != currentActivity) {
            t260List.add(SalesActivityDayTable260.fromJson(table.toJson()));
          }
        });
        await newT260(isEditModel: true).then((_) => t260List.add(t260));
      } catch (e) {
        pr(' error :::$e');
      }
    }
    t260List.forEach((element) {
      pr('before Base64 ${element.toJson()}');
    });
    // 260 base64
    temp.clear();
    temp.addAll([...t260List.map((table) => table.toJson())]);
    t260Base64 = await EncodingUtils.base64ConvertForListMap(temp);

    // 동행 처리 - 361 .
    var newT361 = () async {
      if (anotherSaller != null) {
        t361 ??= SalesActivityDayTable361();
        if (t361!.bzactno != null && t361!.bzactno!.isNotEmpty) {
          t361!.umode = 'U';
        } else {
          t361!.umode = 'I';
          t361!.ernam = esLogin.ename;
          t361!.erwid = esLogin.logid;
          t361!.erdat =
              FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
          t361!.erzet = DateUtil.getTimeNow(isNotWithColon: true);
        }
        t361!.bzactno = t260.bzactno;
        t361!.seqno = t260.seqno;
        t361!.aedat =
            FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
        t361!.aezet = DateUtil.getTimeNow(isNotWithColon: true);
        t361!.aenam = esLogin.ename;
        t361!.subseq = 1;
        t361!.logid = anotherSaller!.logid;
        t361!.sname = anotherSaller!.sname;
        t361!.zkmno = selectedKeyMan!.zkmno;
        t361!.zskunnr = selectedKunnr!.zskunnr;
      } else {
        if (t361 != null) {
          t361!.umode = 'D';
        }
      }
    };
    // create table 361 table List
    var isTable361NotEmpty = fromParentResponseModel!.table361!.isNotEmpty;
    if (isTable361NotEmpty) {
      fromParentResponseModel!.table361!.forEach((table) {
        !isTable361MatchThisCondition(table)
            ? t361List.add(SalesActivityDayTable361.fromJson(table.toJson()))
            : () {
                t361 = table;
              }();
      });
    }
    await newT361()
        .then((_) => t361 != null ? t361List.add(t361!) : DoNothingAction());
    // 361 base64
    if (t361List.isNotEmpty) {
      temp.clear();
      temp.addAll([...t361List.map((table) => table.toJson())]);
      t361Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    // 활동유형 처리 - 280
    var newT280 = () async {
      if (suggestedItemList != null && suggestedItemList!.isNotEmpty) {
        t280 ??= SalesActivityDayTable280();
        t280!.matnr1 = '';
        t280!.maktx1 = '';
        t280!.zmatkl1 = '';
        t280!.xsampl1 = '';
        t280!.matnr2 = '';
        t280!.maktx2 = '';
        t280!.zmatkl2 = '';
        t280!.xsampl2 = '';
        t280!.matnr3 = '';
        t280!.maktx3 = '';
        t280!.zmatkl3 = '';
        t280!.xsampl3 = '';

        await Future.forEach(suggestedItemList!.asMap().entries, (map) async {
          map as MapEntry<int, AddActivitySuggetionItemModel>;
          switch (map.key) {
            case 0:
              t280!.amount1 =
                  seletedAmount != null && seletedAmount!.trim().isNotEmpty
                      ? double.parse(seletedAmount!)
                      : 0.0;
              t280!.matnr1 = map.value.matnr;
              t280!.zmatkl1 = map.value.matkl;
              t280!.xsampl1 =
                  map.value.isChecked != null && map.value.isChecked!
                      ? 'X'
                      : '';
              if (map.value.maktx == null || map.value.maktx!.isEmpty) {
                t280!.maktx1 = map.value.maktx;
              } else {
                t280!.maktx1 = await searchSuggetionItem(t280!.matnr1!)
                    .then((model) => model != null ? model.maktx : '');
              }
              break;
            case 1:
              t280!.matnr2 = map.value.matnr;
              t280!.zmatkl2 = map.value.matkl;
              t280!.xsampl2 =
                  map.value.isChecked != null && map.value.isChecked!
                      ? 'X'
                      : '';
              if (map.value.maktx == null || map.value.maktx!.isEmpty) {
                t280!.maktx2 = map.value.maktx;
              } else {
                t280!.maktx2 = await searchSuggetionItem(t280!.matnr2!)
                    .then((model) => model != null ? model.maktx : '');
              }

              break;
            case 2:
              t280!.matnr3 = map.value.matnr;
              t280!.zmatkl3 = map.value.matkl;
              t280!.xsampl3 =
                  map.value.isChecked != null && map.value.isChecked!
                      ? 'X'
                      : '';
              if (map.value.maktx == null || map.value.maktx!.isEmpty) {
                t280!.maktx3 = map.value.maktx;
              } else {
                t280!.maktx3 = await searchSuggetionItem(t280!.matnr3!)
                    .then((model) => model != null ? model.maktx : '');
              }
              break;
          }
        });
        if (t280!.bzactno != null && t280!.bzactno!.isNotEmpty) {
          t280!.umode = 'U';
        } else {
          t280!.umode = 'I';
          t280!.ernam = esLogin.ename;
          t280!.erwid = esLogin.logid;
          t280!.erdat =
              FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
          t280!.erzet = DateUtil.getTimeNow(isNotWithColon: true);
        }
        t280!.bzactno = t260.bzactno;
        t280!.seqno = t260.seqno;
        t280!.aedat =
            FormatUtil.removeDash(DateUtil.getDateStr(now.toIso8601String()));
        t280!.aezet = DateUtil.getTimeNow(isNotWithColon: true);
        t280!.aenam = esLogin.ename;
        t280!.amount1 =
            seletedAmount != null && seletedAmount!.trim().isNotEmpty
                ? double.parse(seletedAmount!)
                : 0.0;
      } else {
        if (t280 != null) {
          t280!.umode = 'D';
        }
      }
    };

// -------------------------------------------------------------------------------

    // create table 280 table List
    var isTable280NotEmpty = fromParentResponseModel!.table280!.isNotEmpty;
    if (isTable280NotEmpty) {
      fromParentResponseModel!.table280!.forEach((table) {
        !isTable280MatchThisCondition(table)
            ? t280List.add(SalesActivityDayTable280.fromJson(table.toJson()))
            : () {
                t280 = table;
              }();
      });
    }
    await newT280()
        .then((_) => t280 != null ? t280List.add(t280!) : DoNothingAction());

    // 280 base64
    if (t280List.isNotEmpty) {
      pr('notEmpty');
      temp.clear();
      temp.addAll([...t280List.map((table) => table.toJson())]);
      t280Base64 = await EncodingUtils.base64ConvertForListMap(temp);
    }
    _api.init(RequestType.SALESE_ACTIVITY_DAY_DATA);
    Map<String, dynamic> _body = {
      "methodName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "IV_ADATE": FormatUtil.removeDash(
            DateUtil.getDateStr(DateTime.now().toIso8601String())),
        "T_ZLTSP0250S": t250Base64,
        "T_ZLTSP0260S": t260Base64,
        "T_ZLTSP0280S": t280Base64,
        "T_ZLTSP0361S": t361Base64,
        "IS_LOGIN": isLogin,
        "resultTables": RequestType.SALESE_ACTIVITY_DAY_DATA.resultTable,
        "functionName": RequestType.SALESE_ACTIVITY_DAY_DATA.serverMethod,
      }
    };
    pr('t250Base64 :: $t250Base64');

    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      fromParentResponseModel =
          SalesActivityDayResponseModel.fromJson(result.body['data']);
      isModified = true;
      if (activityStatus == ActivityStatus.PREV_WORK_DAY_STOPED ||
          activityStatus == ActivityStatus.PREV_WORK_DAY_EN_STOPED) {
        isLoadData = false;
        isUpdate = true;
        notifyListeners();
        fromParentResponseModel!.table250!.asMap().entries.forEach((map) {
          pr('table250 index ${map.key} ${map.value.toJson()}');
        });
        fromParentResponseModel!.table260!.asMap().entries.forEach((map) {
          pr('table260 index ${map.key} ${map.value.toJson()}');
        });
        pr(' pop ');
        Navigator.pop(KeyService.baseAppKey.currentContext!, true);
      } else {
        fromParentResponseModel?.table250?.forEach((element) {
          pr('@@@@250table  ${element.toJson()}');
        });
        if (index != null) {
          var temp = fromParentResponseModel!.table260!
              .where((table) => table.seqno == lastSeqNo)
              .last;
          editModel260 = SalesActivityDayTable260.fromJson(temp.toJson());
        } else {
          var temp = fromParentResponseModel!.table260!
              .where((table) => table.seqno == incrementSeqno(lastSeqNo!))
              .single;
          editModel260 = SalesActivityDayTable260.fromJson(temp.toJson());
        }
        if (anotherSaller != null) {
          isLockOtherSalerSelector = true;
        }
        isLoadData = false;
        isUpdate = true;
        notifyListeners();
        return ResultModel(true);
      }
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
      pr(coordinateResponseModel.toJson());
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

  Future<ResultModel> getDistance() async {
    isLoadData = true;
    notifyListeners();
    assert(selectedKunnr != null && selectedKeyMan != null);
    var isTable260Null = fromParentResponseModel!.table260!.isEmpty;
    var startX = '';
    var startY = '';
    var stopX = '';
    var stopY = '';
    var startKunnr = '';
    var stopKunnr = '';
    var sLat = fromParentResponseModel!.table250!.last.sxLatitude;
    var sLon = fromParentResponseModel!.table250!.last.syLongitude;
    var setStartLatLonFormTable250 = () async {
      var latLonResult = await getAddressLatLon(selectedKunnr!.zaddName1!);
      startX = '$sLat';
      startY = '$sLon';
      stopX = latLonResult.data['lat'];
      stopY = latLonResult.data['lon'];
      startKunnr = '';
      stopKunnr = selectedKunnr!.zskunnr!;
    };
    var isActivityStartByZeroLatLon = sLat == 0.0 && sLon == 0.0;
    if (isActivityStartByZeroLatLon && isTable260Null) {
      pr('거리계산안함');
      isVisit = true;
      return ResultModel(true);
    } else if (isTable260Null) {
      // 도착처리건 없으면 영업활동 첫건으로 판단해 table 250어서 영업활동 시작주소 가져옴.
      await setStartLatLonFormTable250.call();
    } else {
      var visitList = fromParentResponseModel!.table260!
          .where((item) => item.xvisit == 'Y')
          .toList();
      // 도착처리건 있으면. 마지막 도착 지점의 lat & lon 가져온다.
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
      if (visitList.isNotEmpty) {
        var lastVisitModel =
            visitList.length == 1 ? visitList.single : getLastVist();
        var latLonResult = await getAddressLatLon(selectedKunnr!.zaddName1!);
        startX = '${lastVisitModel.xLatitude}';
        startY = '${lastVisitModel.yLongitude}';
        stopX = latLonResult.data['lat'];
        stopY = latLonResult.data['lon'];
        startKunnr = lastVisitModel.zskunnr ?? '';
        stopKunnr = selectedKunnr!.zskunnr!;
      } else {
        // 도착처리건 없으면 영업활동 첫건으로 판단해 table 250어서 영업활동 시작주소 가져옴.
        await setStartLatLonFormTable250.call();
      }
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
      isLoadData = false;
      notifyListeners();
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      distanceModel = AddActivityDistanceModel.fromJson(result.body['data']);
      isVisit = true;
      isLoadData = false;
      notifyListeners();
      return ResultModel(true);
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false);
  }
}
