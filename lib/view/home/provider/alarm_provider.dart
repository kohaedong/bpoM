/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/view/home/provider/alarm_provider.dart
 * Created Date: 2022-01-03 14:00:12
 * Last Modified: 2022-07-02 14:33:08
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/model/rfc/et_alarm_count_response_model.dart';
import 'package:medsalesportal/model/rfc/t_alarm_model.dart';
import 'package:medsalesportal/model/rfc/t_alarm_response_model.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/model/rfc/alarm_confirm_response_model.dart';

class AlarmProvider extends ChangeNotifier {
  EtAlarmCountResponseModel? alarmCountModel;
  TalarmResponseModel? responseModel;
  TalarmResponseModel? homeAlarmResponseModel;
  AlamConfirmResponseModel? alamConfirmResponseModel;
  List<TAlarmModel> confirmList = [];
  List<TAlarmModel> lastPageList = [];
  List<TAlarmModel> homeLastPageList = [];
  List<TAlarmModel> homeConfirmList = [];

  //------ pageing ----------
  int pos = 0;
  int partial = 20;
  bool isLoadData = false;
  bool hasMore = true;
  Future<void> refresh() async {
    hasMore = true;
    responseModel = null;
    confirmList = [];
    lastPageList = [];
    getAlarmList(true);
  }

  Future<AlarmResult?> nextPage() async {
    if (hasMore) {
      return getAlarmList(false);
    }
    return null;
  }

  void decrementAlarmCount(TAlarmModel model) {
    var temp = EtAlarmCountResponseModel.fromJson(alarmCountModel!.toJson());
    var count = int.parse(alarmCountModel!.model.single!.alarmCnt!);
    temp.model.single!.alarmCnt = '${count - 1}';
    alarmCountModel = EtAlarmCountResponseModel.fromJson(temp.toJson());
    notifyListeners();
  }

  Future<AlarmResult> getAlarmCount() async {
    final isLogin = CacheService.getIsLogin();
    Map<String, dynamic> alarmBody = {
      "methodName": RequestType.NOTICE_ALARM_COUNT.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.NOTICE_ALARM_COUNT.serverMethod,
        "resultTables": RequestType.NOTICE_ALARM_COUNT.resultTable,
        "IS_LOGIN": "$isLogin",
      }
    };
    final _api = ApiService();
    _api.init(RequestType.NOTICE_ALARM_COUNT);
    final result = await _api.request(body: alarmBody);

