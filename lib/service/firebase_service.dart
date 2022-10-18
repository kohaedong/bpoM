/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/firebase_service.dart
 * Created Date: 2022-10-18 15:55:12
 * Last Modified: 2022-10-18 20:20:14
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';

class FirebaseService {
  factory FirebaseService() => _sharedInstance();
  static FirebaseService? _instance;
  FirebaseService._();
  static FirebaseService _sharedInstance() {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  static NotificationSettings? notiSettings;
  static FirebaseMessaging? messaging;
  static FirebaseOptions firebaseOptions = const FirebaseOptions(
    appId: '',
    apiKey: 'AIzaSyD0eYZcaqk0u_CS6TxvM108lcrl1Bqnsak',
    projectId: 'medsalesportal',
    messagingSenderId: '1013306379146',
  );
  static bool isPermissed = false;
  static String fcmTocken = '';
  static Stream<String>? fcmRefreshTokenStream;
  static Stream<RemoteMessage>? messageStream;
  static Stream<RemoteMessage>? openMessageStream;
  //초기화  --> 앱이 첫실행시 한번만 호출
  static Future<void> init() async {
    // Firebase.apps.clear();
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
              name: 'medsalesportal', options: firebaseOptions)
          .then((app) => pr(' name:: ${app.name}    option::${app.options}'))
          .whenComplete(() {
        messaging = FirebaseMessaging.instance;
        fcmRefreshTokenStream = messaging!.onTokenRefresh;
        messageStream = FirebaseMessaging.onMessage;
        openMessageStream = FirebaseMessaging.onMessageOpenedApp;
        pr(messaging?.isAutoInitEnabled);
        _requstFcmPermission();
      });
    }
  }

  static Future<void> _requstFcmPermission() async {
    await messaging!.requestPermission().then((settings) async {
      setNotiSettings(settings);
      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        getToken().then((token) => pr(token));
      }
    });
  }

  static void addListennr() {
    FirebaseMessaging.onBackgroundMessage(backgroundCallback);
    startFirebaseMessageListenner();
  }

  static Future<void> backgroundCallback(RemoteMessage message) async {
    pr(message);
    // dosomething. background mode
    pr('in back ground mode.');
  }

  static Future<void> setIOSNoticeOption() async {
    if (Platform.isIOS) {
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: true,
        badge: true,
        sound: true,
      );
    }
  }

  static void setNotiSettings(NotificationSettings settings) {
    notiSettings = settings;
  }

  static Future<String?> getToken() async {
    return messaging!.getToken();
  }

  static Future<void> startFirebaseMessageListenner() async {
    await setIOSNoticeOption();
    fcmRefreshTokenStream!.listen((newToken) async {
      pr("fcm 토큰 갱신 ---> $newToken");
      fcmTocken = newToken;
    });
    messageStream!.listen((message) {
      var notification = message.notification;
      pr(notification);
      pr(message);
      pr(message.notification!.apple);
      var android = message.notification?.android;
      var ios = message.notification?.apple;
      if (notification != null && android != null && !kIsWeb) {
        pr(message.data);
        pr(message.messageId);
        pr(message.messageId);
        pr(message.messageId);
        // send data to globle message provider
      } else if (notification != null && ios != null && !kIsWeb) {
        // ios push notice ui show
        // send data to globle message provider
      }
    });

    openMessageStream!.listen((message) {
      // on open push notice Event added!
      // route to contents page.
    });
  }
}
