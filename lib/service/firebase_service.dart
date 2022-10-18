// /*
//  * Project Name:  [mKolon3.0] - MedicalSalesPortal
//  * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/service/firebase_service.dart
//  * Created Date: 2022-10-18 15:55:12
//  * Last Modified: 2022-10-18 15:55:12
//  * Author: bakbeom
//  * Modified By: 
//  * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
//  * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
//  * 												Discription													
//  * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
//  */




// class FirebaseService {
//   factory FirebaseService() => _sharedInstance();
//   static FirebaseService? _instance;
//   FirebaseService._();
//   static FirebaseService _sharedInstance() {
//     _instance ??= FirebaseService._();
//     return _instance!;
//   }

//   static NotificationSettings? notiSettings;
//   static FirebaseAnalytics? analytics;
//   static FirebaseAnalyticsObserver? observer;
//   static FirebaseMessaging? messaging;
//   static FirebaseDynamicLinks? dynamicLink;
//   static FirebaseOptions firebaseOptions = const FirebaseOptions(
//     appId: '1:945768705330:ios:127d343464648114b2bb2b',
//     apiKey: 'AIzaSyCXFavhu_ovKNi6_7Ag1Qy-0IiNSeWDnLM',
//     projectId: 'ticketoffice-fb',
//     messagingSenderId: '945768705330',
//   );
//   static bool isPermissed = false;
//   static String fcmTocken = '';
//   static Stream<String>? fcmRefreshTokenStream;
//   static Stream<RemoteMessage>? messageStream;
//   static Stream<RemoteMessage>? openMessageStream;
//   //초기화  --> 앱이 첫실행시 한번만 호출
//   static Future<void> init() async {
//     // Firebase.apps.clear();
//     if (Firebase.apps.isEmpty) {
//       pr('firebaseApp length::: ${Firebase.apps.length}');
//       await Future.delayed(Duration.zero, () async {
//         await Firebase.initializeApp(
//           name: 'ticketoffice-fb',
//           options: firebaseOptions,
//         ).then((app) => pr(' name:: ${app.name}    option::${app.options}'));
//       }).then((_) async {
//         analytics = FirebaseAnalytics.instance;
//         observer = FirebaseAnalyticsObserver(analytics: analytics!);
//         messaging = FirebaseMessaging.instance;
//         dynamicLink = FirebaseDynamicLinks.instance;
//         fcmRefreshTokenStream = messaging!.onTokenRefresh;
//         messageStream = FirebaseMessaging.onMessage;
//         openMessageStream = FirebaseMessaging.onMessageOpenedApp;
//         pr(messaging?.isAutoInitEnabled);
//         pr(dynamicLink?.app.name);
//         pr(analytics?.app.name);
//         _requstFcmPermission();
//       });
//     }
//   }

//   static Future<void> _requstFcmPermission() async {
//     await messaging!.requestPermission().then((settings) async {
//       setNotiSettings(settings);
//       if (settings.authorizationStatus == AuthorizationStatus.authorized) {
//         getToken().then((token) => pr(token));
//       }
//     });
//   }

//   static void addListennr() {
//     FirebaseMessaging.onBackgroundMessage(backgroundCallback);
//     startDynamicLinkListenner();
//     startFirebaseMessageListenner();
//   }

//   static Future<void> backgroundCallback(RemoteMessage message) async {
//     pr(message);
//     // dosomething. background mode
//     pr('in back ground mode.');
//   }

//   static Future<void> setIOSNoticeOption() async {
//     if (Platform.isIOS) {
//       await FirebaseMessaging.instance
//           .setForegroundNotificationPresentationOptions(
//         alert: true,
//         badge: true,
//         sound: true,
//       );
//     }
//   }

//   static void setNotiSettings(NotificationSettings settings) {
//     notiSettings = settings;
//   }

//   static void sendTokenToServer(String? token) {
//     bool? isLogedin;
//     if (isLogedin != null && isLogedin) {
//       ConfigProvider().sendFcmToken();
//     } else {
//       // do not send fcmToken;
//     }
//   }

