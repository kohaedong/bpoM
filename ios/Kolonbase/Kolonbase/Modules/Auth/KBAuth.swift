//  Desc : 인증 처리 (OAuth)
//
//  KBAuth.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import UIKit

// MARK: -  KB Auth
public class KBAuth: NSObject {
	
	static let shared = KBAuth()
	
	// OAuth 인증 정보
	var authInfo: KBOAuth?
	var userInfo: KBUserInfo?
	
	public var userToken: String? { get { authInfo?.access_token }}
	public var userRefreshToken: String? { get { authInfo?.refresh_token }}
	
    public var userId: Int? { get { userInfo?.id }}
    @objc public var userAccount: String? { get { userInfo?.userAccount }}
	
    @objc public var userEmail: String? { get { userInfo?.email }}
    @objc public var userName: String? { get { userInfo?.userName }}
    @objc public var userTitle: String? { get { userInfo?.titleName }}
    @objc public var userDept: String? { get { userInfo?.deptName }}
    @objc public var userCompany: String? { get { userInfo?.companyName }}
    @objc public var userEmployeeNo: String? { get { userInfo?.employeeNo }}

    @objc public var userDeptCode: String? { get { userInfo?.deptCode }}
    @objc public var userCompanyCode: String? { get { userInfo?.companyCd }}
	
    @objc public var userSecurityLevel: String? { get { userInfo?.securityLevel }}
    @objc public var userRole: String? { get { userInfo?.roles }}
    @objc public var hrCompanyCd: String? { get { userInfo?.hrCompanyCd }}
    
    @objc public var userMobileNum: String? { get { userInfo?.mobileNum }}
    @objc public var userTitleCode: String? { get { userInfo?.titleCode }}
    @objc public var userTelNum: String? { get { userInfo?.telNum }}
    
	public var watermark: String? {
        
		get {
            if KB.Auth.isSigned == true {
                return "\(userName ?? "") \(userTitle ?? "") - \(userDept ?? "")  "
            }
            else {
                return nil
            }
        }
    }
	
	public enum AuthType: String { case none = "NONE"; case oauth = "OAUTH"; case idpw = "IDPW"; }
    public var authType = AuthType.oauth
	
    @objc public enum SecurityLevel: Int {
        case none = 0;
        case regular = 1;
        case temporary = 2;
        case cooperator = 3;
        case noaccess = 4;
    }
    
    @objc public var securityLevel: SecurityLevel {
		get {
			guard let securityLevel = userSecurityLevel,
				  let level = Int(securityLevel)
			else { return .regular }
			
			switch Int(level) {
				case 0...10: return .regular		// 정직원
				case 11...20: return .temporary		// 임시직
				case 21...30: return .cooperator	// 협력업체
				case 31...40: return .noaccess		// 권한없음(입사 전 사용자)
				default: return .regular               // None
			}
		}
	}
	
    @objc public var isDetectRootingUser = false
    @objc public var isShowWatermarkUser = false{
        didSet{
            // 워터마크 표시
            KB.Detect.showWaterMark()
        }
    }
    @objc public var isAllowScreenshotUser = false
    
    @objc public var isSigned = false
    @objc public var isLogout = false
    
