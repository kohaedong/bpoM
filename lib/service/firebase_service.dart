/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/firebase_service.dart
 * Created Date: 2022-10-18 15:55:12
 * Last Modified: 2022-10-25 03:39:34
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'dart:async';
import 'package:provider/provider.dart';

class FirebaseService {
  factory FirebaseService() => _sharedInstance();
  static FirebaseService? _instance;
  FirebaseService._();
  static FirebaseService _sharedInstance() {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  static NotificationSettings? notiSettings;
  static bool isPermissed = false;
  static String fcmTocken = '';
  static late FirebaseMessaging messaging;
  static late Stream<String> fcmRefreshTokenStream;
  static late Stream<RemoteMessage> messageStream;
  static late Stream<RemoteMessage> openMessageStream;
  //초기화  --> 앱이 첫실행시 한번만 호출
  static Future<bool> init() async {
    await Firebase.initializeApp(
            name: 'medsalesportal',
            options: DefaultFirebaseOptions.currentPlatform)
        .then((firebaseApp) async {
      messaging = FirebaseMessaging.instance;
      messageStream = FirebaseMessaging.onMessage;
      fcmRefreshTokenStream = messaging.onTokenRefresh;
      openMessageStream = FirebaseMessaging.onMessageOpenedApp;
      // await requstFcmPermission();
    });
    return true;
  }

  static Future<bool> requstFcmPermission() async {
    await messaging.requestPermission().then((settings) async {
      pr(settings.toString());
      setNotiSettings(settings);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        getToken().then((token) => pr(token));
      }
    }).catchError((e) {
      pr(e);
    });
    return true;
  }

  static void addListennr() {
    FirebaseMessaging.onBackgroundMessage(backgroundCallback);
    startFirebaseMessageListenner();
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(RemoteMessage message) async {
    pr(message);
    // dosomething. background mode
    pr('in back ground mode.');
  }

  static Future<void> setIOSNoticeOption() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
              alert: true, badge: true, sound: true);
    }
  }

  static void setNotiSettings(NotificationSettings settings) {
    notiSettings = settings;
  }

  static Future<String?> getToken() async {
    var token = await messaging.getToken();
    return token;
  }

  static Future<void> startFirebaseMessageListenner() async {
    await setIOSNoticeOption();
    fcmRefreshTokenStream.listen((newToken) async {
      pr("fcm 토큰 갱신 ---> $newToken");
      fcmTocken = newToken;
      final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
      lp.sendFcmToken();
    });
    messageStream.listen((message) {
      var notification = message.notification;
      pr(notification);
      pr(message.notification!.apple);
      var android = message.notification?.android;
      var ios = message.notification?.apple;
      if (notification != null && android != null && !kIsWeb) {
        pr(message.data);
        pr(message.messageId);
        // send data to globle message provider
      } else if (notification != null && ios != null && !kIsWeb) {
        // ios push notice ui show
        // send data to globle message provider
      }
    });
    openMessageStream.listen((message) {
      // on open push notice Event added!
      // route to contents page.
    });
  }
}

class DefaultFirebaseOptions {
  static final isDev = (KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev');
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return isDev ? androidDev : android;
      case TargetPlatform.iOS:
        return isDev ? iosDev : ios;
      case TargetPlatform.macOS:
        return isDev ? macosDev : macos;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: '',
    appId: '',
    messagingSenderId: '',
    projectId: '',
    authDomain: '',
    databaseURL: '',
    storageBucket: '',
    measurementId: '',
  );

  static const FirebaseOptions androidDev = FirebaseOptions(
    appId: '1:1013306379146:android:d2bb5fb291cacad5',
    apiKey: 'AIzaSyCnrGBmoyFwfYBXkTF9T-nlzkXWY2_KCk0',
    projectId: 'medsalesportal',
    messagingSenderId: '1013306379146',
  );

  static const FirebaseOptions iosDev = FirebaseOptions(
    apiKey: 'AIzaSyBUPO0Uz_A34b0vvgNmlEkeNff89Z615B8',
    appId: '1:1013306379146:ios:a24930cd0b146a67b65673',
    messagingSenderId: '1013306379146',
    projectId: 'medsalesportal',
    databaseURL: 'https://medsalesportal.firebaseio.com',
    storageBucket: 'medsalesportal.appspot.com',
    androidClientId:
        'com.googleusercontent.apps.1013306379146-14hmg485d94l83kirhp50582i7vgpnhd',
    iosClientId:
        '1013306379146-14hmg485d94l83kirhp50582i7vgpnhd.apps.googleusercontent.com',
    iosBundleId: 'com.kolon.medsalesportaldev',
  );

  static const FirebaseOptions macosDev = FirebaseOptions(
    apiKey: 'AIzaSyBUPO0Uz_A34b0vvgNmlEkeNff89Z615B8',
    appId: '1:1013306379146:ios:e1f0465e9bdc0499b65673',
    messagingSenderId: '1013306379146',
    projectId: 'medsalesportal',
    databaseURL: 'https://medsalesportal.firebaseio.com',
    storageBucket: 'medsalesportal.appspot.com',
    androidClientId:
        '406099696497-tvtvuiqogct1gs1s6lh114jeps7hpjm5.apps.googleusercontent.com',
    iosClientId:
        '1013306379146-q3mthqstu5fggas3re6ca3hjrerbn3cg.apps.googleusercontent.com',
    iosBundleId: 'com.kolon.medsalesportal',
  );
  static const FirebaseOptions android = FirebaseOptions(
    appId: '1:1013306379146:android:8dd20aad5e4f646b',
    apiKey: 'AIzaSyCnrGBmoyFwfYBXkTF9T-nlzkXWY2_KCk0',
    projectId: 'medsalesportal',
    messagingSenderId: '1013306379146',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBUPO0Uz_A34b0vvgNmlEkeNff89Z615B8',
    appId: '1:1013306379146:ios:e1f0465e9bdc0499b65673',
    messagingSenderId: '1013306379146',
    projectId: 'medsalesportal',
    databaseURL: 'https://medsalesportal.firebaseio.com',
    storageBucket: 'medsalesportal.appspot.com',
    androidClientId:
        'com.googleusercontent.apps.1013306379146-q3mthqstu5fggas3re6ca3hjrerbn3cg',
    iosClientId:
        '1013306379146-q3mthqstu5fggas3re6ca3hjrerbn3cg.apps.googleusercontent.com',
    iosBundleId: 'com.kolon.medsalesportal',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBUPO0Uz_A34b0vvgNmlEkeNff89Z615B8',
    appId: '1:1013306379146:ios:e1f0465e9bdc0499b65673',
    messagingSenderId: '1013306379146',
    projectId: 'medsalesportal',
    databaseURL: 'https://medsalesportal.firebaseio.com',
    storageBucket: 'medsalesportal.appspot.com',
    androidClientId:
        '406099696497-tvtvuiqogct1gs1s6lh114jeps7hpjm5.apps.googleusercontent.com',
    iosClientId:
        '1013306379146-q3mthqstu5fggas3re6ca3hjrerbn3cg.apps.googleusercontent.com',
    iosBundleId: 'com.kolon.medsalesportal',
  );
}
