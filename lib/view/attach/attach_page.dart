import 'dart:async';
import 'dart:io';

import 'package:bpom/styles/app_text_style.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../buildConfig/kolon_build_config.dart';
import '../../styles/app_colors.dart';
import '../../styles/app_size.dart';
import '../../styles/app_text.dart';

class AttachPage extends StatefulWidget {
  const AttachPage({Key? key}) : super(key: key);
  static const String routeName = '/attach';
  @override
  _AttachPageState createState() => _AttachPageState();
}

class _AttachPageState extends State<AttachPage> {
  WebViewController? _webViewController;
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String? _sUrl;

  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) {
      disableCapture();
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.dispose();
  }

  AppBar buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.whiteText,
      titleSpacing: 0,
      toolbarHeight: AppSize.appBarHeight,
      automaticallyImplyLeading: false,
      elevation: 0,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: EdgeInsets.only(left: AppSize.padding),
            child: Align(
              alignment: Alignment.centerLeft,
              // 빌드옵션
              child: AppText.text('첨부파일', style: AppTextStyle.blod30),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final arguments = ModalRoute.of(context)!.settings.arguments;
    String? attachKey;
    if (arguments != null) {
      arguments as Map<String, dynamic>;
      attachKey = arguments['key'];
    }
    _sUrl =
        '${KolonBuildConfig.ATTACH_VIEW_URL}' '${attachKey}' '&contextPath=/SynapDocViewServer';

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
    ]);

    return BaseLayout(
      hasForm: true,
      appBar: buildAppBar(),
      child: Builder(builder: (BuildContext context) {
        return WebView(
          initialUrl: _sUrl,
          javascriptMode: JavascriptMode.unrestricted,
          onWebViewCreated: (WebViewController webViewController) {
            _controller.future.then((value) => _webViewController = value);
            _controller.complete(webViewController);
          },
          onProgress: (int progress) {
            print('WebView is loading (progress : $progress%)');
          },
          navigationDelegate: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              print('blocking navigation to $request}');
              return NavigationDecision.prevent;
            }
            print('allowing navigation to $request');
            return NavigationDecision.navigate;
          },
          onPageStarted: (String url) {
            print('Page started loading: $url');
          },
          onPageFinished: (String url) {
            print('Page finished loading: $url');
          },
          gestureNavigationEnabled: true,
          backgroundColor: const Color(0x00000000),
        );
      }),
    );
  }

  Future disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }
}
