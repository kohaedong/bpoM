/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/firebase_service.dart
 * Created Date: 2022-10-18 15:55:12
 * Last Modified: 2022-11-11 20:29:27
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:firebase_core/firebase_core.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

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
  static bool isSupptedBadge = false;
  static late FirebaseMessaging messaging;
  static late Stream<String> fcmTokenStream;
  static late Stream<RemoteMessage> messageStream;
  static late Stream<RemoteMessage> openMessageStream;
  static late StreamSubscription<String> tockenSubscription;
  static late StreamSubscription<RemoteMessage> messageSubscription;
  static late StreamSubscription<RemoteMessage> openMessageSubscription;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  static const channelId = 'kolon_medsalesportaldev';
  static final channel = AndroidNotificationChannel(channelId, '제약영업포탈');
  //초기화  --> 앱이 첫실행시 한번만 호출
  static Future<bool> init() async {
    await initLocalNotifacation();
    await Firebase.initializeApp(
            name: 'medsalesportal',
            options: DefaultFirebaseOptions.currentPlatform)
        .then((firebaseApp) async {
      await Future.delayed(Duration(milliseconds: 300), () async {
        messaging = FirebaseMessaging.instance;
        messageStream = FirebaseMessaging.onMessage;
        fcmTokenStream = messaging.onTokenRefresh;
        openMessageStream = FirebaseMessaging.onMessageOpenedApp;
        isSupptedBadge = await FlutterAppBadger.isAppBadgeSupported();
      });
    });
    return true;
  }

  static Future<bool> requstFcmPermission() async {
    var isSuccessful = true;
    await messaging.requestPermission().then((settings) async {
      isSuccessful =
          settings.authorizationStatus == AuthorizationStatus.authorized;
    }).catchError((e) {});
    return isSuccessful;
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(RemoteMessage message) async {
    //
    show(message);
  }

  static Future<void> setNoticeOption() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: isSupptedBadge, sound: true);
  }

  static Future<String?> getToken() async {
    var token = await messaging.getToken();
    return token;
  }

  @pragma('vm:entry-point')
  static void locakNotificationTapBackground(
      NotificationResponse notificationResponse) {
    // do something.
  }

  static Future<void> initLocalNotifacation() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettings = InitializationSettings(
        android: AndroidInitializationSettings('@drawable/push_icon'),
        iOS: DarwinInitializationSettings(
          requestSoundPermission: true,
          requestBadgePermission: isSupptedBadge,
          requestAlertPermission: true,
        ));
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        switch (notificationResponse.notificationResponseType) {
          case NotificationResponseType.selectedNotification:
            pr('selected');
            break;
          case NotificationResponseType.selectedNotificationAction:
            pr('taped action');
            break;
        }
      },
      onDidReceiveBackgroundNotificationResponse:
          locakNotificationTapBackground,
    );
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
    }
  }

  static void show(RemoteMessage? message) async {
    try {
      var str = message?.data['jsonMessage'] as String;
      str = str.trim();
      var map = EncodingUtils.jsonStrConvert(str);
      var title = map['title'];
      var body = map['message'];
      await flutterLocalNotificationsPlugin.show(
          channel.id.hashCode,
          title,
          body,
          NotificationDetails(
              android: AndroidNotificationDetails(
            channel.id,
            title,
            channelDescription: body,
            color: AppColors.primary,
            importance: Importance.max,
          )));
    } catch (e) {
      pr(e);
    }
  }

  static Future<void> startFirebaseMessageListenner() async {
    await setNoticeOption();
    await requstFcmPermission();

    tockenSubscription = fcmTokenStream.listen((newToken) async {
      pr("fcm 토큰 갱신 ---> $newToken");
      fcmTocken = newToken;
      final lp = KeyService.baseAppKey.currentContext!.read<LoginProvider>();
      lp.sendFcmToken();
    });
    messageSubscription = messageStream.listen((message) async {
      if (Platform.isAndroid) {
        show(message);
      }
    });
    openMessageSubscription = openMessageStream.listen((message) async {
      // on message tap event
      if (await FlutterAppBadger.isAppBadgeSupported()) {
        FlutterAppBadger.removeBadge();
      }
    });
    FirebaseMessaging.onBackgroundMessage(backgroundCallback);

    await getToken();
  }
}

class DefaultFirebaseOptions {
  static final isDev = (KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev');
  static FirebaseOptions get currentPlatform {
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return isDev ? androidDev : android;
      case TargetPlatform.iOS:
        return isDev ? iosDev : ios;
      default:
        throw UnsupportedError('firebase error');
    }
  }

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
}
