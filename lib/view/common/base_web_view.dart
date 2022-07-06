/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/view/common/base_web_view.dart
 * Created Date: 2021-10-01 16:35:01
 * Last Modified: 2022-07-06 10:33:13
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 *                        Discription                         
 * ---  --- --- --- --- --- --- --- --- --- --- --- --- --- --- ---
 */

import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:medsalesportal/styles/export_common.dart';
import 'package:medsalesportal/view/common/widget_of_loading_view.dart';

class BaseWebView extends StatefulWidget {
  const BaseWebView(this.url, {Key? key}) : super(key: key);
  final String? url;

  @override
  State<BaseWebView> createState() => _BaseWebViewState();
}

class _BaseWebViewState extends State<BaseWebView> {
  @override
  void initState() {
    timer = Timer(const Duration(milliseconds: 800), () {
      swichShowWebView.value = true;
    });
    if (Platform.isAndroid) {
      AndroidInAppWebViewController.setWebContentsDebuggingEnabled(true);
    }
    super.initState();
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  Timer? timer;
  var swichShowWebView = ValueNotifier(false);
  late InAppWebViewController webViewController;
  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
      crossPlatform: InAppWebViewOptions(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          preferredContentMode: UserPreferredContentMode.MOBILE),
      android: AndroidInAppWebViewOptions(
        useHybridComposition: true,
      ),
      ios: IOSInAppWebViewOptions(
        allowsInlineMediaPlayback: true,
      ));

  Future<ContentsModel> initContents(String str, {double? scale}) async {
    if (str.startsWith('http')) {
      return ContentsModel(
          isStartWithHttp: true, isBase64: false, contents: str);
    } else if (str.startsWith('<html>')) {
      return ContentsModel(
          isStartWithHttp: false, isBase64: false, contents: str);
    } else {
      var temp = """<!DOCTYPE html>
    <html>
      <head><meta name="viewport" content="width=device-width, initial-scale=${scale != null ? '$scale' : '1.0'}"></head>
      <body style='"margin: 0; padding: 0;'>
        <div style="overflow:auto">
        $str
        </div>
      </body>
    </html>""";
      return ContentsModel(
          isStartWithHttp: false, isBase64: false, contents: temp);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ContentsModel>(
        future: initContents('${widget.url}'),
        builder: (context, snapshot) {
          if (snapshot.hasData &&
              snapshot.connectionState == ConnectionState.done) {
            return snapshot.data!.isStartWithHttp
                ? ValueListenableBuilder<bool>(
                    valueListenable: swichShowWebView,
                    builder: (context, swich, _) {
                      return Scaffold(
                          resizeToAvoidBottomInset: true,
                          appBar: null,
                          body: SingleChildScrollView(
                            child: Stack(
                              children: [
                                AnimatedOpacity(
                                  opacity: swich ? 1 : 0,
                                  duration: Duration(microseconds: 300),
                                  child: Container(
                                    width: AppSize.realWidth,
                                    height: AppSize.realHeight -
                                        AppSize.appBarHeight -
                                        AppSize.buttonHeight,
                                    child: InAppWebView(
                                      gestureRecognizers: Set()
                                        ..add(Factory<
                                                VerticalDragGestureRecognizer>(
                                            () =>
                                                VerticalDragGestureRecognizer())),
                                      initialUrlRequest: URLRequest(
                                        url: Uri.parse(
                                            '${snapshot.data!.contents}'),
                                      ),
                                      initialOptions: options,
                                      onWebViewCreated:
                                          (InAppWebViewController controller) {
                                        webViewController = controller;
                                      },
                                    ),
                                  ),
                                ),
                                Positioned(
                                    child: swich
                                        ? Container()
                                        : BaseLoadingViewOnStackWidget.build(
                                            context, true,
                                            color: AppColors.whiteText))
                              ],
                            ),
                          ));
                    })
                : ValueListenableBuilder<bool>(
                    valueListenable: swichShowWebView,
                    builder: (context, swich, _) {
                      return Scaffold(
                        body: Stack(
                          children: [
                            AnimatedOpacity(
                              opacity: swich ? 1 : 0,
                              duration: Duration(microseconds: 300),
                              child: InAppWebView(
                                  gestureRecognizers: Set()
                                    ..add(Factory<
                                            VerticalDragGestureRecognizer>(
                                        () => VerticalDragGestureRecognizer())),
                                  initialUrlRequest: URLRequest(
                                    url: Uri.dataFromString(
                                      '${snapshot.data!.contents}',
                                      mimeType: 'text/html',
                                      encoding: Encoding.getByName('UTF-8'),
                                    ),
                                  ),
                                  initialOptions: options),
                            ),
                            Positioned(
                                child: swich
                                    ? Container()
                                    : BaseLoadingViewOnStackWidget.build(
                                        context, true,
                                        color: AppColors.whiteText))
                          ],
                        ),
                      );
                    },
                  );
          }
          return BaseLoadingViewOnStackWidget.build(context, true,
              color: AppColors.whiteText);
        });
  }
}

class ContentsModel {
  String contents;
  bool isBase64;
  bool isStartWithHttp;
  ContentsModel(
      {required this.contents,
      required this.isBase64,
      required this.isStartWithHttp});
}
