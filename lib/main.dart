import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bpom/kolonApp.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/service/firebase_service.dart';
import 'package:bpom/service/screen_capture_service.dart';
import 'package:bpom/model/commonCode/t_code_model.dart';
import 'package:bpom/model/commonCode/t_values_model.dart';
import 'package:bpom/model/commonCode/et_dd07v_customer_category_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  // await FirebaseService.init();
  //Hive.registerAdapter(TCodeModelAdapter());
  //Hive.registerAdapter(TValuesModelAdapter());
  //Hive.registerAdapter(TCustomerCustomsModelAdapter());
  ScreenCaptrueService.startListener();
  CacheService.init();
  setSystemOverlay();
  start();
}

void setSystemOverlay() {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
}

void start() async {
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      EasyLocalization(
        supportedLocales: const [Locale("ko")],
        path: "assets/location",
        fallbackLocale: const Locale("ko"),
        child: const KolonApp(),
      ),
    );
  });
}
