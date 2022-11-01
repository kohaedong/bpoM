/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/firebase_service.dart
 * Created Date: 2022-10-18 15:55:12
 * Last Modified: 2022-11-01 15:53:09
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/globalProvider/login_provider.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/styles/app_colors.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'dart:async';
import 'package:provider/provider.dart';
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
  static late FirebaseMessaging messaging;
  static late Stream<String> fcmTokenStream;
  static late Stream<RemoteMessage> messageStream;
  static late Stream<RemoteMessage> openMessageStream;
  static late StreamSubscription<String> tockenSubscription;
  static late StreamSubscription<RemoteMessage> messageSubscription;
  static late StreamSubscription<RemoteMessage> openMessageSubscription;
  static late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  static final initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      iOS: DarwinInitializationSettings(
        requestSoundPermission: true,
        requestBadgePermission: true,
        requestAlertPermission: true,
      ));
  static const channelId = 'kolon_medsalesportaldev';
  static final channel = AndroidNotificationChannel(
    channelId, // id
    '??? title ?', // title
    description: 'ok this is description', // description
    importance: Importance.high,
  );
  //초기화  --> 앱이 첫실행시 한번만 호출
  static Future<bool> init() async {
    await initLocalNotifacation();
    await Firebase.initializeApp(
            name: 'medsalesportal',
            options: DefaultFirebaseOptions.currentPlatform)
        .then((firebaseApp) async {
      await Future.delayed(Duration(milliseconds: 300), () {
        messaging = FirebaseMessaging.instance;
        messageStream = FirebaseMessaging.onMessage;
        fcmTokenStream = messaging.onTokenRefresh;
        openMessageStream = FirebaseMessaging.onMessageOpenedApp;
      });
      // await requstFcmPermission();
    });
    return true;
  }

  static Future<bool> requstFcmPermission() async {
    var isSuccessful = true;
    await messaging.requestPermission().then((settings) async {
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        pr(settings.toString());
        pr('permission ok');
      } else {
        isSuccessful = false;
        pr('permission failed');
      }
    }).catchError((e) {
      pr(e);
    });
    return isSuccessful;
  }

  @pragma('vm:entry-point')
  static Future<void> backgroundCallback(RemoteMessage message) async {
    pr('백그라운드 ${message.data}');
    pr('in back ground mode.');
  }

  static Future<void> setNoticeOption() async {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
            alert: true, badge: true, sound: true);
  }

  static Future<String?> getToken() async {
    var token = await messaging.getToken();
    return token;
  }

  static Future<void> initLocalNotifacation() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
    if (Platform.isAndroid) {
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()!
          .requestPermission();
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
      pr('?????? ${message}');
      pr('category ${message.category}');
      pr('collapseKey ${message.collapseKey}');
      pr('contentAvailable ${message.contentAvailable}');
      pr('data ${message.data}');
      pr('from ${message.from}');
      pr('messageId ${message.messageId}');
      pr('messageType ${message.messageType}');
      pr('mutableContent ${message.mutableContent}');
      pr('notification ${message.notification}');
      pr('senderId ${message.senderId}');
      pr('sentTime ${message.sentTime}');
      pr('threadId ${message.threadId}');
      pr('ttl ${message.ttl}');
      var notification = message.notification;
      if (Platform.isAndroid) {
        var title = message.data['jsonMessage']['title'];
        var body = message.data['jsonMessage']['message'];
        await flutterLocalNotificationsPlugin.show(
          notification != null ? notification.hashCode : title.hashCode,
          notification?.title,
          notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              title,
              channelDescription: body,
              // icon: 'launch_background',
            ),
          ),
        );
      }
    });

    openMessageSubscription = openMessageStream.listen((message) {
      pr('on open!!!! ${message.data}');
      // on message tap event
    });
    FirebaseMessaging.onBackgroundMessage(backgroundCallback);
    if (await FirebaseMessaging.instance.isSupported()) {
      pr('FirebaseMessaging is successful!!');
    }
    await getToken();
  }

  static Future<void> dodo() async {
    const channelId = 'kolon_medsalesportaldev';
    var title = '제약영업';
    var body = '제약영업포탈 푸시테스트 ????';
    var channel = AndroidNotificationChannel(
      channelId, // id
      title, // title
      description: body, // description
      importance: Importance.high,
    );
    await flutterLocalNotificationsPlugin.show(
      title.length > 5 ? title.hashCode : body.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(channel.id, title,
            channelDescription: body,
            icon: '@drawable/push_icon',
            color: AppColors.primary),
      ),
    );
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
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
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
