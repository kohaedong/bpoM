/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/view/detailBook/provider/detail_book_page_provider.dart
 * Created Date: 2022-07-05 09:55:29
 * Last Modified: 2022-09-27 20:41:23
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

import 'package:flutter/material.dart';
import 'package:medsalesportal/enums/request_type.dart';
import 'package:medsalesportal/service/api_service.dart';
import 'package:medsalesportal/service/cache_service.dart';
import 'package:medsalesportal/model/common/result_model.dart';
import 'package:medsalesportal/view/common/function_of_print.dart';
import 'package:medsalesportal/buildConfig/kolon_build_config.dart';
import 'package:medsalesportal/model/rfc/detail_book_t_list_model.dart';
import 'package:medsalesportal/model/rfc/detail_book_response_model.dart';
import 'package:medsalesportal/model/rfc/detail_book_file_key_response_model.dart';

class DetailBookPageProvider extends ChangeNotifier {
  DetailBookResponseModel? detailBookResponseModel;
  DetailBookFileKeyResponseModel? fileKeyResponseModel;
  DetailBookResponseModel? searchResultModel;
  bool isLoadData = false;
  final _api = ApiService();
  List<bool> isOpenList = [];
  List<List<DetailBookTListModel>?> pannelGroup = [];
  String? searchKeyStr;

  void setIsOpen(int index) {
    isOpenList[index] = !isOpenList[index];
    notifyListeners();
  }

  void setSerachKeyStr(String? str) {
    searchKeyStr = str?.trim();
    if (str != null && str.isEmpty) {
      resetResultModel();
    }
    notifyListeners();
  }

  void resetResultModel() {
    searchResultModel = null;
    notifyListeners();
  }

  Future<ResultModel> searchDetailBookFile(DetailBookTListModel model) async {
    isLoadData = true;
    notifyListeners();
    _api.init(RequestType.DETAIL_BOOK_SEARCH_FILE);
    final isLogin = 'g_LoginInfo';
    Map<String, dynamic> _body = {
      "methodName": RequestType.DETAIL_BOOK_SEARCH_FILE.serverMethod,
      "methodParamMap": {
        "IV_ICLS": model.icls,
        "IV_ITEM": model.item,
        "IS_LOGIN": isLogin,
        "functionName": RequestType.DETAIL_BOOK_SEARCH_FILE.serverMethod,
        "resultTables": RequestType.DETAIL_BOOK_SEARCH_FILE.resultTable,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      isLoadData = false;
      notifyListeners();
      return ResultModel(false, errorMassage: result.errorMessage);
    }
    if (result != null && result.statusCode == 200) {
      fileKeyResponseModel =
          DetailBookFileKeyResponseModel.fromJson(result.body['data']);
      final key = fileKeyResponseModel!.attachInfo!.id;
      var dev = ' https://mkolonviewdev.kolon.com';
      var prod = ' https://mkolonview.kolon.com';
      var url =
          '${KolonBuildConfig.KOLON_APP_BUILD_TYPE == 'dev' ? '$dev' : '$prod'}/SynapDocViewServer/viewer/doc.html?key=$key&contextPath=/SynapDocViewServer';
      isLoadData = false;
      notifyListeners();
      return ResultModel(true, data: '${url.trim()}');
    }
    isLoadData = false;
    notifyListeners();
    return ResultModel(false, errorMassage: result!.errorMessage);
  }

  Future<ResultModel> searchDetailBook(bool isFirstRun,
      {String? searchKey}) async {
    pr('??????$isFirstRun');
    if (!isFirstRun) {
      resetResultModel();
    }
    _api.init(RequestType.SEARCH_DETAIL_BOOK);
    Map<String, dynamic> _body = {
      "methodName": RequestType.SEARCH_DETAIL_BOOK.serverMethod,
      "methodParamMap": {
        "IV_ICLSNM": "",
        "IV_ITEMNM": searchKey ?? '',
        "IS_LOGIN": CacheService.getIsLogin(),
        "functionName": RequestType.SEARCH_DETAIL_BOOK.serverMethod,
        "resultTables": RequestType.SEARCH_DETAIL_BOOK.resultTable,
      }
    };
    final result = await _api.request(body: _body);
    if (result != null && result.statusCode != 200) {
      return ResultModel(false);
    }
    if (result != null && result.statusCode == 200) {
      if (detailBookResponseModel == null && searchKey == null) {
        detailBookResponseModel =
            DetailBookResponseModel.fromJson(result.body['data']);
        var currentGroup = detailBookResponseModel!.tList!.first.iclsnm;
        var temp = <DetailBookTListModel>[];
        pannelGroup.clear();
        for (var i = 0; i < detailBookResponseModel!.tList!.length; i++) {
          if (detailBookResponseModel!.tList![i].iclsnm == currentGroup) {
            temp.add(detailBookResponseModel!.tList![i]);
            pr(detailBookResponseModel!.tList![i].iclsnm);
          } else {
            currentGroup = detailBookResponseModel!.tList![i].iclsnm;
            var groupList = temp.toList();
            pannelGroup.add(groupList);
            temp.clear();
            temp.add(detailBookResponseModel!.tList![i]);
            pr(detailBookResponseModel!.tList![i].iclsnm);
          }
          if (i == detailBookResponseModel!.tList!.length - 1) {
            var groupList = temp.toList();
            pannelGroup.add(groupList);
          }
        }
        pr(pannelGroup.length);
        isOpenList.clear();
        List.generate(pannelGroup.length, (_) => isOpenList.add(false));
      } else {
        if (!isFirstRun) {
          searchResultModel =
              DetailBookResponseModel.fromJson(result.body['data']);
        }
      }
      notifyListeners();
      return ResultModel(true);
    }

    return ResultModel(false);
  }
}
