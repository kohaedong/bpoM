/*
 * Project Name:  [mKolon3.0] - MedicalSalesPortal
 * File: /Users/bakbeom/work/sm/si/medsalesportal/lib/model/http/request_result.dart
 * Created Date: 2022-07-02 13:56:32
 * Last Modified: 2022-07-02 14:02:45
 * Author: bakbeom
 * Modified By: bakbeom
 * copyright @ 2022  KOLON GROUP. ALL RIGHTS RESERVED. 
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 * 												Discription													
 * ---	---	---	---	---	---	---	---	---	---	---	---	---	---	---	---
 */

class RequestResult {
  int statusCode;
  dynamic body;
  String message;
  String? renewedAccessToken;
  String? errorMessage;

  RequestResult(this.statusCode, this.body, this.message,
      {this.renewedAccessToken, this.errorMessage});
}
