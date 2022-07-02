/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/kolonApp.dart
 * Created Date: 2022-07-02 14:46:59
 * Last Modified: 2022-07-02 17:00:42
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:medsalesportal/router.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:medsalesportal/service/navigator_service.dart';
import 'package:medsalesportal/view/common/provider/app_theme_provider.dart';
import 'package:medsalesportal/view/common/provider/water_marke_provider.dart';
import 'package:medsalesportal/view/commonLogin/common_login_page.dart';
import 'package:medsalesportal/view/commonLogin/provider/notice_index_provider.dart';
import 'package:medsalesportal/view/settings/provider/settings_provider.dart';
import 'package:provider/provider.dart';

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
      ],
      child: MediaQuery(
          data: MediaQueryData.fromWindow(WidgetsBinding.instance.window),
          child: ScreenUtilInit(
              designSize: const Size(360, 690),
              minTextAdapt: true,
              builder: (context, _) => RepaintBoundary(
                    key: NavigationService.screenKey,
                    child: MaterialApp(
                        //FirebaseAnalytics 연동.
                        // navigatorObservers: [FirebaseService.observer!],
                        navigatorKey: NavigationService.kolonAppKey,
                        localizationsDelegates: context.localizationDelegates,
                        supportedLocales: context.supportedLocales,
                        locale: context.locale,
                        debugShowCheckedModeBanner: false,
                        theme: context.read<AppThemeProvider>().themeData,
                        home: CommonLoginPage(),
                        routes: routes),
                  ))),
    );
  }
}
