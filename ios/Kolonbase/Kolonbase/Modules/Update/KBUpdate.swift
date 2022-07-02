//  Desc : 업데이트
//
//  KBUpdate.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import UIKit

// MARK: -  KB Update
public class KBUpdate: NSObject {
	
	static let shared = KBUpdate()
	
	private override init() {}
	
    // 최신 버전 정보 (서버)
    var versionInfo: KBUpdateInfo?
    
	// 사용자 버전 정보
	@objc public var currentAppVersion: String {
		get {
			guard let dictionary = Bundle.main.infoDictionary,
				  let version = dictionary["CFBundleShortVersionString"] as? String else { return "0.0" }
			return version
		}
	}
	
    @objc public var currentBuildNumber: String {
		get {
			guard let dictionary = Bundle.main.infoDictionary,
				  let build = dictionary["CFBundleVersion"] as? String else { return "0" }
			return build
		}
	}
	
    @objc public var currentResourceDate: String {
		get {
			guard let version = KB.UserData.resourceDate else { return "0" }
			return version
		}
		set {
			KB.UserData.resourceDate = newValue
		}
	}
	
	// 서비스 버전 정보
    @objc public var latestAppVersion: String {
		get {
			guard let version = KB.UserData.lastestAppVersion else { return currentAppVersion }
			return version
		}
		set {
			KB.UserData.lastestAppVersion = newValue
		}
	}
	
    @objc public var latestBuildNumber: String {
		get {
			guard let version = KB.UserData.lastestBuildNumber else { return "0" }
			return version
		}
		set {
			KB.UserData.lastestBuildNumber = newValue
		}
	}
    @objc public var latestResourceDate: String {
		get {
			guard let version = KB.UserData.lastestResourceDate else { return "000000000000" }
			return version
		}
		set {
			KB.UserData.lastestResourceDate = newValue
		}
	}
}

// MARK: - 앱 업데이트 체크
@objc public class KBUpdateInfo: NSObject, Codable {
	
    @objc public var appVerDscr: String
    @objc public var hckMngYn: String
    @objc public var updateKind: String
    @objc public var cmpsYn: String
    @objc public var appUpdUrlAddr: String
    @objc public var scrnshtPrevntYn: String
    @objc public var message: String
    @objc public var currentVersion: String
    @objc public var targetVersion: String
    @objc public var result: String
    @objc public var appInstallAddr: String
    @objc public var wtmkUseYn: String
    @objc public var targetVersionId: Int
}

extension KBUpdate {
    
    @objc public func checkAppVersionInfo() -> KBUpdateInfo? {
        
        var result: KBUpdateInfo?
        
        let semaphore = DispatchSemaphore(value: 0)
        
        var userId = KB.Auth.userAccount ?? ""
//        if KB.UserData.isStoreUserId == true,KB.UserData.isAutoUserLogin == true {
//            userId = KB.UserData.userId
//        }
        
        if KB.KeyChain.isStoreUserId == true, KB.KeyChain.isAutoUserLogin == true {
            userId = KB.KeyChain.userId
        }
        
        let params = [
            "methodName":"updateCheck",
            "methodParam": [
                "currentVersion": currentAppVersion,
                "userId":userId
            ]
        ] as [String : Any]
        print(params)
        
        KB.API.postRESTAPI(isAuth: false, method: "rest", params: params, completionHandler: { (data, error) in
            // isAuth: false - 비인증 모드 API
            
            print(error as Any)
            print(data as Any)
            
            // 응답 데이터가 없으면 종료
            guard let data = data else {
                result = nil
                semaphore.signal()
                return
            }
            
            do {
                // 업데이트 응답 데이터 파싱
                let response = try JSONDecoder().decode(KBDataResponse<KBUpdateInfo>.self, from: data)
                print(response)
                
                if let info = response.data {
                    
                    self.versionInfo = info
                    
                    // 검출 대상자 체크 - 루팅 검출, 워터마크 표시, 화면 캡처
                    //KB.Auth.isDetectRootingUser = info.hckMngYn == "y" ? true: false
                    //KB.Auth.isShowWatermarkUser = info.wtmkUseYn == "y" ? true: false
                    //KB.Auth.isAllowScreenshotUser = info.scrnshtPrevntYn == "y" ? true: false
                                        
                    let targetVersion = self.versionInfo?.targetVersion ?? ""
                    if targetVersion.count == 0 {
                        self.latestAppVersion = self.currentAppVersion
                    }else{
                        self.latestAppVersion = targetVersion
                    }

                    if info.result == "NG" {
                        // 업데이트 안 함
                        result = nil
                    }
                    else {
                        // 최신 업데이트 버전 정보 저장
                        result = info
                    }
                }
                else {
                    
                    result = nil
                }
            }
            catch _ {
                
                result = nil
            }
            
            semaphore.signal()
        })
        
        _ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result

    }
    
