/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/cache_service.dart
 * Created Date: 2021-08-22 19:45:10
 * Last Modified: 2022-07-18 17:39:44
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:convert';
import 'package:medsalesportal/enums/account_type.dart';
import 'package:medsalesportal/model/rfc/es_login_model.dart';
import 'package:medsalesportal/model/user/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

//*  SharedPreferences Singleton
class CacheService {
  factory CacheService() => _sharedInstance();
  static CacheService? _instance;
  static SharedPreferences? sharedPreferences;
  CacheService._();
  static CacheService _sharedInstance() {
    if (_instance == null) {
      _instance = CacheService._();
    }
    return _instance!;
  }

  static init() async {
    sharedPreferences = await SharedPreferences.getInstance();
  }

  static saveData(String key, dynamic data) {
    switch (data.runtimeType) {
      case int:
        sharedPreferences?.setInt(key, data);
        break;
      case String:
        sharedPreferences?.setString(key, data);
        break;
      case bool:
        sharedPreferences?.setBool(key, data);
        break;
      case double:
        sharedPreferences?.setDouble(key, data);
        break;
      case List:
        sharedPreferences?.setStringList(key, data);
        break;
    }
  }

  static void deleteALL() {
    sharedPreferences?.clear();
  }

  static getData(String key) {
    return sharedPreferences?.get(key);
  }

  static bool checkExits(String key) {
    return sharedPreferences!.containsKey(key);
  }

  static void deleteData(String key, {bool? withConstans}) {
    if (withConstans != null) {
      var keys = sharedPreferences?.getKeys();
      keys!.forEach((realKey) {
        if (realKey.contains(key)) {
          sharedPreferences?.remove(realKey);
        }
      });
    } else {
      final exists = checkExits(key);
      if (exists) {
        sharedPreferences?.remove(key);
      }
    }
  }

//* esLogin
  static void saveEsLogin(EsLoginModel model) {
    saveData('es_login', jsonEncode(model.toJson()));
  }

  static EsLoginModel? getEsLogin() {
    return EsLoginModel.fromJson(jsonDecode(getData('es_login')));
  }

  // netWork Check
  static void saveNetworkState(bool isAlive) {
    saveData('is_network_alive', isAlive);
  }

// Simulator 나 Emulator 에서는 네이트웍 상태 감지 못하기 때문에 Default true로 설정 합니다.
  static bool getNetworkState() {
    return getData('is_network_alive') ?? true;
  }

//* isLogin
  static void saveIsLogin(String islogn) {
    saveData('is_login', islogn);
  }

//* update 와 notice 프로세스 종료여부.
//* 종료안했으면 벡그라운드에서 포그라운드로 전환시 다시는 update or notice 체크안함.
  static bool isUpdateAndNoticeCheckDone() {
    return getData('is_check_done') ?? false;
  }

  static void saveIsUpdateAndNoticeCheckDone(bool isCheckDone) {
    saveData('is_check_done', isCheckDone);
  }

//* tValue 다운로드 성공여부 구분자.
//* tValue는 하루에 한번만 다운받는다 .(다운로드 성공시  hive table에 현재시각 삽입)
//* 다운로드중 전원꺼짐등 비상 상황시 다시 다운로드 하기 위한 구분자.
  static bool isTValueDownLoadDone() {
    return getData('is_t_value_download_done') ?? false;
  }

  static void saveIsTValueDownLoadDone(bool isDone) {
    saveData('is_t_value_download_done', isDone);
  }

  static String? getIsLogin() {
    final result = getData('is_login');
    return result;
  }

// * 전화 번호 클릭시 다이얼로그가 호출 되면서 앱이 백그라운드로 상태로 변합니다.
// * 다시 포그라운드로 돌아올때 update 체크 여부를 설정 해주는 구분자.
  static bool? getIsDisableUpdate() {
    return getData('isDisable') ?? false;
  }

  static void setIsDisableUpdate(bool? isDisable) {
    saveData('isDisable', isDisable ?? false);
  }

  static void saveUser(User? user) {
    saveData('user', user != null ? jsonEncode(user.toJson()) : null);
  }

  static void saveAccountType(AccountType type) {
    saveData('accountType', type.name);
  }

  static AccountType getAccountType() {
    var temp = getData('accountType');
    return AccountType.values.where((type) => type.name == temp).single;
  }

  static User? getUser() {
    var exists = checkExits('user');
    if (exists) {
      final user = getData('user');
      return User.fromJson(jsonDecode(user));
    }
    return null;
  }

  static void deleteUserInfoWhenSignOut() {
    deleteData('user');
    deleteData('lifecycle_', withConstans: true);
    deleteData('isDisable');
    deleteData('is_login');
    deleteData('es_login');
    deleteData('is_loged_in');
    deleteData('is_check_done');
  }
}