	private override init() {}
	
    
	// MARK: - OAuth 인증
	public func signin(username: String, password: String, completionHandler: @escaping (Result<KBUserInfo, Error>?) -> Void) {
		
		var result: Result<KBUserInfo, Error>?
		
		let authId = "default"
		let authPw = "secret"
		let loginString = String(format: "%@:%@", authId, authPw)
		let loginData = loginString.data(using: .utf8)!
		let base64String = loginData.base64EncodedString()
		let credential = "Basic \(base64String)"
		let requestHeaders = ["Authorization": credential, "Content-Type": "application/x-www-form-urlencoded"]
		
		var requestBodyComponents = URLComponents()
//        var username1 = "yeji_jeong1"
//        var password1 = "dPwl123%25"
        let encodeUserID = username.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let encodePassword = password.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        requestBodyComponents.queryItems = [URLQueryItem(name: "username", value: encodeUserID),
                                            URLQueryItem(name: "password", value: encodePassword),
                                            URLQueryItem(name: "grant_type", value: "password"),
                                            URLQueryItem(name: "scope", value: "read"),
                                            URLQueryItem(name: "callback_url", value: auth_host)]
//		requestBodyComponents.queryItems = [URLQueryItem(name: "username", value: username),
//											URLQueryItem(name: "password", value: password),
//											URLQueryItem(name: "grant_type", value: "password"),
//											URLQueryItem(name: "scope", value: "read"),
//											URLQueryItem(name: "callback_url", value: auth_host)]
		//URLQueryItem(name: "redirect_uri", value: "app://")]
		
		var request = URLRequest(url: URL(string: auth_host)!)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = requestHeaders
		request.httpBody = requestBodyComponents.query?.data(using: .utf8)
        request.setValue(KB.API.appId, forHTTPHeaderField: "appId")
        request.setValue(UIDevice.modelName, forHTTPHeaderField: "deviceModelNo")
        request.setValue(KB.UserData.uuid, forHTTPHeaderField: "deviceSerialNo")
        request.setValue("IOS " + UIDevice.current.systemVersion, forHTTPHeaderField: "osVerNm")
        request.setValue(UIDevice.modelName.contains("Pad") ? "iPad": "iOS Phone", forHTTPHeaderField: "devicePlatformNm")
        request.setValue(KB.Detect.isJailbroken() ? "Y" : "N", forHTTPHeaderField: "hckMngYn")

		URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
			
            guard error == nil && data != nil else {
				
                let info: [String: String] = ["message": error?.localizedDescription ?? ""]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100001, userInfo: info)
				result = .failure(error)
				completionHandler(result)
				return
			}
			
