/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/util/encoding_util.dart
 * Created Date: 2021-08-21 16:38:26
 * Last Modified: 2022-07-26 16:10:32
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:convert';
import 'package:medsalesportal/model/commonCode/is_login_model.dart';
import 'package:medsalesportal/model/commonCode/is_login_simple_model.dart';
import 'package:medsalesportal/util/regular.dart';

// 인코딩 도구.
class EncodingUtils {
  static encodeBase64({
    required String str,
  }) {
    Codec<String, String> stringToBase64 = utf8.fuse(base64);

    return stringToBase64.encode(str);
  }

  static List<int> strToAsc(String str) {
    AsciiCodec ascCodec = new AsciiCodec();
    return ascCodec.encode(str);
  }

  static IsLoginModel decodeBase64ForIsLogin(String base64) {
    var utf8List = base64Decode(base64);
    var enter = strToUtf8('\f').single;
    var space = strToUtf8('\b').single;

    var keyUnit8 = utf8List.sublist(0, utf8List.indexOf(enter) - 1);
    var valueUnit8 = utf8List.sublist(utf8List.indexOf(enter) + 1);
    var key = <String>[];
    var value = <String>[];

    var keyTemp = <int>[];
    var valueTemp = <int>[];
    keyUnit8.forEach((unit8) {
      if (unit8 != space) {
        keyTemp.add(unit8);
      } else {
        key.add(keyTemp.isEmpty ? '' : utf8ToStr(keyTemp));
        keyTemp.clear();
      }
    });
    valueUnit8.forEach((unit8) {
      if (unit8 != space) {
        valueTemp.add(unit8);
      } else {
        value.add(valueTemp.isEmpty ? '' : utf8ToStr(valueTemp));
        valueTemp.clear();
      }
    });

    assert(key.length == value.length);
    var map = <String, dynamic>{};
    List.generate(
        key.length, (index) => map.putIfAbsent(key[index], () => value[index]));

    return IsLoginModel.fromJson(map);
  }

  static Future<String> getSimpleIsLogin(IsLoginModel isLoginModel) async {
    var temp = IsLoginSimpleModel.fromJson(isLoginModel.toJson());
    return EncodingUtils.base64Convert(temp.toJson());
  }

  static String ascToStr(List<int> uint8list) {
    AsciiCodec ascCodec = new AsciiCodec();
    return ascCodec.decode(uint8list);
  }

  static List<int> strToUtf8(String str) {
    return utf8.encode(str);
  }

  static String utf8ToStr(List<int> utf8List) {
    return utf8.decode(utf8List);
  }

  static String utf8ToBase64(List<int> utf8List) {
    return base64Encode(utf8List);
  }

  static String ascToBase64(List<int> uint8list) {
    Base64Codec base64codec = new Base64Codec();
    return base64codec.encode(uint8list);
  }

  static List<int> base64ToAsc(String str) {
    Base64Codec base64codec = new Base64Codec();
    return base64codec.decode(str);
  }

  static Future<String> convertKeyAndValueToBase64(
      List<String> strList, List<String> valueList) async {
    if (strList.isEmpty) {
      return '';
    }
    List<int> tempList = [];
    assert(strList.length == valueList.length);

    await Future.delayed(Duration.zero, () {
      for (var i = 0; i < strList.length - 1; i++) {
        tempList.addAll(strToUtf8(strList[i]));
        tempList.addAll(strToUtf8('\b'));
      }
    }).whenComplete(() {
      tempList.addAll(strToUtf8(strList[strList.length - 1]));
      tempList.addAll(strToUtf8('\f'));
      for (var i = 0; i < valueList.length - 1; i++) {
        tempList.addAll(strToUtf8(valueList[i]));
        tempList.addAll(strToUtf8('\b'));
      }
      tempList.addAll(strToUtf8(valueList[valueList.length - 1]));
    });
    var result = utf8ToBase64(tempList);
    return result;
  }

  static Future<String> base64Convert(Map<String, dynamic> mapData) async {
    List<String> keyList = [];
    List<String> valueList = [];

    mapData.forEach((key, value) {
      keyList.add(key);
      valueList.add(value == null || value == 'null' ? '' : '$value');
      // valueList.add(value == 'null' ? '' : value);
    });
    final result =
        await EncodingUtils.convertKeyAndValueToBase64(keyList, valueList);
    print('base64ConvertFrom Map::  $result');
    return result;
  }

  static Future<String> base64ConvertFromListString(List<String> list) async {
    List<int> tempList = [];
    for (var i = 0; i < list.length; i++) {
      tempList.addAll(strToUtf8(list[i].trim()));
      if (i != list.length - 1) {
        tempList.addAll(strToUtf8('\f'));
      }
    }
    var result = utf8ToBase64(tempList);
    print('base64ConvertFrom List<String> $result');
    return result;
  }

  static Future<String> base64ConvertForListMap(
      List<Map<String, dynamic>> jsonList) async {
    List<String> keys = [];
    List<List<String>> values = [];
    jsonList.forEach((map) {
      keys.clear();
      keys = map.keys.toList();
      (Map<String, dynamic> m) {
        var temp = <String>[];
        m.forEach((key, value) {
          temp.add('${value == null ? '' : value == 'null' ? '' : value}');
        });
        values.add(temp);
      }(map);
    });

    List<int> tempList = [];
    await Future.delayed(Duration.zero, () {
      for (var i = 0; i < keys.length - 1; i++) {
        tempList.addAll(strToUtf8(keys[i]));
        tempList.addAll(strToUtf8('\b'));
      }
    }).whenComplete(() {
      tempList.addAll(strToUtf8(keys[keys.length - 1]));
      tempList.addAll(strToUtf8('\f'));
      for (var i = 0; i < values.length; i++) {
        (int index) {
          for (var j = 0; j < values[index].length - 1; j++) {
            tempList.addAll(strToUtf8(values[index][j]));
            tempList.addAll(strToUtf8('\b'));
          }
          tempList.addAll(strToUtf8(values[index][values[index].length - 1]));
        }(i);
        tempList.addAll(strToUtf8('\f'));
        //
      }
    });
    print('base64ConvertForListMap::: $tempList');
    return utf8ToBase64(tempList);
  }

  static Future<String> convertKeyAndValueListToBase64(
      String key, List<String> value) async {
    List<int> tempList = [];
    tempList.addAll(strToUtf8(key));
    tempList.addAll(strToUtf8('\f'));
    await Future.delayed(Duration.zero, () {
      for (var i = 0; i < value.length; i++) {
        tempList.addAll(strToUtf8(value[i]));
        if (i != value.length - 1) {
          tempList.addAll(strToUtf8('\b'));
        }
      }
    });
    var result = utf8ToBase64(tempList);
    return result;
  }

  static Future<bool> isKr(String str) async {
    var matchStr = await RegExpUtil.matchFirst(str, RegExpUtil.matchKr);
    return matchStr != null && matchStr != '' ? true : false;
  }
}
