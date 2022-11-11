/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/service/api_service.dart
 * Created Date: 2021-08-22 21:53:15
 * Last Modified: 2022-11-11 20:18:35
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'dart:io';
import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:medsalesportal/util/log_util.dart';
import 'package:medsalesportal/util/encoding_util.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/key_service.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/http/request_result.dart';
import 'package:medsalesportal/service/deviceInfo_service.dart';
import 'package:medsalesportal/service/local_file_servicer.dart';
import 'package:medsalesportal/globalProvider/connect_status_provider.dart';
// * 서버 에러 statusCode -1 으로 리턴.
// * 넷트워크 에러 statusCode  99 으로  리턴.
//*  기타 에러 statusCode 0 으로 리턴.

typedef HttpSuccessCallback<T> = void Function(dynamic data);

typedef DownLoadCallBack = Function(int, int);
_parseAndDecode(String response) {
  return jsonDecode(response);
}

parseJson(String text) {
  return compute(_parseAndDecode, text);
}

class ApiService {
  // * error 발생시 Request 즉시 중단 하기 위해 모든 Request에  [CancelToken] 걸어 준다.
  Map<String, CancelToken?> _cancelTokens = Map<String, CancelToken?>();

  //* 모든 요청은 [RequestType]에 사전 등록 한여 [init]에서 RequestType 을 초기화 한다.
  RequestType? requestType;
  //* 로그 출력여부.
  final isWithLog = false;
  //* JWT 토큰 사용시 서버와 협의하여 결정 하는 내용 입니다.
  //* 보통은 id + pw 조합으로  많이 사용한다.
  //* 영업포탈에는 토큰을 사용하는 api가 없다. 향후 사용 대비 예제 뿐이다.
  final String _clientID = 'default';
  final String _clientSecret = 'secret';
  List<Cookie>? responseCookies;
  List<Cookie>? requestcookies;

  //* 사용자 휴대폰 넷트워크 연결 장애 여부 구분자.
  bool isNetworkError = false;

  // * Dio Singleton
  Dio? _client;
  Dio get client => _client!;
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    if (_client == null) {
      // * Dio BaseOptions 추가.
      final _baseOption = BaseOptions(
          connectTimeout: 50000,
          receiveTimeout: 50000,
          sendTimeout: 50000,
          contentType: 'application/json');
      //* Dio 초기화.
      _client = Dio(_baseOption)
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest: onRequestWrapper,
            onResponse: onResponseWrapper,
            onError: onErrorWrapper,
          ),
        );
      //*  서버에서 보내온 데이터를 100% 리얼 JSON 으로 바꿔주기.
      //*  코오롱 서버에는 JSON데이터를 보내주고 있습니다.
      (_client!.transformer as DefaultTransformer).jsonDecodeCallback =
          parseJson;
    }
  }

  void init(RequestType type) async {
    requestType = type;
  }

  onRequestWrapper(
      RequestOptions options, RequestInterceptorHandler handler) async {
    final deviceInfo = await DeviceInfoService.getDeviceInfo();
    final header = {
      'deviceSerialNo': deviceInfo.deviceId,
      'deviceModelNo': deviceInfo.deviceModel,
      'appId': Platform.isIOS ? '80' : '79',
    };
    final anotherHeader = await requestType!.anotherHeader;
    options.headers.addAll(header);
    if (anotherHeader.isNotEmpty) {
      options.headers.addAll(anotherHeader);
    }
    if (requestType!.isWithAccessToken) {
      final user = CacheService.getUser();
      if (user != null) {
        options.headers.addAll({
          'Authorization': 'Bearer ${user.tokenInfo!.accessToken}',
        });
        // var token = user.tokenInfo!.accessToken;
        // var length = token.length ~/ 2;
        // customLogger.d(token.substring(0, length));
        // customLogger.d(token.substring(length));
      }
    } else {
      if (requestType == RequestType.REFRESHE_TOKEN ||
          requestType == RequestType.REQEUST_TOKEN) {
        final tokenInfo =
            EncodingUtils.encodeBase64(str: '$_clientID:$_clientSecret');
        options.headers.addAll({
          'Authorization': 'Basic $tokenInfo',
        });
      }
    }
    return handler.next(options);
  }

  onResponseWrapper(Response resp, ResponseInterceptorHandler handler) async {
    // 토큰 갱신 플로우.
    // if (resp.statusCode == 419) {
    //   var user = CacheService.getUser();
    //   if (user != null) {
    //     final body = {
    //       'refresh_token': user.tokenInfo!.refreshToken,
    //       'grant_type': 'refresh_token'
    //     };
    //     ApiService()
    //       ..init(RequestType.REFRESHE_TOKEN)
    //       ..request(body: body).then((result) {
    //         if (result!.statusCode == 200) {
    //           var tokenModel = TokenModel.fromJson(result.body);
    //           user.tokenInfo = tokenModel;
    //           CacheService.saveUser(user);
    //         }
    //       });
    //   }
    // }
    print(requestType);
    if (isWithLog) {
      customLogger.d(
        'path: ${resp.requestOptions.baseUrl}${resp.requestOptions.path}\n'
        'headers: ${resp.headers}'
        'body: ${resp.data}\n',
      );
    }
    return handler.next(resp);
  }

  onErrorWrapper(DioError error, ErrorInterceptorHandler handler) async {
    cancelAll();
    if (isWithLog) {
      // customLogger.d(
      //   'path: ${error.requestOptions.baseUrl}${error.requestOptions.path}\n'
      //   'status code: ${error.response?.statusCode ?? ''}\n'
      //   'body: ${error.response?.data.toString() ?? ''}\n'
      //   'headers: ${error.response?.headers ?? ''}\n'
      //   'requestType: $requestType',
      // );
    }
    handler.next(error);
  }

  Future<File?> downloadAndroid(String url, String dirPath,
      DownLoadCallBack onReceiveProgress, String filePath) async {
    File file = await LocalFileService().createFile(filePath);
    try {
      Response response = await Dio().get(url,
          onReceiveProgress: onReceiveProgress,
          options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
          ));

      file.writeAsBytesSync(response.data);
      return file;
    } catch (e) {
      print(e);
    }
    return file;
  }

  void upload(
      {required String? url,
      FormData? data,
      ProgressCallback? onSendProgress,
      Map<String, dynamic>? params,
      Options? options,
      HttpSuccessCallback? successCallback,
      required String? tag}) async {
    try {
      CancelToken? cancelToken;
      if (tag != null) {
        cancelToken =
            _cancelTokens[tag] == null ? CancelToken() : _cancelTokens[tag]!;
        _cancelTokens[tag] = cancelToken;
      }

      Response<Map<String, dynamic>> response = await _client!.request('$url',
          onSendProgress: onSendProgress,
          data: data,
          queryParameters: params,
          options: options,
          cancelToken: cancelToken);
      String statusCode = response.data!['statusCode'];
      if (statusCode != '200') {
        // do something;
      }
    } on DioError catch (e, s) {
      print(s);
    } catch (e) {}
  }

  void cancel(String tag) {
    if (_cancelTokens.containsKey(tag)) {
      if (!_cancelTokens[tag]!.isCancelled) {
        _cancelTokens[tag]!.cancel();
      }
      _cancelTokens.remove(tag);
    }
  }

  void cancelAll() {
    _cancelTokens.forEach((key, cancelToken) {
      cancelToken!.cancel();
    });
  }

