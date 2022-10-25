/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/util/screen_capture_util.dart
 * Created Date: 2021-12-14 00:55:19
 * Last Modified: 2022-10-26 06:37:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:async';
import 'dart:ui' as ui;
import 'dart:io';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

// 캡쳐방지
typedef ScreenCaptrueCallback = Future<Uint8List?> Function();

class ScreenCaptrueService {
  factory ScreenCaptrueService() => _sharedInstance();
  static ScreenCaptrueService? _instance;
  ScreenCaptrueService._();
  static ScreenCaptrueService _sharedInstance() {
    if (_instance == null) {
      _instance = ScreenCaptrueService._();
    }
    return _instance!;
  }

  static late StreamSubscription<dynamic> captrueSubscription;
  static Future<void> sendImageToServer() async {
    final bytes = await getBitmapFromContext();
    print(bytes);
    final base64Image = base64Encode(bytes ?? []);
    var esLogin = CacheService.getEsLogin();

    var api = ApiService();
    Map<String, dynamic> body = {
      "methodName": RequestType.SEND_IMAGE_TO_SERVER.serverMethod,
      "methodParam": {
        "appGrpId": Platform.isIOS ? '80' : '79',
        "screenId":
            "${esLogin != null ? esLogin.ename : ''}${DateTime.now().toIso8601String()}",
        "screenShot": "$base64Image"
      }
    };
    api.init(RequestType.SEND_IMAGE_TO_SERVER);
    final result = await api.request(body: body);
    if (result!.statusCode == 200) {
      print('send success');
    }
  }

  static Future<Uint8List?> getBitmapFromContext({double? pixelRatio}) async {
    Uint8List? unit8List;
    ui.Image? image;
    return await Future.delayed(Duration.zero, () async {
      try {
        var renderObject = KeyService.screenKey.currentContext!
            .findRenderObject() as RenderRepaintBoundary;
        image = await renderObject.toImage();
        var byte = await image!.toByteData(format: ui.ImageByteFormat.png);
        unit8List = byte!.buffer.asUint8List();
      } catch (e) {}
    }).then((_) {
      return unit8List;
    });
  }

  static void startListener() async {
    if (Platform.isIOS) {
      var lock = false;
      EventChannel iosEvent = EventChannel('kolonbase/keychain/event');
      captrueSubscription =
          iosEvent.receiveBroadcastStream("screen").listen((result) async {
        CacheService.setIsDisableUpdate(true);
        if (result != null) {
          pr('listen');
          if (!lock) {
            lock = true;
            Future.delayed(Duration(seconds: 1), () async {
              final dialogResult = await AppDialog.showDangermessage(
                  KeyService.baseAppKey.currentContext!,
                  '${tr('scrren_info')}');
              if (dialogResult != null) {
                Future.delayed(Duration(seconds: 2), () {
                  sendImageToServer().then((value) {
                    var signinProvider = KeyService.baseAppKey.currentContext!
                        .read<LoginProvider>();
                    signinProvider.setIsWaterMarkeUser();
                    lock = false;
                  });
                }).then((_) => CacheService.setIsDisableUpdate(false));
              }
            });
          }
        }
      }, onError: (e) {
        print(e);
      });
    }
  }

  static void stopListener() {
    captrueSubscription.cancel();
  }
}
