//  Desc : 공지
//
//  KBNotice.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import UIKit
//import Firebase

// MARK: -  KB Notice
public class KBNotice: NSObject {
	
	static let shared = KBNotice()

//    var ref: DatabaseReference!

    public var isNoticeCheck = false
    
    @objc public var noticeCheckCompleted: (() -> Void)?

	private override init() {}
	
    var splashImage : UIImage?
    
	var noticeData: KBNoticeData? {
		
		didSet {
            DispatchQueue.main.async { [self] in
                
                guard let data = noticeData else { return }
                var list : [KBNoticeItem] = []
                
                if KB.Auth.isSigned == false {
                    
                    if let datas = data.noticeError, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                    if let datas = data.noticeWorking, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                 
                }else{
                    if let datas = data.noticeFullScreen, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                    if let datas = data.noticePopup, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                    if let datas = data.noticeUrl, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                    if let datas = data.noticeSurvey, datas.count > 0 {
                        list.append(contentsOf: datas)
                    }
                }
                
                if let order = data.noticeOrder {
                    
                    var items : [KBNoticeItem] = []
                    for id in order {
                        if let item = list.filter({$0.id == id}).first{
                            items.append(item)
                        }
                    }
                    self.noticeItems = items
                    showNotice()
                }
            }
		}
	}
    
    var noticeItems : [KBNoticeItem] = []
    
    func showNotice(){
        
        DispatchQueue.main.async { [self] in
            if let item = noticeItems.first {
                
                // 앱설치 체크
                if let scheme = item.relyAppSchm {
                    if let url = URL(string: scheme) {
                        if UIApplication.shared.canOpenURL(url) {
                            noticeItems.removeFirst()
                            self.showNotice()
                            return
                        }
                    }
                }
                
                let vc = KBNoticeViewController().initWith(item: item)
                vc?.dismissAction = {
                    self.showNotice()
                }
                vc?.show()
                noticeItems.removeFirst()
            }else{
                if KB.Auth.isSigned == true{
                    isNoticeCheck = true
                }
                if let action = noticeCheckCompleted{
                    action()
                }
            }
        }
    }
	
}

// MARK: - 공지 체크
public struct KBNoticeData: Codable {
	
	var noticeError: [KBNoticeItem]?
	var noticeWorking: [KBNoticeItem]?
    var noticeUrl: [KBNoticeItem]?
    var noticeSurvey: [KBNoticeItem]?
	var noticeFullScreen: [KBNoticeItem]?
	var noticePopup: [KBNoticeItem]?
    var noticeOrder: [Int]?
}

public struct KBNoticeItem: Codable {
	
	var id: Int
	var appIdParticipant: String?
	var targetParticipant: String?
	var appNtcGbCd: String?
	var appNtcSbjctNm: String?
	var appCbgtYn: String?
	var ntcExclYn: String?
	var ntcBltnDttm: String?
	var ntcEndDttm: String?
	var ntcTmpltCd: String?
	var ntcDscr: String?
	var ntcLnkAddr: String?
	var creatrNm: String?
	var creatrId: String?
	var modrId: String?
	var creatDttm: String?
	var modDttm: String?
    var relyAppId : Int?
    var recnfrmYn: String?
    var ext : String?
    var relyAppSchm : String?
}

struct SplashInfo : Codable{
    let id:Int?
    let appId:Int?
    let appNm:String?
    let appPkgNm:String?
    let sbjctNm:String?
    let useYn:String?
    let attfileNm:String?
    let imageFileData:String?
    let userName:String?
    let creatrId:String?
    let modrId:String?
    let creatDttm:String?
    let modDttm:String?
    let ext:String?
}

extension KBNotice {
    
    // MARK: - REST API: 공지 조회 + 에러처리 추가
    public func checkKBNotice(completionHandler: @escaping (Data?, Error?) -> Void) {
        
        if isNoticeCheck == true {
            if let action = noticeCheckCompleted{
                action()
            }
            return
        }
        
        let deviceId = KB.UserData.uuid
        
        var userId = KB.Auth.userAccount ?? ""
        
        
        if KB.KeyChain.isAutoUserLogin {
            userId = KB.KeyChain.userId
        }
        
//        if KB.KeyChain.isDev {
//            if KB.UserData.isAutoUserLogin {
//                userId = KB.UserData.userId
//            }
//        }
        
        let params = [
            "methodName": "noticeAll",
            "methodParam": [
                "userId": userId,
                "devId": deviceId
            ]
        ] as [String : Any?]
        print(params)
        
        KB.API.postRESTAPI(isAuth: KB.Auth.isSigned, method: "rest", params: params, completionHandler: { (data, error) in
            
            print(error as Any)
            print(data as Any)
            
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            completionHandler(data, nil)
            
            do {
                                
                // 업데이트 응답 데이터 파싱
                let result = try JSONDecoder().decode(KBDataResponse<KBNoticeData>.self, from: data)
                //print(result)
                
                guard let retData = result.data else { return }
                print(retData)
                self.noticeData = retData
                completionHandler(data, nil)
            }
            catch _ {
                if let action = self.noticeCheckCompleted{
                    action()
                }
            }
        })
        
        return
    }
    