// * params 는 GET 에 사용.
// * body는 POST에 사용.
  Future<RequestResult?> request(
      {Map<String, dynamic>? body,
      Map<String, dynamic>? params,
      String? passingUrl}) async {
    final cp =
        KeyService.baseAppKey.currentContext!.read<ConnectStatusProvider>();
    var status = await cp.currenStream;
    var notConnected = status == null
        ? !(await cp.checkFirstStatus)
        : status != ConnectivityResult.mobile ||
            status != ConnectivityResult.wifi;
    if (notConnected) {
      // AppDialog.showDangermessage(
      //     KeyService.baseAppKey.currentContext!, tr('check_network'));
      return RequestResult(-2, null, 'networkError',
          errorMessage: 'networkError');
    } else {
      final CancelToken? cancelToken;
      final tag = requestType!.tag;
      cancelToken = _cancelTokens[tag] ?? CancelToken();
      _cancelTokens[tag] = cancelToken;
      //* 사용자 휴대폰 넷트워크 에러시 ErrorDialog 호출.
      if (requestType!.httpMethod == 'POST' ||
          requestType!.httpMethod == 'GET') {
        try {
          final Response<Map<String, dynamic>> response = await _client!
              .request(passingUrl ?? requestType!.url(),
                  data: requestType!.httpMethod == 'POST'
                      ? jsonEncode(body)
                      : null,
                  queryParameters:
                      requestType!.httpMethod == 'GET' ? params : null,
                  options: Options(
                    method: requestType!.httpMethod,
                  ),
                  cancelToken: cancelToken);
//------------ cookies setting ----------
          // responseCookies = await cookieJar!
          //     .loadForRequest(Uri.parse('${RequestType.REQEUST_TOKEN.url()}'));
          // responseCookies!.forEach((cookie) {});
          // await cookieJar!.saveFromResponse(
          //     Uri.parse(RequestType.SIGNIN.url()), responseCookies!);
          // final signincookies = await cookieJar!
          //     .loadForRequest(Uri.parse(RequestType.SIGNIN.url()));
          // signincookies.forEach((cookie) {});
//------------ cookies setting ----------

          return RequestResult(
              response.statusCode!, response.data, response.statusMessage!);
        } on DioError catch (e, s) {
          //*  요청 켄슬.
          cancel(tag);
          print(s);
          // * 서버 통신 장애시 statusCode -1로 리턴.
          return RequestResult(-1, null, 'serverError',
              errorMessage: 'serverError');
        }
      }
      //*  알수없는 에러시 statusCode 0 으로 리턴.
      return RequestResult(0, null, 'anothor error',
          errorMessage: 'anothor error');
    }
  }
}