			guard let httpStatus = response as? HTTPURLResponse else {
				
				let info: [String: String] = ["message": "No HTTP Status"]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100002, userInfo: info)
				result = .failure(error)
				completionHandler(result)
				return
			}
			
			if httpStatus.statusCode == 200 {
				
				if let data = data {
					
					do {
						
						// JSON 파싱
						let decoder = JSONDecoder()
						self.authInfo = try decoder.decode(KBOAuth.self, from: data)
						self.userInfo = self.authInfo?.user
						//print(self.userInfo)
						
						// 완료 처리
						if let info = self.authInfo {
							
							// 로그인 상태로 설정
							self.isSigned = true
							
							// 사용자 ID/PW 저장
							KB.UserData.userId = username
							KB.UserData.userPw = password
							
							// 인증 토큰 정보 저장
							KB.UserData.userToken = info.access_token
							KB.UserData.refreshToken = info.refresh_token
							KB.UserData.expiresIn = info.expires_in
							
							// 토큰 만료시간 저장
							let now = Date()
							let interval = TimeInterval(info.expires_in)
							let date = now.addingTimeInterval(interval)
							KB.UserData.expiresDate = date
							
							// 로그인 후 처리
							result = .success(info.user)
						}
					}
					catch let error {
						
						result = .failure(error)
					}
				}
				else {
					
					//let info: [String: String] = ["message": "No got data from URL."]
                    let info: [String: String] = ["message": "아이디 또는 비밀번호를 확인해 주세요."]
					let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2" , code: -100003, userInfo: info)
					result = .failure(error)
				}
			}
			else if httpStatus.statusCode == 401 {
				
				let info: [String: String] = ["message": "아이디 또는 비밀번호를 확인해 주세요."]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100004, userInfo: info)
				result = .failure(error)
			}
			else {
				
				//let info: [String: String] = ["message": "error httpstatus code is \(httpStatus.statusCode)"]
                let info: [String: String] = ["message": "아이디 또는 비밀번호를 확인해 주세요"]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100005, userInfo: info)
				result = .failure(error)
			}
			
			completionHandler(result)
			
		}).resume()
	}
	
	public func extendSignIn() {
		
		let authId = "default"
		let authPw = "secret"
		let loginString = String(format: "%@:%@", authId, authPw)
		let loginData = loginString.data(using: .utf8)!
		let base64String = loginData.base64EncodedString()
		let credential = "Basic \(base64String)"
		let requestHeaders = ["Authorization": credential, "Content-Type": "application/x-www-form-urlencoded"]
		
		var requestBodyComponents = URLComponents()
		requestBodyComponents.queryItems = [URLQueryItem(name: "grant_type", value: "refresh_token"),
											URLQueryItem(name: "refresh_token", value: KB.UserData.refreshToken)]
		
		var request = URLRequest(url: URL(string: auth_host)!)
		request.httpMethod = "POST"
		request.allHTTPHeaderFields = requestHeaders
		request.httpBody = requestBodyComponents.query?.data(using: .utf8)
		
		URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
			
			guard error == nil && data != nil else {
				
                if let string = error?.localizedDescription {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        AlertPopupViewController(title: "에러", message: string).show() }
                }
				return
			}
			
			guard let httpStatus = response as? HTTPURLResponse else {
				
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    AlertPopupViewController(title: "에러", message: "Error: No HTTP Status").show() }
				return
			}
			
			if httpStatus.statusCode == 200 {
				
				if let data = data {
					
					do {
						
						// JSON 파싱
						let decoder = JSONDecoder()
						
						self.authInfo = try decoder.decode(KBOAuth.self, from: data)
						self.userInfo = self.authInfo?.user
						//print(self.userInfo)
						
						// 완료 처리
						if let info = self.authInfo {
							
							// 로그인 상태로 설정
							self.isSigned = true
							
							// 사용자 정보 저장
							KB.UserData.userToken = info.access_token
							KB.UserData.refreshToken = info.refresh_token
							KB.UserData.expiresIn = info.expires_in
							
							// 토큰 만료시간 저장
							let now = Date()
							let interval = TimeInterval(info.expires_in)
							let date = now.addingTimeInterval(interval)
							KB.UserData.expiresDate = date
						}
					}
					catch let error {
						
						let error = String("Auth Error: \(error.localizedDescription)")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                            AlertPopupViewController(title: "에러", message: error).show() }
					}
				}
				else {
					
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                        AlertPopupViewController(title: "에러", message: "No got data from URL.").show() }
				}
			}
			else if httpStatus.statusCode == 401 {
				
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    AlertPopupViewController(title: "에러", message: "인증 오류 입니다.").show() }
			}
			else {
				
				let error = String("error httpstatus code is \(httpStatus.statusCode)")
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    AlertPopupViewController(title: "에러", message: error).show() }
			}

		}).resume()
	}
	
	
	// MARK: ID/PW Login
	public func login(id: String, pw: String, completionHandler: @escaping (Result<KBUserInfo, Error>?) -> Void) {
		
		var result: Result<KBUserInfo, Error>?
		
		//var request = URLRequest(url: URL(string: login_host)!)
		
//		let urlString = "https://appdev.kolon.com/common/v2/api/basiclogin/auth"
        let urlString = login_host
		let url = URL(string: urlString)
		var request = URLRequest(url: url!)
		request.httpMethod = "POST"
		request.setValue("application/json", forHTTPHeaderField: "Accept")
		request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let encodeUserID = id.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        let encodePassword = pw.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        
		do {
            let params = ["userAccount": encodeUserID, "passwd": encodePassword]
//			let params = ["userAccount": id, "passwd": pw]
//			let params = [
//				"userAccount": "yeji_jeong1",
//				"passwd": "dPwl123%"
//			]
			try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])

		}
		catch let error {
			print("API Error: \(error.localizedDescription)")
			return
		}
		//print(request)
		
		URLSession.shared.dataTask(with: request, completionHandler: {(data, response, error) -> Void in
			
			guard error == nil && data != nil else {
				
				//let info: [String: String] = ["message": error?.localizedDescription ?? ""]
                let info: [String: String] = ["message": "No HTTP Status"]                
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100001, userInfo: info)
				result = .failure(error)
				completionHandler(result)
				return
			}
			
			guard let httpStatus = response as? HTTPURLResponse else {
				
				let info: [String: String] = ["message": "No HTTP Status"]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100002, userInfo: info)
				result = .failure(error)
				completionHandler(result)
				return
			}
			
			if httpStatus.statusCode == 200 {
				
				if let data = data {
					
					do {
						// JSON 파싱
						let decoder = JSONDecoder()
						let response = try decoder.decode(KBDataResponse<KBUserInfo>.self, from: data)
						print(response)
						
						if let data = response.data {
							
							// 로그인 후 처리
							self.isSigned = true
							self.userInfo = data
							
							// 사용자 ID/PW 저장
							KB.UserData.userId = id
							KB.UserData.userPw = pw
							
							result = .success(data)
						}
						else {
							// 로그인 정보 없음
							let info: [String: String] = ["message": "사용자 정보를 확인해 주세요."]
							let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100006, userInfo: info)
							result = .failure(error)
						}
					}
					catch let error {
						
						result = .failure(error)
					}
				}
				else {
					
					let info: [String: String] = ["message": "No got data from URL."]
					let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2" , code: -100003, userInfo: info)
					result = .failure(error)
				}
			}
			else if httpStatus.statusCode == 401 {
				
				let info: [String: String] = ["message": "아이디 또는 비밀번호를 확인해 주세요."]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100004, userInfo: info)
				result = .failure(error)
			}
			else {
				
				let info: [String: String] = ["message": "error httpstatus code is \(httpStatus.statusCode)"]
				let error = NSError(domain: Bundle.main.bundleIdentifier ?? "ikenapp2", code: -100005, userInfo: info)
				result = .failure(error)
			}
			
			completionHandler(result)
			
		}).resume()
	}
	
	// MARK: - 디바이스 토큰 저장
	public func saveUserDeviceTokenAPI(completion: @escaping () -> Void) {
		
		var params: [String : Any]!
		if KB.Auth.isSigned == true || KB.Auth.authType == .oauth {
			// OAuth 인증 사용자
			params = [
				"methodName": "saveDeviceInfo",
				"methodParam": [
					"deviceId": KB.UserData.uuid,
					"deviceModelNo": UIDevice.modelName,
					"devicePlatformName": UIDevice.modelName.contains("Pad") ? "iPad": "iPhone"
				]
			]
		}
		else {
			// ID/PW 사용자
			params = [
				"methodName": "saveDeviceInfoByAnonymous",
				"methodParam": [
					"userId": KB.Auth.userAccount,
					"deviceId": KB.UserData.uuid,
					"deviceModelNo": UIDevice.modelName,
					"devicePlatformName": UIDevice.modelName.contains("Pad") ? "iPad": "iPhone"
				]
			]
		}
		//print(params)
		
		KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
			
			print("Error: ", error.debugDescription)
			
			guard let data = data else { return }
			//print("Data: ", data.base64EncodedString() as Any)
			
			do {
				let _ = try JSONDecoder().decode(KBDataResponse<Bool>.self, from: data)
				
				completion()
			}
			catch let error {
				
				AlertPopupViewController(title: "FCM", message: error.localizedDescription).show()
			}
		})
	}
	
	// MARK: - FCM 토큰 저장
	public func saveUserFCMTokenAPI(completion: @escaping () -> Void) {
			
		var params: [String : Any]!
		if KB.Auth.isSigned == true || KB.Auth.authType == .oauth {
			// OAuth 인증 사용자
			params = [
				"methodName": "saveOfFCMDeviceToken",
				"methodParam": [
					"fcmToken": KB.UserData.userFcm,
					"devId": KB.UserData.uuid
				]
			]
		}
		else {
			// ID/PW 사용자
			params = [
				"methodName": "saveOfFCMDeviceTokenByAnonymous",
				"methodParam": [
					"fcmToken": KB.UserData.userFcm,
					"devId": KB.UserData.uuid,
					"userId": KB.Auth.userAccount
				]
			]
		}
		//print(params)
		
		KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
			
			print("Error: ", error.debugDescription)
			
			guard let data = data else { return }
			//print("Data: ", data.base64EncodedString() as Any)
			
			do {
				
				let _ = try JSONDecoder().decode(KBDataResponse<Bool>.self, from: data)
				
				completion()
			}
			catch let error {
				
				AlertPopupViewController(title: "FCM", message: error.localizedDescription).show()
			}
		})
	}
}