	// 버전 체크
   public func checkAppVersion() -> Result<KBUpdateInfo?, Error>? {
       
		var result: Result<KBUpdateInfo?, Error>?
		
		let semaphore = DispatchSemaphore(value: 0)
        
        var userId = KB.Auth.userAccount ?? ""
//        if KB.UserData.isStoreUserId == true,KB.UserData.isAutoUserLogin == true {
//            userId = KB.UserData.userId
//        }
        if KB.KeyChain.isStoreUserId == true, KB.KeyChain.isAutoUserLogin == true {
            userId = KB.KeyChain.userId
        }
        
        let params = [
            "methodName":"updateCheck",
            "methodParam": [
				"currentVersion": currentAppVersion,
				"userId":userId
            ]
        ] as [String : Any]
		print(params)
        
		KB.API.postRESTAPI(isAuth: false, method: "rest", params: params, completionHandler: { (data, error) in
			// isAuth: false - 비인증 모드 API
            
            print(error as Any)
            print(data as Any)
            
			// 응답 데이터가 없으면 종료
            guard let data = data else {
				result = .success(nil)
				semaphore.signal()
				return
			}
            
            do {
                // 업데이트 응답 데이터 파싱
                let response = try JSONDecoder().decode(KBDataResponse<KBUpdateInfo>.self, from: data)
				print(response)
				
				if let info = response.data {
					
					self.versionInfo = info
					
					// 검출 대상자 체크 - 루팅 검출, 워터마크 표시, 화면 캡처
					//KB.Auth.isDetectRootingUser = info.hckMngYn == "y" ? true: false
					//KB.Auth.isShowWatermarkUser = info.wtmkUseYn == "y" ? true: false
					//KB.Auth.isAllowScreenshotUser = info.scrnshtPrevntYn == "y" ? true: false
                                        
                    let targetVersion = self.versionInfo?.targetVersion ?? ""
                    if targetVersion.count == 0 {
                        self.latestAppVersion = self.currentAppVersion
                    }else{
                        self.latestAppVersion = targetVersion
                    }

					if info.result == "NG" {
						// 업데이트 안 함
						result = .success(nil)
					}
					else {
						// 최신 업데이트 버전 정보 저장
						result = .success(info)
					}
				}
				else {
					
					result = .success(nil)
				}
            }
            catch let error {
                
                result = .failure(error)
            }
			
			semaphore.signal()
        })
		
		_ = semaphore.wait(wallTimeout: .distantFuture)
        
        return result
	}
    
    @objc public func checkBuildVersion(confirm: (() -> Void)?, cancel: (() -> Void)?) -> Bool {
		
		guard currentBuildNumber != latestBuildNumber else { return true }
		
		// 앱 빌드 업데이트 알림
		let popUp = ConfirmPopupViewController()
		popUp.titleString = "앱 빌드 업데이트"
		popUp.messageString = "IKEN 앱의 최신 빌드 업데이트가 있습니다.\n업데이트를 하시겠습니까?\n\n(현재 빌드: \(currentAppVersion) \(currentBuildNumber))\n(최신 빌드: \(latestAppVersion) \(latestBuildNumber))"
        popUp.confirmHandler = confirm
        popUp.cancelHandler = cancel
		
		let vc = UIApplication.shared.getCurrentViewController()
		vc?.present(popUp, animated: false, completion: nil)
		
		return false
	}
	
