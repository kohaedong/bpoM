import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:medsalesportal/kolonApp.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/util/screen_capture_util.dart';
import 'package:medsalesportal/model/commonCode/t_code_model.dart';
import 'package:medsalesportal/model/commonCode/t_values_model.dart';
import 'package:medsalesportal/model/commonCode/et_dd07v_customer_category_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TCodeModelAdapter());
  Hive.registerAdapter(TValuesModelAdapter());
  Hive.registerAdapter(TCustomerCustomsModelAdapter());
  startConnectivityListenner();
  startCaptrueListenner();
  initCacheService();
  setSystemOverlay();
  start();
}

void initCacheService() => CacheService.init();

void startCaptrueListenner() => ScreenCaptrueUtil.screenListen();

void startConnectivityListenner() {
  Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
    if (result == ConnectivityResult.none) {
      CacheService.saveNetworkState(false);
    } else {
      CacheService.saveNetworkState(true);
    }
  });
}

void setSystemOverlay() {
  SystemUiOverlayStyle systemUiOverlayStyle = const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.top]);
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
