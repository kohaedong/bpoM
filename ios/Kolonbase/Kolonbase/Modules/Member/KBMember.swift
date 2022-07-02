//  Desc : 사용자 검색 API
//
//  MemberData.swift
//  Kolonbase
//
//  Created by mk on 2020/11/10.
//

import Foundation

public struct MemberItem: Codable {
	
	public var id: Int
	public var userAccount: String?
	public var userName: String?
	public var companyCd: String?
	public var companyName: String?
	public var deptCode: String?
	public var deptName: String?
//	public var deptOrder: String?
	public var absence: String?
	public var email: String?
	public var employeeNo: String?
	public var faxNum: String?
	public var fullPath: String?
	public var maindeptflag: String?
	public var mkolon: String?
	public var mobileNum: String?
	public var officeCode: String?
	public var personNumber: String?
	public var task: String?
	public var telNum: String?
	public var titleCode: String?
	public var titleName: String?
	public var titleOrder: Int?
	public var securityLevel: String?
	public var roleCode: String?
	public var roleName: String?
	public var roleOrder: Int?
	public var roles: String?
	public var creatDttm: String?
	public var creatrId: String?
	public var modDttm: String?
	public var modrId: String?
    
    
}

public struct GroupItem: Codable {
	
	public struct GroupId: Codable {
		public var companyCd: String
		public var deptCode: String
	}
	
	public struct GroupCompany: Codable {
		public var companyCd: String?
		public var companyName: String?
		public var mdburl: String?
		public var sort: Int?
		public var status: String?
		public var createdt: String?
		public var updatedt: String?
	}
	
	public var id: GroupId
	public var deptCode: String?
	public var deptName: String?
	public var companyCd: String?
	public var company: GroupCompany?
	public var fullPath: String?
	public var groupOrder: Int?
	public var parentCd: String?
	public var status: String?
	public var updatedt: String?
	public var createdt: String?
}

public struct EntranceApproverItem: Codable {
	
	public var emp_id: String
	public var emp_name: String
	public var dept_name: String
	public var companyname: String
}


public class KBMember: NSObject {
	
	static let shared = KBMember()
	
	var index = 0
	
	//private override init() {}
	//convenience init() { self.init() }
    
    public func searchMember(userId: String,
                             userName:String? = nil,
                             completion: @escaping (MemberItem?) -> Void,
                             failed: (() -> Void)? = nil) {
        
        let params = [
            "methodName": "searchUser",
            "methodParam": [
                "userAccount": userId,
                "userName": userName
            ]
        ] as [String : Any]
        
        KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
            
            print("searchMember Error: ", error.debugDescription)
            
            guard let data = data else {
                if let action = failed{  action() }
                return
            }
            //print("Data: ", data?.base64EncodedString() as Any)
            
            do {
                                
                let response = try JSONDecoder().decode(KBDataResponse<[MemberItem]>.self, from: data)
                print(response)
                
                // 검색 결과 처리
                if let items = response.data?.first {
                    completion(items)
                }else{
                    if let action = failed {
                        action()
                    }
                    completion(nil)
                }
            }
            catch let error {
                if let action = failed{  action() }
                print("Search Member API Error: \(error.localizedDescription)")
            }
        })
    }

    public func searchMemberDataAPI(text: String, nameSearch: String? = "n", completion: @escaping ([MemberItem]) -> Void) {
		
		let params = [
			"methodName": "searchUserOfKeywordInCompany",
			"methodParam": [
				"companyCd": nil,
                "searchKeyword": text,
                "nameSearch": nameSearch
			]
		] as [String : Any]
		print("Search Text:", text)
		
		KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
			
			print("Error: ", error.debugDescription)
			
			guard let data = data else { return }
			//print("Data: ", data?.base64EncodedString() as Any)
			
			do {
				let response = try JSONDecoder().decode(KBDataResponse<[MemberItem]>.self, from: data)
				print(response)
				
				// 검색 결과 처리
				if let items = response.data {
					completion(items)
				}
			}
			catch let error {
				print("Search Member API Error: \(error.localizedDescription)")
			}
		})
	}
	
	// 승인자 목록 조회
	func searchApproverTeamLeaderAPI(completion: @escaping ([EntranceApproverItem]) -> Void) {
		
		let params = [
			"methodName": "execUP_M_VISITOR_APPROVAL_R",
			"methodParam": [
				"companyCd": KB.Auth.userCompanyCode,
				"deptCd": KB.Auth.userDeptCode
			],
			"complexMethod": "",
			"delegateType": "db"
		] as [String : Any]
		print(params)
		
		KB.API.postData(method: "list", params: params, completionHandler: { (data, error) in
			
			print(error as Any)
			print(data as Any)
			
			guard let data = data else { return }
			
			do {
				let result = try JSONDecoder().decode(KBChildResponse<[EntranceApproverItem]>.self, from: data)
				print(result)
				
				// 검색 결과 처리
				if let items = result.child.data {
					completion(items)
				}
				
			}
			catch let error {
				print("List Approver Auth Error: \(error.localizedDescription)")
			}
		})
	}
}