    public func checkResourceVersion(confirm: (() -> Void)?, cancel: (() -> Void)?) -> Bool {
		
		guard currentResourceDate != latestResourceDate else { return true }
		
		// 앱 리소스 업데이트 알림
		let popUp = ConfirmPopupViewController()
		popUp.titleString = "앱 리소스 업데이트"
        popUp.messageString = "IKEN 앱에 업데이트 할 리소스가 있습니다.\n업데이트를 진행하시겠습니까?\n\n(현재 리소스: \(currentResourceDate == "0" ?  "없음": currentResourceDate))\n(최신 리소스: \(latestResourceDate))"
        popUp.confirmHandler = confirm
        popUp.cancelHandler = cancel
		
		let vc = UIApplication.shared.getCurrentViewController()
		vc?.present(popUp, animated: false, completion: nil)
		
		return false
	}
}

extension KBUpdate {
	
	// 앱 버전 업데이트 체크 - 응답 UI 처리가 포함되어 있음
    @objc public func checkAppVersionWithUI(completionHandler:  @escaping () -> Void) {
		
		let result = KB.Update.checkAppVersion()
		
		switch result {
			
			case .success(let userInfo):
				if let info = userInfo {
					
					// 현재 버전이 최신 버전과 다르면 업데이트 진행
					if KB.Update.currentAppVersion != KB.Update.latestAppVersion {
						
						// 현재 버전이 최신 버전과 다르면, 앱 버전 업데이트 알림
						var updateMessage = ""
						if info.cmpsYn == "y" {
							// 강제형 업데이트
							updateMessage = "업데이트 사항이 있습니다.\n업데이트를 하셔야\n서비스 이용이 가능합니다.\n[취소]를 누르실 경우 앱이 종료 됩니다.\n\n\(info.appVerDscr)"
						}
						else {
							// 선택형 업데이트
							updateMessage = "업데이트 사항이 있습니다.\n업데이트를 진행 하시겠습니까?\n\n\(info.appVerDscr)"
						}
                        let title = "앱 업데이트"
                        if let vc = UIApplication.shared.getCurrentViewController(), vc.title == title {
                             return
                        }
						DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
							let vc = ConfirmPopupViewController(
								title: nil,
								message: updateMessage,
								confirm: { () -> Void in
									// 확인 버튼을 누르면, 앱 업데이트 링크로 전환
                                    
//                                    var url = ""
//                                    if info.updateKind == "web"{
//                                        url = info.appUpdUrlAddr
//                                    }else{
//                                        url = info.appUpdUrlAddr
//                                    }
									guard let settingsUrl = URL(string: info.appUpdUrlAddr) else {
                                        completionHandler()
                                        return
                                    }
									if UIApplication.shared.canOpenURL(settingsUrl) {
                                        UIApplication.shared.open(settingsUrl, options: [:]) { completed in
                                            UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
                                            if info.cmpsYn == "y" {
                                                // 강제 업데이트 모드일 때,
                                                exit(0)
                                            }else{
                                                completionHandler()
                                            }
                                        }
									}
								},
								cancel: { () -> Void in
									if info.cmpsYn == "y" {
                                        // 강제 업데이트 모드일 때,
                                        exit(0)
                                    }else{
                                        completionHandler()
                                    }
								})
                            vc.title = title
                            vc.show()
						}
					}
				}
				else {
					//print("No Update Data")
					//AlertPopupViewControllertitle: "앱 업데이트", message: "업데이트 정보가 없습니다.", completion: nil).show()
					completionHandler()
				}
				
			case .failure(let error):
				DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
					AlertPopupViewController(title: "앱 업데이트 에러", message: error.localizedDescription, completion: nil).show()
				}
				
			default:
				break
		}
	}
}
