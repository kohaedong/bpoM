import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:bpom/enums/image_type.dart';
import 'package:bpom/enums/update_and_notice_check_type.dart';
import 'package:bpom/globalProvider/login_provider.dart';
import 'package:bpom/styles/export_common.dart';
import 'package:bpom/view/common/base_app_toast.dart';
import 'package:bpom/view/common/base_layout.dart';
import 'package:bpom/view/common/fuction_of_check_working_time.dart';
import 'package:bpom/view/commonLogin/update_and_notice_dialog.dart';
import 'package:bpom/view/settings/settings_page.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:provider/provider.dart';
import 'package:webview_flutter/webview_flutter.dart';

import './home_icon_map.dart';
import '../../buildConfig/kolon_build_config.dart';
import '../../model/user/user.dart';
import '../../service/cache_service.dart';
import '../../util/encoding_util.dart';
import '../attach/attach_page.dart';
import '../common/base_app_dialog.dart';

String? initUrl;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String routeName = '/home';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with WidgetsBindingObserver {
  var _isNoticeCheckDone = false;
  WebViewController? _webViewController;
  ScrollController? _scrollController;
  User? user;
  Timer? exitAppTimer;
  var showToast = true;
  String? userId;
  bool isLoading = false;
  late DateTime backbuttonpressedTime;

  //final _request = HttpRequest(API.BASE_URL);
  final Completer<WebViewController> _controller =
  Completer<WebViewController>();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    if (Platform.isAndroid) {
      disableCapture();
    }
    WidgetsBinding.instance.addObserver(this);

    user = CacheService.getUser();
    //var userId = 'kolonmobile@''${user?.userAccount}';
    //var hashCode = crypto.md5.convert(utf8.encode(userId)).toString();

    var datetimeFormatter = new DateFormat('yyyyMMddHHmmss');
    var curDateTime = datetimeFormatter.format(DateTime.now());

    var base64 = '$curDateTime' '@' '${user?.userAccount}';
    var encodingLoginInfor = EncodingUtils.encodeBase64(str: base64);
    initUrl = '${KolonBuildConfig.BPO_URL}''$encodingLoginInfor';
    print('URL: $initUrl');

  }

  @override
  void dispose() {
    if (exitAppTimer != null) {
      exitAppTimer!.cancel();
    }
    _scrollController!.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<void> checkNoticeWhenLogedin() async {
    await Future.delayed(Duration.zero, () async {
      CheckUpdateAndNoticeService.check(context, CheckType.NOTICE_ONLY, true);
    }).then((value) => _isNoticeCheckDone = true);
  }

  Future disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState lifeCycle) async {
    super.didChangeAppLifecycleState(lifeCycle);
  }

  Widget buildIconRow(List<ImageType> list, List<String> testList) {
    return Padding(
        padding: AppSize.homeIconBoxSidePadding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ...list.asMap().entries.map((map) {
              return InkWell(
                onTap: () async {
                  setActionTime();
                  if (map.value == ImageType.EMPTY) {
                    AppToast().show(context, 'this is ImageType.EMPTY');
                  } else {
                    if (map.value.routeName == '') {
                      if (isNotWoringTime()) {
                        showWorkingTimePopup(contextt: context);
                      } else {
                        final lp = context.read<LoginProvider>();
                        if (!lp.isPermidedSalseGroup) {
                          AppToast()
                              .show(context, '${tr('permission_denied')}');
                        } else {
                          Navigator.pushNamed(context, map.value.routeName);
                        }
                      }
                    } else {
                      Navigator.pushNamed(context, map.value.routeName);
                    }
                  }
                },
                child: Column(
                  children: [
                    Container(
                      height: AppSize.homeIconHeight,
                      width: AppSize.homeIconHeight,
                      child: AppImage.getImage(list[map.key]),
                    ),
                    Container(
                      alignment: Alignment.center,
                      height: AppSize.homeIconTextHeight,
                      width: AppSize.homeIconTextWidth,
                      child: map.value == ImageType.EMPTY
                          ? Container()
                          : AppText.text('${testList[map.key]}',
                              style: AppTextStyle.sub_14),
                    ),
                  ],
                ),
              );
            }).toList(),
          ],
        ));
  }

  Widget buildIcons() {
    return Container(
        height: (AppSize.homeIconHeight * 2) +
            (AppSize.homeIconTextHeight) * 2 +
            AppSize.homeTopPadding * 2,
        color: AppColors.whiteText,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: AppSize.homeTopPadding),
              child: buildIconRow(homeIconsListOne, homeIconsListOneText),
            ),
            buildIconRow(homeIconsListTow, homeIconsListTowText),
          ],
        ));
  }

  AppBar buildHomeAppBar() {
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
              child: AppText.text('BPO', style: AppTextStyle.blod30),
            ),
          ),
          InkWell(
              onTap: () async {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
              child: Padding(
                padding: EdgeInsets.only(right: AppSize.padding),
                child: SizedBox(
                    height: AppSize.homeAppBarSettingIconHeight,
                    child: AppImage.getImage(ImageType.SETTINGS_ICON)),
              ))
        ],
      ),
    );
  }

  Future<bool> _goBack(BuildContext context) async {
    if (_webViewController == null) {
      return true;
    }
    if (await _webViewController!.canGoBack()) {
      _webViewController!.goBack();
      return Future.value(false);
    } else {
      if (exitAppTimer == null) {
        exitAppTimer = Timer(Duration(seconds: 3), () {});
        AppToast().show(context, '${tr('ext_app_when_tap_again')}');
      } else {
        if (exitAppTimer!.isActive) {
          exit(0);
        } else {
          exitAppTimer = Timer(Duration(seconds: 3), () {});
          AppToast().show(context, '${tr('ext_app_when_tap_again')}');
        }
      }
      return false;
    }
  }

  JavascriptChannel _toasterJavascriptChannel(BuildContext context) {
    /// fid=test&filePath=http://ndeviken.kolon.com/data/brochure/KOLON_Brochure_Korean.pdf
    return JavascriptChannel(
        name: 'webToAppKolon',
        onMessageReceived: (JavascriptMessage message) async {
          //Scaffold.of(context).showSnackBar(SnackBar(content: Text(message.message)),);
          await attachRequest(message.message);
        });
  }

  // 첨부파일 변환 요청 API 호출
  Future<void> attachRequest(String? str) async {
    int? pos = str?.lastIndexOf(".");
    String? ext = str?.substring(pos! + 1);

    bool exists = await _checkAttachExt(ext!);
    if (!exists) {
      AppDialog.showSignglePopup(context, '${tr('no_support_attach')}');
    } else {
      var _filePath = '${KolonBuildConfig.ATTACH_BASE_URL}' '$str';
      var dio = Dio();
      final response = await dio.get(_filePath);
      print(response.data);
      var attachKey = response.data['key'];
      // 첨부파일 웹뷰 화면 호출
      Navigator.pushNamed(context, AttachPage.routeName, arguments: {'key': attachKey});
    }
  }

  Future<bool> _checkAttachExt(String strExt) async {
    switch(strExt.toUpperCase()) {
      case "HTML": case "MHT": case "MHML": case "HWP": case "HML": case "HWX":case "DOCX": case "DOCM": case "DOTM": case "PPTX":
      case "PPTM": case "POTX": case "POTM": case "PPSX": case "THMX": case "XLSX": case "XLSM": case "XLTX": case "XLTM": case "XLSB":
      case "DOC": case "DOT": case "DOTX": case "PPT": case "POT": case "PPS": case "XLS": case "XLT": case "TXT": case "CSV": case "XML":
      case "BMP": case "GIF": case "JPEG": case "JPG": case "PNG": case "TIFF": case "ODT": case "PDF":
      break;
      default:
        return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => _goBack(context),
      child: BaseLayout(
        hasForm: false,
        bgColog: AppColors.homeBgColor,
        //appBar: buildHomeAppBar(),
        child: Scaffold(
        backgroundColor: Colors.white,
        bottomNavigationBar: BottomAppBar(
          child: NavigationControls(_controller.future),
        ),
        body: SafeArea(
          child: Builder(builder: (BuildContext context) {
            return Stack(
              children: <Widget> [
                WebView(
                  initialUrl: initUrl,
                  // zoomEnabled: false,
                  javascriptMode: JavascriptMode.unrestricted,
                  onWebViewCreated: (WebViewController webViewController) {
                    _controller.future.then((value) => _webViewController = value);
                    _controller.complete(webViewController);
                  },
                  onProgress: (int progress) {
                    print('WebView is loading (progress : $progress%)');
                  },
                  javascriptChannels: <JavascriptChannel>{
                    _toasterJavascriptChannel(context),
                  },
                  navigationDelegate: (NavigationRequest request) {
                    if (request.url.startsWith('https://www.youtube.com/')) {
                      print('blocking navigation to $request}');
                      return NavigationDecision.prevent;
                    }
                    print('allowing navigation to $request');
                    return NavigationDecision.navigate;
                  },
                  onPageStarted: (value) {setState(() {
                    isLoading = true;
                  });
                  },
                  onPageFinished: (value) {setState(() {
                    isLoading = false;
                  });
                  },
                  gestureNavigationEnabled: true,
                  backgroundColor: const Color(0x00000000),
                ),
                isLoading ? Center(child: CircularProgressIndicator(),) : Stack(),
              ],
            );
          }),
        ),
      ),
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController? controller = snapshot.data;
        return ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            ElevatedButton(
              child: const Icon(Icons.arrow_back),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                controller?.goBack();
              },
            ),
            ElevatedButton(
              child: const Icon(Icons.arrow_forward),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                controller?.goForward();
              },
            ),
            ElevatedButton(
              child: const Icon(Icons.refresh),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                controller?.reload();
              },
            ),
            ElevatedButton(
              child: const Icon(Icons.settings),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
              ),
              onPressed: () {
                Navigator.pushNamed(context, SettingsPage.routeName);
              },
            ),
          ],
        );
      },
    );
  }
}
