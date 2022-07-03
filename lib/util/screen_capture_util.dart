/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/salesportal/lib/util/screen_capture_util.dart
 * Created Date: 2021-12-14 00:55:19
 * Last Modified: 2022-07-03 13:33:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/rendering.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/service/navigator_service.dart';
import 'package:medsalesportal/view/common/base_app_dialog.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/view/signin/provider/signin_provider.dart';
import 'dart:ui' as ui;

// 캡쳐방지
typedef ScreenCaptrueCallback = Future<Uint8List?> Function();

class ScreenCaptrueUtil {
  static Future<void> sendImageToServer() async {
    final bytes = await getBitmapFromContext();
    print(bytes);
    final base64Image = base64Encode(bytes ?? []);
    var esLogin = CacheService.getEsLogin();

    var api = ApiService();
    Map<String, dynamic> body = {
      "methodName": RequestType.SEND_IMAGE_TO_SERVER.serverMethod,
      "methodParam": {
        "appGrpId": Platform.isIOS ? '2' : '1',
        "screenId": "${esLogin!.ename}${DateTime.now().toIso8601String()}",
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
      var renderObject = NavigationService.screenKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      image = await renderObject.toImage();
      var byte = await image!.toByteData(format: ui.ImageByteFormat.png);
      unit8List = byte!.buffer.asUint8List();
    }).then((_) {
      return unit8List;
    });
  }

  static void screenListen() async {
    if (Platform.isIOS) {
      var lock = false;
      EventChannel iosEvent = EventChannel('kolonbase/keychain/event');
      iosEvent.receiveBroadcastStream("screen").listen((result) async {
        CacheService.setIsDisableUpdate(true);
        if (result != null) {
          if (!lock) {
            lock = true;
            Future.delayed(Duration(seconds: 1), () async {
              final dialogResult = await AppDialog.showDangermessage(
                  NavigationService.kolonAppKey.currentContext!,
                  '${tr('scrren_info')}');
              if (dialogResult != null) {
                Future.delayed(Duration(seconds: 2), () {
                  sendImageToServer().then((value) {
                    var signinProvider = SigninProvider();
                    signinProvider.setIsWaterMarkeUser();
                    lock = false;
                    signinProvider.dispose();
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
}
