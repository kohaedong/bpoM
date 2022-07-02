//  Desc : API 처리 (RESTful)
//
//  KBAPI.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import UIKit

//MARK: - KB Error Type
public enum KBErrorMessageType {
    /**
     클라이언트, 앱, 우리쪽에서 난 오류일 경우.
     */
    case clientProcessingError
    /**
     네트워크 송수신 성공하였으나 OK메시지가 반환되지 않은 경우, 데이터가 없는 경우.(HTTP 500번대 에러 포함)
     */
    case serverProcessingError
    /**
     데이터 연결, Wi-Fi 연결 등이 원활하지 않음.(HTTP 400번대 에러 포함)
     */
    case networkError
    case noneData
    
    public func getErrorMessage() -> String? {
        switch self {
        case .clientProcessingError:
            return
                """
처리 중 에러가 발생하였습니다.
다시 시도해 주세요. 지속될 시
서비스데스크로 연락 부탁드립니다.
"""
        case .serverProcessingError:
            return
"""
처리 중 에러가 발생하였습니다.
다시 시도해 주세요. 지속될 시
서비스데스크로 연락 부탁드립니다.
"""
        case .networkError:
            return
"""
Wi-Fi 또는 모바일데이터 연결이 원활하지 않습니다.
연결상태를 먼저 확인하고, 다시 시도해보세요.

만약 문제가 지속되면 서비스데스크(02-3677-5000, 운영시간 09:00~18:00)에 연락 부탁드립니다.
Wi-Fi 또는 모바일데이터 연결이 원활하지 않습니다.
연결상태를 먼저 확인하고, 다시 시도해보세요.
"""
        default:
            return nil
        }
    }
}

// MARK: -  KB API
public class KBAPI: NSObject {
	
	static let shared = KBAPI()
	
	private override init() {}
	
	// 앱 ID - Inof.plist에 설정된 값을 읽음
	public var appId: String {
		
		get {
			var appId = "0"
			
			if let info: [String: Any] = Bundle.main.infoDictionary {
				if let appIDs = info["KolonbaseAppID"] as? [String: String] {
					
					#if DEBUG
						appId = appIDs["DEBUG"] ?? ""
					#else
						appId = appIDs["RELEASE"] ?? ""
					#endif
				}
			}
			
			return appId
		}
	}
}

// MARK: - KB API Methods
extension KBAPI {
	
	public func get(method: String, params: [String: Any]) {
		
		let paramsMap = params.compactMap({ (key, value) -> String in "\(key)=\(value)" })
		let paramsString = (paramsMap as Array).joined(separator: "&")
		
		let urlString = "\(api_host)/\(method)/\(paramsString)"
		let escapeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
		
		if let url = URL(string: escapeString) {
			
			URLSession.shared.dataTask(with: url) { data, response, error in
				
				if let data = data {
					
					print("Result: \(data.description)")
				}
				else {
					
					print("Get Message Failure!")
				}
			}.resume()
		}
	}
	