//   static Future<void> openWebView(model) async {
//     final op = KeyService.baseAppKey.currentContext!.read<OauthProvider>();
//     final ticketProvider =
//         KeyService.baseAppKey.currentContext!.read<TicketProvider>();
//     if (op.isLogedin != null && op.isLogedin!) {
//       Platform.isAndroid
//           ? ticketProvider.openTicketDetail(
//               KeyService.baseAppKey.currentContext!, model.playNum, model.name!,
//               goodsModel: model)
//           : ticketProvider.openTicketDetailForIos(
//               KeyService.baseAppKey.currentContext!,
//               model.playNum!,
//               model.name!,
//               goodsModel: model);
//     } else {
//       AppDialog.needLogin(KeyService.baseAppKey.currentContext!);
//     }
//   }

//   static changeJsonType(json, DynamicLinkType type) {
//     pr(json);
//     json['id'] =
//         json['id'] == null || json['id'].isEmpty ? null : int.parse(json['id']);
//     json['play_num'] = json['play_num'] == null || json['play_num'].isEmpty
//         ? null
//         : int.parse(json['play_num']);
//     json['age_limit'] =
//         json['age_limit'] == null || json['age_limit'].trim().isEmpty
//             ? null
//             : int.parse(json['age_limit']);
//     json['label_id'] =
//         json['label_id'] == null || json['label_id'].trim().isEmpty
//             ? null
//             : int.parse(json['label_id']);
//     json['order'] = json['order'] == null || json['order'].trim().isEmpty
//         ? null
//         : int.parse(json['order']);
//     json['reserve_cnt'] =
//         json['reserve_cnt'] == null || json['reserve_cnt'].trim().isEmpty
//             ? null
//             : int.parse(json['reserve_cnt']);
//     json['price'] = json['price'] == null || json['price'].trim().isEmpty
//         ? null
//         : double.parse(json['price']);
//     json['org_price'] =
//         json['org_price'] == null || json['org_price'].trim().isEmpty
//             ? null
//             : double.parse(json['org_price']);
//     type == DynamicLinkType.GOODS || type == DynamicLinkType.MUSICAL
//         ? json['thumb_image'] = []
//         : DoNothingAction();
//     return json;
//   }

