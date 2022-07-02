//
//  KBOAuth.swift
//  Kolonbase
//
//  Created by mk on 2020/10/15.
//

import Foundation

public struct KBOAuth: Codable {
	
	public var access_token: String
	var token_type: String
	var refresh_token: String
	var expires_in: Int
	var scope: String
	var user: KBUserInfo
	var jti: String
}

public struct KBUserInfo: Codable {
	
	var id: Int?
	var userAccount: String?
	var userName: String?
	var companyCd: String?
	var companyName: String?
	var deptCode: String?
	var deptName: String?
	var deptOrder: Int?
	var absence: String?
	var email: String?
	var employeeNo: String?
	var faxNum: String?
	var fullPath: String?
	var maindeptflag: String?
	var mkolon: String?
	var mobileNum: String?
	var officeCode: String?
	var personNumber: String?
	var task: String?
	var telNum: String?
	var titleCode: String?
	var titleName: String?
	var titleOrder: Int?
	var securityLevel: String?
	var roleCode: String?
	var roleName: String?
	var roleOrder: Int?
	var roles: String?
	var creatDttm: String?
	var creatrId: String?
	var modDttm: String?
	var modrId: String?
    var hrCompanyCd: String?
}