	public func postJson(method: String, params: [String: Any], completionHandler: @escaping ([String: Any]?, Error?) -> Void) {
		
		let urlString = "\(api_host)/\(method)"
		
		if let url = URL(string: urlString) {
			
			guard let token = KB.UserData.userToken else { return }
			let requestHeaders = ["Authorization": "Bearer \(token)"]
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.allHTTPHeaderFields = requestHeaders
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			// API 옵션
			request.setValue(appId, forHTTPHeaderField: "appId")
			request.setValue(UIDevice.modelName, forHTTPHeaderField: "deviceModelNo")
			request.setValue(KB.UserData.uuid, forHTTPHeaderField: "deviceSerialNo")
            request.setValue("IOS " + UIDevice.current.systemVersion, forHTTPHeaderField: "osVerNm")
            request.setValue(UIDevice.modelName.contains("Pad") ? "iPad": "iOS Phone", forHTTPHeaderField: "devicePlatformNm")
            request.setValue(KB.Detect.isJailbroken() ? "Y" : "N", forHTTPHeaderField: "hckMngYn")
            request.timeoutInterval = Bundle.main.bundleIdentifier == "com.kolon.ikenapp2" ? 10 : 30
            
			// Body
			do {
				try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
			}
			catch let error {
				print("API Error: \(error.localizedDescription)")
				return
			}
			
			URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                
                // Error Check
				guard error == nil else {
					completionHandler(nil, error)
					return
				}
				
				// Response Check
                if let response = response as? HTTPURLResponse{
                    if 500...599 ~= response.statusCode{
                        self.showErrorPopup()
                        completionHandler(nil, error)
                        return
                    }
                }
				guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
				//print("Post Message Success:", response)
				
				// Data Check
				guard let data = data else {
					
					completionHandler(nil, NSError(domain: "DataNilError", code: -100001, userInfo: nil))
					return
				}
				
				do {
					
					guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
						
						completionHandler(nil, NSError(domain: "InvalidJSONTypeError", code: -100009, userInfo: nil))
						return
					}
					//print(json)
					
					completionHandler(json, nil)
				}
				catch let error {
					
					print(error.localizedDescription)
					
					completionHandler(nil, error)
				}
				
			}.resume()
		}
	}
	
	public func postData(method: String, params: [String: Any], completionHandler: @escaping (Data?, Error?) -> Void) {
		
		let urlString = "\(api_host)/\(method)"
		
		if let url = URL(string: urlString) {
			
			guard let token = KB.UserData.userToken else { return }
			let requestHeaders = ["Authorization": "Bearer \(token)"]
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.allHTTPHeaderFields = requestHeaders
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			// API 옵션
			request.setValue(appId, forHTTPHeaderField: "appId")
			request.setValue(UIDevice.modelName, forHTTPHeaderField: "deviceModelNo")
			request.setValue(KB.UserData.uuid, forHTTPHeaderField: "deviceSerialNo")
            request.setValue("IOS " + UIDevice.current.systemVersion, forHTTPHeaderField: "osVerNm")
            request.setValue(UIDevice.modelName.contains("Pad") ? "iPad": "iOS Phone", forHTTPHeaderField: "devicePlatformNm")
            request.setValue(KB.Detect.isJailbroken() ? "Y" : "N", forHTTPHeaderField: "hckMngYn")
            request.timeoutInterval = Bundle.main.bundleIdentifier == "com.kolon.ikenapp2" ? 10 : 30
            //request.httpBody = KB.Crypto.encrypt(text: params.toJsonString())
            
			do {
                try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
			}
			catch let error {
				print("API Error: \(error.localizedDescription)")
				return
			}
			
			URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
                
				// Error Check
				guard error == nil else {
                    // error가 발생하였을 경우 404에러로 간주한다.
                    if (error! as NSError).domain == NSURLErrorDomain {
                        
                        let error = NSError(domain: NSURLErrorDomain,
                                            code: 404,
                                            userInfo: ["url": url, "params": params]
                        )
                        completionHandler(nil, error)
                        return
                    }
                    
					completionHandler(nil, error)
					return
				}
                
                guard let response = response as? HTTPURLResponse else {
                    return
                }
                
                if let response = response as? HTTPURLResponse{
                    if 500...599 ~= response.statusCode{
                        self.showErrorPopup()
                        completionHandler(nil, error)
                        return
                    }
                }
                
                guard 200...299 ~= response.statusCode else {
                    
                    let error = NSError(domain: NSURLErrorDomain,
                                        code: response.statusCode,
                                        userInfo: ["url": url, "params": params]
                    )
                    return completionHandler(nil, error)
                }
				
				// Data Check
				guard let data = data else {
					
					completionHandler(nil, NSError(domain: "DataNilError", code: -100001, userInfo: nil))
					return
				}
                
//                guard let decrypt = KB.Crypto.decrypt(data: data),
//                      let decryptData = decrypt.data(using: .utf8) else{
//                    return
//                }
                
				completionHandler(data, nil)
				
			}.resume()
		}
	}
}


// MARK: - REST API Methods
extension KBAPI {
    
