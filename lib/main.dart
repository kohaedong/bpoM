import 'package:bpom/kolonApp.dart';
import 'package:bpom/service/cache_service.dart';
import 'package:bpom/service/screen_capture_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_device_type/flutter_device_type.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Hive.initFlutter();
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

  if(Device.get().isTablet){
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
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
  } else {
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

}