    if (result == null || result.statusCode != 200) {
      return AlarmResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      alarmCountModel = EtAlarmCountResponseModel.fromJson(result.body['data']);
      notifyListeners();
      return AlarmResult(true);
    }
    return AlarmResult(false);
  }

  Future<AlarmResult> getAlarmList(bool isMounted) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    await alarmConfirm().then((result) {
      if (!result.isSuccessful) {
        return result;
      }
    });
    final isLogin = CacheService.getIsLogin();
    var alarmBase64 = '';
    //* 첫페이지 일때 lastPageList =[]
    //* 첫페이지 아닐때 아니면  전페이지중에 확인처리 된 건 있으면 model 읽음으로 수정. [redck = 'X']
    if (lastPageList.isNotEmpty) {
      var temp = <Map<String, dynamic>>[];
      lastPageList.forEach((alarm) {
        var matchList = confirmList
            .where((confirmAlarm) => confirmAlarm.almon == alarm.almon)
            .toList();
        if (matchList.isNotEmpty) {
          print('is match');
          alarm.redck = matchList.single.redck;
        }
        temp.add(alarm.toJson());
      });
      confirmList.clear();
      alarmBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    }

    Map<String, dynamic> body = {
      "methodName": RequestType.NOTICE_ALARM.serverMethod,
      "methodParamMap": {
        "functionName": RequestType.NOTICE_ALARM.serverMethod,
        "resultTables": RequestType.NOTICE_ALARM.resultTable,
        "IS_LOGIN": "$isLogin",
        "T_ALARM": alarmBase64
      }
    };
    final _api = ApiService();
    _api.init(RequestType.NOTICE_ALARM);
    final result = await _api.request(body: body);

    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      return AlarmResult(false);
    }
    if (result.statusCode == 200 && result.body['data'] != null) {
      var temp = TalarmResponseModel.fromJson(result.body['data']);
      if (temp.list!.length != partial) {
        hasMore = false;
        notifyListeners();
      }
      if (responseModel == null) {
        responseModel = temp;
      } else {
        responseModel!.list!.addAll(temp.list!);
      }
      lastPageList.clear();
      temp.list!.forEach((alarm) {
        lastPageList.add(TAlarmModel.fromJson(alarm.toJson()));
      });
      isLoadData = false;
      notifyListeners();
      return AlarmResult(true);
    }
    isLoadData = false;
    hasMore = false;
    notifyListeners();

    return AlarmResult(false);
  }

  //* 확인 처리 된 알림을 [confirmList]에 따로 저장. 페이징시 사용.
  void addToConfirmList(TAlarmModel model) {
    if (model.redck == '') {
      model.redck = 'X';
      model.umode = 'U';
      confirmList.add(model);
      notifyListeners();
    }
  }

  Future<AlarmResult> alarmConfirm() async {
    if (confirmList.isEmpty) {
      return AlarmResult(true);
    }
    final isLogin = CacheService.getIsLogin();
    var temp = <Map<String, dynamic>>[];
    confirmList.forEach((alarm) {
      temp.add(alarm.toJson());
    });
    var base64 = await EncodingUtils.base64ConvertForListMap(temp);
    Map<String, dynamic> body = {
      "methodName": RequestType.NOTICE_ALARM_CONFIRM.serverMethod,
      "methodParamMap": {
        "IV_PTYPE": "U",
        "T_ALARM": base64,
        "IS_LOGIN": "$isLogin",
        "functionName": RequestType.NOTICE_ALARM_CONFIRM.serverMethod,
        "resultTables": "ES_RETURN,T_ALARM"
      }
    };

    final _api = ApiService();
    _api.init(RequestType.NOTICE_ALARM_CONFIRM);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      return AlarmResult(false);
    }
    if (result.statusCode == 200 && result.body != null) {
      alamConfirmResponseModel =
          AlamConfirmResponseModel.fromJson(result.body['data']);
      if (alamConfirmResponseModel!.esReturn!.mtype == 'S') {
        return AlarmResult(true);
      }
    }
    return AlarmResult(false);
  }

  //* 홈 확인된 알림 list에서 뻬주기.
  Future<void> removeHomeAlarmList(TAlarmModel alarm) async {
    homeAlarmResponseModel!.list!
        .removeWhere((alarmModel) => alarmModel == alarm);
    var temp = TAlarmModel.fromJson(alarm.toJson());
    temp.redck = 'X';
    temp.umode = 'U';
    homeConfirmList.add(temp);
    //*  홈 알림 list가 2개만 남았을때 다음페이지 호출.
    if (hasMore && homeAlarmResponseModel!.list!.length == 2) {
      getHomeAlarmList(false);
    }
    notifyListeners();
  }

  //* home 알림 확인처리.
  Future<AlarmResult> homeAlarmConfirm(TAlarmModel confirmAlarmModel) async {
    confirmAlarmModel.redck = 'X';
    confirmAlarmModel.umode = 'U';
    homeConfirmList.add(confirmAlarmModel);
    //* 확인처리 api는 알림 가져오기 api 와 동일한 functionName 을 사용한다. param만 다름.
    return getHomeAlarmList(true, confirmAlarmModel: confirmAlarmModel);
  }

  //* home 미확인 알림 list 호출 .
  Future<AlarmResult> getHomeAlarmList(bool isMounted,
      {TAlarmModel? confirmAlarmModel}) async {
    isLoadData = true;
    if (isMounted) {
      notifyListeners();
    }
    var alarmBase64 = '';
    //* 전페이지중에 확인처리 된 건 있으면 model 읽음으로 수정. [redck = 'X']
    //* [confirmAlarmModel] ==null 일때만 혜당.
    //* [confirmAlarmModel] null 이 아니면 1건만 확인 처리 함.

    if (confirmAlarmModel == null) {
      if (homeLastPageList.isNotEmpty) {
        var temp = <Map<String, dynamic>>[];
        homeLastPageList.forEach((alarm) {
          var matchList = homeConfirmList
              .where((confirmAlarm) => confirmAlarm.almon == alarm.almon)
              .toList();
          if (matchList.isNotEmpty) {
            print('is match');
            alarm.redck = matchList.single.redck;
          }
          temp.add(alarm.toJson());
        });
        homeConfirmList.clear();
        alarmBase64 = await EncodingUtils.base64ConvertForListMap(temp);
      }
    } else {
      var temp = <Map<String, dynamic>>[];
      temp.add(confirmAlarmModel.toJson());
      alarmBase64 = await EncodingUtils.base64ConvertForListMap(temp);
    }
    final isLogin = CacheService.getIsLogin();
    Map<String, dynamic> body = {
      "methodName": RequestType.UN_CONFIRM_ALARM.serverMethod,
      "methodParamMap": {
        "IV_NEXT_READ": "X",
        "IV_PTYPE": "U",
        "T_ALARM": alarmBase64,
        "IS_LOGIN": "$isLogin",
        "pos": pos,
        "partial": partial,
        "functionName": RequestType.UN_CONFIRM_ALARM.serverMethod,
        "resultTables": RequestType.UN_CONFIRM_ALARM.resultTable
      }
    };
    final _api = ApiService();
    _api.init(RequestType.UN_CONFIRM_ALARM);
    final result = await _api.request(body: body);
    if (result == null || result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return AlarmResult(false);
    }
    if (result.statusCode == 200) {
      print(result.body['ES_RETURN']);
      var temp = TalarmResponseModel.fromJson(result.body['data']);
      if (temp.list != null && temp.list!.isNotEmpty) {
        if (temp.list!.length != partial) {
          hasMore = true;
        }
        if (homeAlarmResponseModel == null) {
          homeAlarmResponseModel = temp;
        } else {
          homeAlarmResponseModel!.list!.addAll(temp.list!);
        }
        homeLastPageList.clear();
        temp.list!.forEach((alarm) {
          homeLastPageList.add(TAlarmModel.fromJson(alarm.toJson()));
        });
        isLoadData = false;
        notifyListeners();
        return AlarmResult(true);
      }
    }
    isLoadData = false;
    notifyListeners();
    return AlarmResult(false);
  }
}

class AlarmResult {
  bool isSuccessful;
  AlarmResult(
    this.isSuccessful,
  );
}
