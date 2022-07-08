/*
 * Project Name:  [mKolon3.0] - SalesPortal
 * File: /Users/bakbeom/work/sm/si/SalesPortal/lib/util/hive_select_data_util.dart
 * Created Date: 2021-09-24 15:54:09
 * Last Modified: 2022-07-08 13:59:14
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */
import 'package:medsalesportal/enums/common_code_return_type.dart';
import 'package:medsalesportal/enums/hive_box_type.dart';
import 'package:medsalesportal/enums/popup_cell_type.dart';
import 'package:medsalesportal/model/commonCode/cell_model.dart';
import 'package:medsalesportal/model/commonCode/t_code_model.dart';
import 'package:medsalesportal/model/commonCode/t_values_model.dart';
import 'package:medsalesportal/service/hive_service.dart';
import 'package:medsalesportal/util/format_util.dart';
import 'package:medsalesportal/model/commonCode/et_dd07v_customer_category_model.dart';

///[SearchTcodeConditional]는 [HiveService.getData]에서 사용 되는 TCode의 검색 조건이다.
///[SearchTvalueConditional]는 [HiveService.getData]에서 사용 되는 TValue의 검색 조건이다.

/// [HiveBoxType]
/// [HiveBoxType.T_CODE] >>>>>> TCode형 DB [TCodeModel]사용. Tcode 일반 검색용.
/// [HiveBoxType.T_VALUE] >>>>>> TValue형 DB [TValuesModel]사용. Tvalue 일반 검색용.
/// [HiveBoxType.T_VALUE_COUNTRY] >>>>>> TValue형 DB [TValuesModel]사용. 나라검색 전용.
/// [HiveBoxType.ET_CUSTOMER_CATEGORY] >>>>>> TValue형 DB [TValuesModel]사용. 잠재고객 공객용도 카테코리 검색 전용.
/// [HiveBoxType.ET_CUSTOMER_CUSTOMS_INFO] >>>>>> TValue형 DB [TCustomerCustomsModel]사용. 잠재고객 운송지역 검색 전용.[PotentialCustomersProvider.getCustomerCategoryAnalysisAreaFromDB] 참조.
/// (검색 할때마다 http통신후 최신데이터 가져와 hive 새로운 table에 저장)

/// 전체 로직 설명:
/// 1, 서버에서 보내온 공통코드를 Hive에 저장한다.
/// 2, [HiveSelectDataUtil.select] 에서 [SearchTcodeConditional]&[SearchTvalueConditional]등 검색 조건으로  [HiveService.getData] 호출 한다.
/// 3, Hive 검색 결과(Str)를 일정한 귀칙으로 [group1],[group2],[group3],[group4]에 담아 줌.
/// 4, [searchLevel] 검색 레벨에 따라 [group2]까지 검색 하느냐 [group4]까지 검색 하느냐가 결정 됨.
/// 5, [groupSearchKey] 검색 키워드 유무에 따라 [result]결과가 다르다.키워드가 있으면 [result]에서 키워드가 포함된 데이터만 리턴 됨.
/// 6, [isMatchGroupKeyList] 검색 키워드 적용 범위, true 일경우 [group]에서 검색, false 일경우 [groupValue]에서 검색 . defualt [groupValue]
/// 7, [groupSearchKey] 과 [isMatchGroupKeyList]은 혜당 레벨에서만 유효 함.
/// 8, 복소 검색 가능
///  예: searchLevel : 4,
///     group1SearchKey : 'a',
///     isMatchGroup1KeyList : false,
///     group2SearchKey : 'b',
///     isMatchGroup2KeyList : true

typedef SearchTcodeConditional = bool Function(TCodeModel);
typedef SearchTvalueConditional = bool Function(TValuesModel);
typedef TcodeResultCondition = String Function(TCodeModel);
typedef EtCustomerResultCondition = CellModel Function(TCustomerCustomsModel);