//   static List<String> routeList = [
//     EventDetailPage.routeName,
//     FeedsDetailPage.routeName,
//     HotClipDetailPage.routeName,
//     WebViewPage.routeName,
//   ];
//   static Future<void> _parseDeepLink(Uri uri) async {
//     pr(uri.toString());
//     const baseUrl = 'https://mticketoffice.page.link/';
//     var tempList = uri
//         .toString()
//         .substring(uri.toString().indexOf(baseUrl) + baseUrl.length)
//         .split('/');
//     final enumName = tempList.first;
//     switch (enumName) {
//       case 'FEED':
//         var subStrData = '/FEED/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         final json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         final model = FeedModel(id: int.parse(json['id']));
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         Navigator.pushNamed(
//             KeyService.baseAppKey.currentContext!, FeedsDetailPage.routeName,
//             arguments: model);
//         break;
//       case 'HOTCLIPS':
//         var subStrData = '/HOTCLIPS/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         final json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         var temp = HotClipDetailDataModel.fromJson(json);
//         // 데이터 전화 , 동영상세트에 mainTitle 1개만 들어있어 번거로운 작업을 하고 있다.
//         var model = HotClipVideoModel(int.parse(temp.recId!), DateTime.now(),
//             temp.imagePath, temp.mainTitle, temp.url);
//         final listModel = HotClipListItemModel(model.id, [model], model.title);
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         Navigator.pushNamed(
//             KeyService.baseAppKey.currentContext!, HotClipDetailPage.routeName,
//             // model에 mainTitle 있다.
//             arguments: {'model': listModel, 'index': 0});
//         break;
//       case 'EVENT':
//         var subStrData = '/EVENT/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         final json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         final model = EventModel(id: int.parse(json['id']));
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         Navigator.pushNamed(
//             KeyService.baseAppKey.currentContext!, EventDetailPage.routeName,
//             arguments: {
//               'eventNumber': model.id,
//               'eventDetailPageType': EventDetailPageType.DEFAULT
//             });
//         break;
//       // ------------------------- web --------------------------
//       // ------------------------- web --------------------------
//       // ------------------------- web --------------------------
//       case 'GOODS':
//         var subStrData = '/GOODS/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         var json = EncodingUtils.decodeBase64ForDynamicLinkData(data);

//         popToFirst(KeyService.baseAppKey.currentContext!);
//         final model = StoreMusicalAndDataModel.fromJson(
//             changeJsonType(json, DynamicLinkType.GOODS));
//         await openWebView(model);
//         break;
//       case 'MUSICAL':
//         var subStrData = '/MUSICAL/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         var json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         final model = StoreMusicalAndDataModel.fromJson(
//             changeJsonType(json, DynamicLinkType.MUSICAL));
//         await openWebView(model);
//         break;
//       case 'HOME_MUSICAL':
//         var subStrData = '/HOME_MUSICAL/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         var json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         final model = StoreMusicalAndDataModel.fromJson(
//             changeJsonType(json, DynamicLinkType.HOME_MUSICAL));
//         await openWebView(model);
//         break;
//       case 'HOME_GOODS':
//         var subStrData = '/HOME_GOODS/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         var json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         final model = StoreMusicalAndDataModel.fromJson(
//             changeJsonType(json, DynamicLinkType.HOME_GOODS));
//         await openWebView(model);
//         break;

//       case 'CURATION':
//         var subStrData = '/CURATION/';
//         var data = uri.toString().substring(
//             uri.toString().lastIndexOf(subStrData) + subStrData.length);
//         var json = EncodingUtils.decodeBase64ForDynamicLinkData(data);
//         popToFirst(KeyService.baseAppKey.currentContext!);
//         final model = StoreMusicalAndDataModel.fromJson(
//             changeJsonType(json, DynamicLinkType.CURATION));
//         await openWebView(model);
//         break;
//       default:
//     }
//   }

//   static void checkDynamicLink() {
//     dynamicLink!.getInitialLink().then((data) {
//       if (data?.link != null) {
//         _parseDeepLink(data!.link);
//         pr('has dynamlink ::${data.link}');
//       }
//     });
//   }

//   // Start dynamic link listen !!
//   static void startDynamicLinkListenner() {
//     dynamicLink!.onLink.listen((data) {})
//       ..onData((data) {
//         _parseDeepLink(data.link);
//         pr('onDynamicLink data ${data.link}');
//       })
//       ..onDone(() {
//         pr('ddynamicLink data Load Done');
//       })
//       ..onError((e) {
//         AppToast()
//             .show(KeyService.baseAppKey.currentContext!, tr('another_error'));
//         pr('Error $e');
//       });
//     checkDynamicLink();
//   }

//   static Future<DynamicLinkParameters> _buildParameters(
//       String routeName,
//       Map<String, dynamic> map,
//       String imageUrl,
//       String title,
//       String description) async {
//     final DynamicLinkParameters parameters = DynamicLinkParameters(
//         uriPrefix: AppConfig.DEEP_LINK_PREFIX_DOMAIN,
//         link: Uri.parse(
//             '${AppConfig.DEEP_LINK_PREFIX_DOMAIN}/$routeName/${await EncodingUtils.base64ConvertForDynamicLink(map)}'),
//         androidParameters: AndroidParameters(
//           packageName: AppConfig.APP_PACKAGE_NAME,
//           minimumVersion: AppConfig.DYNAMIC_LINK_MIN_VERSION_FOR_ANDROID,
//         ),
//         iosParameters: IOSParameters(
//             bundleId: AppConfig.APP_PACKAGE_NAME,
//             minimumVersion: AppConfig.DYNAMIC_LINK_MIN_VERSION_FOR_IOS,
//             appStoreId: AppConfig.APP_STORE_ID),
//         socialMetaTagParameters: SocialMetaTagParameters(
//             imageUrl: imageUrl.isNotEmpty ? Uri.parse(imageUrl) : null,
//             title: title,
//             description: description));
//     return parameters;
//   }

//   static Future<Uri> createDynamicLink(
//       DynamicLinkType type, dynamic model) async {
//     switch (type) {
//       case DynamicLinkType.FEED:
//         model as FeedModel;
//         // dynimicLink param length 제한때문에 파싱 할 데이터 용량 조절한다.
//         model.contents = model.contents != null && model.contents!.length > 30
//             ? model.contents!.substring(0, 30)
//             : model.contents!;
//         if (model.articleMedias!.length > 1) {
//           var temp = model.articleMedias!.take(1).toList();
//           model.articleMedias = temp;
//         }
//         var isVedio =
//             model.url!.contains('youtube') || model.url!.contains('youte.be');
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.FEED),
//             model.toJson(),
//             isVedio
//                 ? AppConfig.FEED_CDN + model.storageThumbnailUrl!
//                 : AppConfig.FEED_CDN + model.articleMedias!.first.storageUrl!,
//             model.title!,
//             model.contents!);
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.HOME_GOODS:
//         model as GoodsModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.HOME_GOODS),
//             model.toJson(),
//             model.coverImage!,
//             model.name!,
//             '');
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.HOME_MUSICAL:
//         model as ProductsModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.HOME_MUSICAL).toUpperCase(),
//             model.toJson(),
//             model.coverImage!,
//             model.name!,
//             '');
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.GOODS:
//         model as StoreMusicalAndDataModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.GOODS).toUpperCase(),
//             model.toJson(),
//             model.coverImage!,
//             model.name!,
//             '');
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.MUSICAL:
//         model as StoreMusicalAndDataModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.MUSICAL).toUpperCase(),
//             model.toJson(),
//             model.coverImage!,
//             model.name!,
//             '');
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.HOTCLIPS:
//         model as HotClipDetailDataModel;
//         if (model.contents != null && model.contents!.length > 30) {
//           model.contents = model.contents!.substring(0, 30);
//         }
//         model.recommend = [];
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.HOTCLIPS).toUpperCase(),
//             model.toJson(),
//             model.imagePath!,
//             model.title!,
//             DateFormatUtil.toStr(model.date!));
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.EVENT:
//         model as EventModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.EVENT).toUpperCase(),
//             model.toJson(),
//             model.imagePath!,
//             model.name!,
//             model.content!);
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//       case DynamicLinkType.CURATION:
//         model as CuratedContentsItemModel;
//         var param = await _buildParameters(
//             describeEnum(DynamicLinkType.CURATION).toUpperCase(),
//             model.toJson(),
//             model.imagePath!,
//             model.name!,
//             '');
//         final sLink = await dynamicLink?.buildShortLink(param);
//         return sLink!.shortUrl;
//     }
//   }

//   static Future<String?> getToken() async {
//     return messaging!.getToken();
//   }

//   static Future<void> startFirebaseMessageListenner() async {
//     await setIOSNoticeOption();
//     fcmRefreshTokenStream!.listen((newToken) async {
//       pr("fcm 토큰 갱신 ---> $newToken");
//       fcmTocken = newToken;
//       //? if logedin  sendTokenToServer(token);
//     });
//     messageStream!.listen((message) {
//       pr('ok');
//       var notification = message.notification;
//       pr(notification);
//       pr(message);
//       pr(message.notification!.apple);
//       var android = message.notification?.android;
//       var ios = message.notification?.apple;
//       if (notification != null && android != null && !kIsWeb) {
//         pr(message.data);
//         pr(message.messageId);
//         pr(message.messageId);
//         pr(message.messageId);
//         // send data to globle message provider
//       } else if (notification != null && ios != null && !kIsWeb) {
//         // ios push notice ui show
//         // send data to globle message provider
//       }
//     });

//     openMessageStream!.listen((message) {
//       // on open push notice Event added!
//       // route to contents page.
//     });
//   }

//   static Future<void> firebaseUserLogout() async {
//     return await FirebaseAuth.instance.signOut();
//   }
// }