    // MARK: - REST API: 공지 조회
    @objc public func checkKBNotice() {
        
        if isNoticeCheck == true {
            if let action = noticeCheckCompleted{
                action()
            }
            return
        }
        
		let deviceId = KB.UserData.uuid
        
        var userId = KB.Auth.userAccount ?? ""
        
        
        if KB.KeyChain.isAutoUserLogin {
            userId = KB.KeyChain.userId
        }
        
//        if KB.KeyChain.isDev {
//            if KB.UserData.isAutoUserLogin {
//                userId = KB.UserData.userId
//            }
//        }
        
        let params = [
            "methodName": "noticeAll",
			"methodParam": [
				"userId": userId,
				"devId": deviceId
			]
        ] as [String : Any?]
		print(params)
        
        KB.API.postRESTAPI(isAuth: KB.Auth.isSigned, method: "rest", params: params, completionHandler: { (data, error) in
            
            print(error as Any)
            print(data as Any)
            
            guard let data = data else { return }
            
            do {
                                
                // 업데이트 응답 데이터 파싱
                let result = try JSONDecoder().decode(KBDataResponse<KBNoticeData>.self, from: data)
                //print(result)
                
				guard let data = result.data else { return }
				print(data)
                self.noticeData = data
            }
            catch _ {
                if let action = self.noticeCheckCompleted{
                    action()
                }
            }
        })
        
        return
    }
	
    public func saveNoticeTodayHide(id : Int?) {
        
        guard let id = id else{
            return
        }
        
        let params = [
            "methodName": "saveNoticeTodayHide",
            "methodParam": [
                "noticeId": id,
                "userId": KB.Auth.userAccount ?? ""
            ]
        ] as [String : Any?]
        print(params)

        KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
            
            print(error as Any)
            print(data as Any)
            
            guard data != nil else { return }
            
        })
        
        return
    }
    
    // 파이어베이스 장애 공지
    public func checkFBNotice() -> Result<Bool, Error>? {
        
//        ref = Database.database().reference()
//        self.ref.child("notices").getData { (error, snapshot) in
//            if let error = error {
//                print("Error getting data \(error)")
//            }
//            else if snapshot.exists() {
//                print("Got data \(snapshot.value!)")
//            }
//            else {
//                print("No data available")
//            }
//        }
        
		var result: Result<Bool, Error>?
		
		let semaphore = DispatchSemaphore(value: 0)
				
        if let url = URL(string: fcmNotice_host) {
			
			URLSession.shared.reset {
				//print("URLSession Cache Clear")
			}
			
			URLSession.shared.dataTask(with: url) { data, response, error in

				if let data = data {
					
					if let string = String(data: data, encoding: .utf8) {
						
						if let start = string.endIndex(of: "<title>"),
						   let end = string.index(of: "</title>") {
							
							let title = string[start ..< end]
							
							if title == "Page Not Found" {
								// 표시할 공지 없음: 잘못된 링크일 경우 파이어베이스 호스팅은 기본 에러 페이지로 공지 표시 유무를 판단한다.
							}
							else {
								
								// 장애 공지 표시
								DispatchQueue.main.async {
									
									let v = KBWebViewController()
									v.messageId = "iken_app_trouble"
									v.urlString = fcmNotice_host
									
									if let vc = UIApplication.shared.getCurrentViewController() {
										
										vc.modalPresentationStyle = .fullScreen
										vc.modalTransitionStyle = .crossDissolve
										vc.present(v, animated: true, completion: nil)
									}
								}
							}
						}
					}
						
					result = .success(true)
				}
				else {
					
					result = .failure(NSError(domain: "DataNilError", code: -100001, userInfo: nil))
				}
				
				semaphore.signal()
				
			}.resume()
		}
		
		_ = semaphore.wait(wallTimeout: .distantFuture)
		
		return result
	}
	    
    // 경영지침 관리
    @objc public func loadSpalshImage(completionHandler:  @escaping (UIImage?) -> Void) {
        
        if let image = self.splashImage {
            completionHandler(image)
            return
        }
                
        let params = [
            "methodName":"splash",
            "methodParam": [
                "appId": KB.API.appId
            ]
        ] as [String : Any]

        KB.API.postRESTAPI(isAuth: false,
                           method: "rest",
                           params: params,
                           completionHandler: { (data, error) in
                            
                            guard let data = data else {
                                self.splashImage = nil
                                completionHandler(nil)
                                return
                            }
                            
                            do {
                                let result = try JSONDecoder().decode(KBDataResponse<SplashInfo>.self, from: data)

                                DispatchQueue.main.async {
                                    
                                    if let str = result.data?.imageFileData,
                                       let startIdx = str.endIndex(of: "base64,"){
                                        let result = String(str[startIdx...])
                                        if let imageData = Data(base64Encoded: result),
                                           let image = UIImage(data: imageData){
                                            self.splashImage = image
                                            completionHandler(image)
                                        }else{
                                            self.splashImage = nil
                                            completionHandler(nil)
                                        }
                                    }else{
                                        self.splashImage = nil
                                        completionHandler(nil)
                                    }
                                }
                            }
                            catch _ {
                                self.splashImage = nil
                                completionHandler(nil)
                            }

        })
    }
}
