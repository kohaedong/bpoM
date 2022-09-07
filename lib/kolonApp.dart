/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/kolonApp.dart
 * Created Date: 2022-07-02 14:46:59
 * Last Modified: 2022-09-07 15:08:43
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:medsalesportal/globalProvider/timer_provider.dart';
import 'package:medsalesportal/view/orderManager/order_manager_page.dart';

import 'service/key_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:medsalesportal/router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medsalesportal/globalProvider/app_theme_provider.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/globalProvider/water_marke_provider.dart';
import 'package:medsalesportal/view/settings/provider/settings_provider.dart';
import 'package:medsalesportal/view/commonLogin/provider/notice_index_provider.dart';

class KolonApp extends StatefulWidget {
  const KolonApp({Key? key}) : super(key: key);
  @override
  KolonAppState createState() => KolonAppState();
}

class KolonAppState extends State<KolonApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AppThemeProvider>(
          create: (context) => AppThemeProvider(),
        ),
        ChangeNotifierProvider<SettingsProvider>(
          create: (_) => SettingsProvider(),
        ),
        ChangeNotifierProvider<WaterMarkeProvider>(
          create: (_) => WaterMarkeProvider(),
        ),
        ChangeNotifierProvider<NoticeIndexProvider>(
          create: (_) => NoticeIndexProvider(),
        ),
        ChangeNotifierProvider<TimerProvider>(
          create: (_) => TimerProvider(),
        ),
      ],
      child: MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
          child: ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              builder: (context, _) => RepaintBoundary(
                    key: KeyService.screenKey,
                    child: MaterialApp(
                        //FirebaseAnalytics 연동.
                        // navigatorObservers: [FirebaseService.observer!],
                        navigatorKey: KeyService.baseAppKey,
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: context.locale,
                        debugShowCheckedModeBanner: false,
                        theme: context.read<AppThemeProvider>().themeData,
                        home: CommonLoginPage(),
                        // home: OrderManagerPage(),
                        routes: routes),
                  ))),
    );
  }
}