class HiveSelectDataUtil {
  static Future<HiveSelectResult> select(
    HiveBoxType type, {
    SearchTcodeConditional? tcodeConditional,
    SearchTvalueConditional? tvalueConditional,
    SearchEtDd07vCustomerConditional? etDd07vCustomerConditional,
    TcodeResultCondition? tcodeResultCondition,
    EtCustomerResultCondition? etCustomerResultCondition,
    CommonCodeReturnType? returnType,
    String? group0SearchKey,
    String? group1SearchKey,
    String? group2SearchKey,
    String? group3SearchKey,
    String? group4SearchKey,
    int? searchLevel,
    bool? isMatchGroup1KeyList,
    bool? isMatchGroup2KeyList,
    bool? isMatchGroup3KeyList,
    bool? isMatchGroup4KeyList,
    bool? isMatchGroup1ValueList,
    bool? isMatchGroup2ValueList,
    bool? isMatchGroup3ValueList,
    bool? isMatchGroup4ValueList,
    String? threeCellSearchKey,
    ThreeCellType? threeCellType,
  }) async {
    await HiveService.init(type);
    await HiveService.getBox();
    final result = await HiveService.getData(
        searchTvalueConditional: tvalueConditional,
        searchTcodeConditional: tcodeConditional,
        searchEtDd07vCustomerConditional: etDd07vCustomerConditional);
    if (result == null) return HiveSelectResult();

    List<String> group1 = [];
    List<String> group2 = [];
    List<String> group3 = [];
    List<String> group4 = [];
    List<String> group1Value = [];
    List<String> group2Value = [];
    List<String> group3Value = [];
    List<String> group4Value = [];
    List<int> indexList = [];
    List<int> indexList2 = [];
    List<int> indexList3 = [];
    List<int> indexList4 = [];
    List<String> resultList = [];
    List<CellModel> cellResult = [];

    var clearData = () {
      group1.clear();
      group1Value.clear();
      indexList.clear();
      group2.clear();
      group2Value.clear();
      indexList2.clear();
      group3.clear();
      group3Value.clear();
      indexList3.clear();
      group4.clear();
      group4Value.clear();
      indexList4.clear();
    };

    var group1CellProssess = () {
      result as List<TValuesModel>;
      result.forEach((tvalue) {
        if (tvalue.helpValues!.trim().contains(' ')) {
          group1.add(FormatUtil.subToStartSpace(tvalue.helpValues!));
          group1Value.add(FormatUtil.subToEndSpace(tvalue.helpValues!));
        } else {
          group1.add(tvalue.helpValues!.trim());
          group1Value.add(' ');
        }
      });
      // 2
    };
    var group2CellProssess = () {
      group1Value.asMap().entries.forEach((tvalueMap) {
        if (tvalueMap.value.trim().contains(' ')) {
          group2.add(FormatUtil.subToStartSpace(tvalueMap.value));
          group2Value.add(FormatUtil.subToEndSpace(tvalueMap.value));
        } else {
          group2.add(tvalueMap.value.trim());
          group2Value.add(' ');
        }
      });
    };
    var group3CellProssess = () {
      assert(group2.length == group2Value.length);
      if (threeCellType == ThreeCellType.GET_COUNTRY_KR ||
          threeCellType == ThreeCellType.GET_COUNTRY) {
        group2Value.asMap().entries.forEach((tvalueMap) {
          if (tvalueMap.value != ' ') {
            var beforeRemoveSpace = tvalueMap.value.trim();
            if (beforeRemoveSpace.contains(group2[tvalueMap.key])) {
              beforeRemoveSpace = beforeRemoveSpace
                  .substring(beforeRemoveSpace.indexOf(group2[tvalueMap.key]));
              if (beforeRemoveSpace == group2[tvalueMap.key]) {
                group3.add(beforeRemoveSpace);
              } else {
                beforeRemoveSpace = beforeRemoveSpace.substring(
                    beforeRemoveSpace.indexOf(group2[tvalueMap.key]));
                beforeRemoveSpace.trim();
                group3.add(beforeRemoveSpace);
              }
            } else {
              group3.add(group2[tvalueMap.key]);
            }
          } else {
            group3.add(' ');
          }
        });
        assert(
            group1.length == group2.length && group2.length == group3.length);
      }
      print(threeCellType);
      if (threeCellType == ThreeCellType.GET_COUNTRY_AREA) {}
    };

    // group 0
    var group0Prossess = () {
      if (group0SearchKey != null) {
        group1Value.asMap().entries.forEach((dataMap) {
          if (dataMap.value == group0SearchKey) {
            resultList.add(group1[dataMap.key]);
          }
        });
      } else {
        resultList = group1Value;
      }
      return HiveSelectResult(strList: resultList);
    };

    // group 1
    var group1Prossess = () {
      resultList.forEach((value) {
        if (value.trim().contains(' ')) {
          group1.add(FormatUtil.subToStartSpace(value));
          group1Value.add(FormatUtil.subToEndSpace(value));
        }
      });
      if (isMatchGroup1KeyList != null && isMatchGroup1KeyList) {
        group1Value.asMap().entries.forEach((map) {
          if (map.value == group1SearchKey) {
            indexList.add(map.key);
          }
        });
      } else if (group1SearchKey != null) {
        group1.asMap().entries.forEach((map) {
          if (map.value == group1SearchKey) {
            indexList.add(map.key);
          }
        });
      } else {
        group1.asMap().entries.forEach((map) {
          indexList.add(map.key);
        });
      }
      indexList.forEach((index) {
        if (isMatchGroup1KeyList != null && isMatchGroup1KeyList) {
          resultList.add(group1[index]);
        } else {
          resultList.add(group1Value[index]);
        }
      });
    };
    // group 2
    var group2Prossess = () {
      resultList.forEach((value) {
        if (value.trim().contains(' ')) {
          group2.add(FormatUtil.subToStartSpace(value));
          group2Value.add(FormatUtil.subToEndSpace(value));
        }
      });
      if (isMatchGroup2KeyList != null && isMatchGroup2KeyList) {
        group2Value.asMap().entries.forEach((map) {
          if (map.value == group2SearchKey) {
            indexList2.add(map.key);
          }
        });
      } else {
        if (group2SearchKey != null) {
          group2.asMap().entries.forEach((map) {
            if (map.value == group2SearchKey) {
              indexList2.add(map.key);
            }
          });
        } else {
          group2.asMap().entries.forEach((map) {
            indexList2.add(map.key);
          });
        }
      }
      resultList.clear();
      indexList2.forEach((index) {
        if (isMatchGroup2KeyList != null && isMatchGroup2KeyList) {
          resultList.add(group2[index]);
        } else {
          resultList.add(group2Value[index]);
        }
      });
    };

    // group 3
    var group3Prossess = () {
      resultList.forEach((value) {
        if (value.trim().contains(' ')) {
          group3.add(FormatUtil.subToStartSpace(value));
          group3Value.add(FormatUtil.subToEndSpace(value));
        }
      });
      if (isMatchGroup3KeyList != null && isMatchGroup3KeyList) {
        group3Value.asMap().entries.forEach((map) {
          if (map.value == group3SearchKey) {
            indexList3.add(map.key);
          }
        });
      } else {
        if (group3SearchKey != null) {
          group3.asMap().entries.forEach((map) {
            if (map.value == group3SearchKey) {
              indexList3.add(map.key);
            }
          });
        } else {
          group3.asMap().entries.forEach((map) {
            indexList3.add(map.key);
          });
        }
      }
      resultList.clear();
      indexList3.forEach((index) {
        if (isMatchGroup3KeyList != null && isMatchGroup3KeyList) {
          resultList.add(group3[index]);
        } else {
          resultList.add(group3Value[index]);
        }
      });
    };

    var group4Prossess = () {
      resultList.forEach((value) {
        if (value.trim().contains(' ')) {
          group4.add(FormatUtil.subToStartSpace(value));
          group4Value.add(FormatUtil.subToEndSpace(value));
        }
      });
      if (isMatchGroup4KeyList != null && isMatchGroup4KeyList) {
        group4Value.asMap().entries.forEach((map) {
          if (map.value == group4SearchKey) {
            indexList4.add(map.key);
          }
        });
      } else {
        if (group4SearchKey != null) {
          group4.asMap().entries.forEach((map) {
            if (map.value == group4SearchKey) {
              indexList4.add(map.key);
            }
          });
        } else {
          group4.asMap().entries.forEach((map) {
            indexList4.add(map.key);
          });
        }
      }
      resultList.clear();
      indexList4.forEach((index) {
        if (isMatchGroup4KeyList != null && isMatchGroup4KeyList) {
          resultList.add(group4[index]);
        } else {
          resultList.add(group4Value[index]);
        }
      });
    };

    /// entry point!
    if (tvalueConditional != null) {
      result as List<TValuesModel>;
      if (threeCellType != null) {
        switch (threeCellType) {
          case ThreeCellType.GET_COUNTRY_KR:
            group1CellProssess.call();
            group2CellProssess.call();
            group3CellProssess.call();
            group1.asMap().entries.forEach((map) {
              if (map.value.contains('KR')) {
                cellResult.add(CellModel(
                    column1: map.value,
                    column2: group2[map.key],
                    column3: group3[map.key]));
              }
            });
            break;

          case ThreeCellType.GET_COUNTRY:
            group1CellProssess.call();
            group2CellProssess.call();
            group3CellProssess.call();
            group1.asMap().entries.forEach((map) {
              cellResult.add(CellModel(
                  column1: map.value,
                  column2: group2[map.key],
                  column3: group3[map.key]));
            });
            break;
          case ThreeCellType.GET_COUNTRY_AREA:
            group1CellProssess.call();
            group2CellProssess.call();
            if (threeCellSearchKey != null) {
              group1.asMap().entries.forEach((map) {
                if (map.value == threeCellSearchKey) {
                  cellResult.add(CellModel(
                      column1: map.value,
                      column2: group2[map.key],
                      column3: group2Value[map.key]));
                }
              });
            }
            break;
          // ok
          case ThreeCellType.GET_COUNTRY_AREA_KR:
            group1CellProssess.call();
            group2CellProssess.call();
            if (threeCellSearchKey != null) {
              group1.asMap().entries.forEach((map) {
                if (map.value == threeCellSearchKey) {
                  cellResult.add(CellModel(
                      column1: map.value,
                      column2: group2[map.key],
                      column3: group2Value[map.key]));
                }
              });
            }
            break;
          case ThreeCellType.SEARCH_CUSTOMER_DELEV_AREA:
            group1CellProssess.call();
            group2CellProssess.call();
            group3CellProssess.call();
            group1.asMap().entries.forEach((map) {
              cellResult.add(CellModel(
                  column1: map.value,
                  column2: group2[map.key],
                  column3: group3[map.key]));
            });
            break;
          default:
        }

        return HiveSelectResult(cellList: cellResult);
      }
      if (returnType != null && returnType == CommonCodeReturnType.ALL) {
        result.forEach((tvalue) {
          if (tvalue.helpValues!.contains(' ')) {
            resultList.add(tvalue.helpValues!);
          }
        });
        return HiveSelectResult(strList: resultList);
      }
      result.forEach((tvalue) {
        if (tvalue.helpValues != null) {
          if (tvalue.helpValues!.contains(' ')) {
            group1.add(FormatUtil.subToStartSpace(tvalue.helpValues!));
            group1Value.add(FormatUtil.subToEndSpace(tvalue.helpValues!));
          }
        }
      });
      if (searchLevel != null && searchLevel == 0) {
        group0Prossess.call();
      } else {
        if (searchLevel != null && searchLevel == 1) {
          group1Prossess.call();
        } else if (searchLevel != null && searchLevel == 2) {
          group1Prossess.call();
          group2Prossess.call();
        } else if (searchLevel != null && searchLevel == 3) {
          group1Prossess.call();
          group2Prossess.call();
          group3Prossess.call();
        } else if (searchLevel != null && searchLevel == 4) {
          group1Prossess.call();
          group2Prossess.call();
          group3Prossess.call();
          group4Prossess.call();
        }
      }
    }
    if (tcodeConditional != null && tcodeResultCondition != null) {
      clearData.call();
      result as List<TCodeModel>;
      result.forEach((tcode) {
        resultList.add(tcodeResultCondition.call(tcode));
      });
    }

    if (etDd07vCustomerConditional != null &&
        etCustomerResultCondition != null) {
      result as List<TCustomerCustomsModel>;
      result.forEach((etCategory) {
        cellResult.add(etCustomerResultCondition.call(etCategory));
      });
    }
    if (returnType != null && returnType == CommonCodeReturnType.KEY) {
      switch (searchLevel) {
        case 0:
          resultList.clear();
          resultList.addAll(group1);
          break;
        case 1:
          resultList.clear();
          indexList.forEach((index) {
            resultList.add(group1[index]);
          });
          break;
        case 2:
          resultList.clear();
          indexList2.forEach((index) {
            resultList.add(group2[index]);
          });
          break;
        case 3:
          resultList.clear();
          indexList3.forEach((index) {
            resultList.add(group3[index]);
          });
          break;
        case 4:
          resultList.clear();
          indexList4.forEach((index) {
            resultList.add(group4[index]);
          });
          break;
        default:
      }
    }
    return HiveSelectResult(strList: resultList, cellList: cellResult);
  }
}

class HiveSelectResult {
  List<String>? strList;
  List<String>? codeList;
  List<CellModel>? cellList;
  HiveSelectResult({
    this.cellList,
    this.strList,
  });
}