    public func getRESTAPI(method: String, params: [String: Any]?, completionHandler: @escaping (Data?, Error?) -> Void) {
        
        
        var urlString = "\(rest_host)/\(method)"
        
        if let params = params{
            
            let paramsMap = params.compactMap({ (key, value) -> String in "\(key)=\(value)" })
            let paramsString = (paramsMap as Array).joined(separator: "&")
            
            urlString = "\(rest_host)/\(method)/\(paramsString)"
        }

        let escapeString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? urlString
        
        if let url = URL(string: escapeString) {
            
            URLSession.shared.dataTask(with: url) { data, response, error in
                
                // Error Check
                guard error == nil else {
//                    self.showErrorPopup()
                    completionHandler(nil, error)
                    return
                }
                
                // Response Check
                if let response = response as? HTTPURLResponse{
                    if 500...599 ~= response.statusCode{
                        self.showErrorPopup()
                        completionHandler(nil, error)
                        return
                    }
                }
                guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
                //print("REST API Response:", response)
                
                // Data Check
                guard let data = data else {
                    completionHandler(nil, NSError(domain: "DataNilError", code: -100001, userInfo: nil))
                    return
                }
                
                completionHandler(data, nil)
            }.resume()
        }
    }

	public func postRESTAPI(isAuth: Bool = true, method: String, params: [String: Any?], completionHandler: @escaping (Data?, Error?) -> Void) {
		
		let urlString = "\(rest_host)/\(method)"
		
		if let url = URL(string: urlString) {
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.setValue("application/json", forHTTPHeaderField: "Content-Type")
			
			// API 옵션
			request.setValue(appId, forHTTPHeaderField: "appId")
			request.setValue(UIDevice.modelName, forHTTPHeaderField: "deviceModelNo")
			request.setValue(KB.UserData.uuid, forHTTPHeaderField: "deviceSerialNo")
            request.setValue("IOS " + UIDevice.current.systemVersion, forHTTPHeaderField: "osVerNm")
            request.setValue(UIDevice.modelName.contains("Pad") ? "iPad": "iOS Phone", forHTTPHeaderField: "devicePlatformNm")
            request.setValue(KB.Detect.isJailbroken() ? "Y" : "N", forHTTPHeaderField: "hckMngYn")
            request.timeoutInterval = Bundle.main.bundleIdentifier == "com.kolon.ikenapp2" ? 10 : 30
			// OAuth 인증 정보 추가
			if isAuth == true {
				// 인증 모드: OAuth (기본 설정)
				// 인증 헤더 추가
				if KB.Auth.isSigned == true && KB.Auth.authType == .oauth {
					if let token = KB.UserData.userToken {
						request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
					}
				}
				else {
                    //DispatchQueue.main.async { AlertPopupViewController(title: "REST API", message: "OAuth 로그인 유저가 아닙니다.").show() } 
                }
			}
			else {
				// 비인증 모드
				// 인증 헤더 추가 안 함
			}
			
			// Body
			do {
				try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
			}
			catch let error {
				print("API Error: \(error.localizedDescription)")
				return
			}
			//print(request)
			
			URLSession.shared.dataTask(with: request) { (data, response, error) -> Void in
				
				// Error Check
				guard error == nil else {
//                    self.showErrorPopup()
					completionHandler(nil, error)
					return
				}
				
				// Response Check
                if let response = response as? HTTPURLResponse{
                    if 500...599 ~= response.statusCode{
                        self.showErrorPopup()
                        completionHandler(nil, error)
                        return
                    }
                }
				guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
				//print("REST API Response:", response)
				
				// Data Check
				guard let data = data else {
					completionHandler(nil, NSError(domain: "DataNilError", code: -100001, userInfo: nil))
					return
				}
				
				completionHandler(data, nil)
				
			}.resume()
		}
	}
    
    //레드마인 #10603
    public func showErrorPopup(){
        DispatchQueue.main.async {
            if let vc = UIApplication.shared.getCurrentViewController() {
                ErrorPopupViewController(sender: vc, msg: "처리 중 에러가 발생하였습니다.\n다시 시도해 주세요.\n지속될 시 서비스데스크로 연락 부탁드립니다.").show()
            }
        }
    }
}