// MARK: - 로그인 UI 호출
public extension KBAuth {
    
	@objc func loginWithOAuthUI(sender: LoginWithOAuthViewControllerDelegate? = nil) {
        
        // OAuth 인증
        KB.Auth.authType = .oauth
        
        guard let bundle = Bundle(identifier: baseBundleId) else { return }
        
        let s = UIStoryboard(name: "LoginWithOAuth", bundle: bundle)
        let id = String(describing: LoginWithOAuthViewController.self)
        let v = s.instantiateViewController(withIdentifier: id) as! LoginWithOAuthViewController
		v.delegate = sender
        
        if let vc = UIApplication.shared.getCurrentViewController() {
            vc.present(v, animated: true, completion: nil)
        }
    }
    
    @objc func loginWithIDPWUI(sender: LoginWithIDPWViewControllerDelegate? = nil) {
        
        // ID/PW 로그인
        KB.Auth.authType = .idpw
        
        guard let bundle = Bundle(identifier: baseBundleId) else { return }
        
        let s = UIStoryboard(name: "LoginWithIDPW", bundle: bundle)
        let id = String(describing: LoginWithIDPWViewController.self)
        let v = s.instantiateViewController(withIdentifier: id) as! LoginWithIDPWViewController
		v.delegate = sender
        
        if let vc = UIApplication.shared.getCurrentViewController() {
            vc.present(v, animated: true, completion: nil)
        }
    }
}
