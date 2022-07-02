//  Desc : 루팅, 워터마크 표시, 스크린샷 검출
//
//  KBDetect.swift
//  Kolonbase
//
//  Created by mk on 2020/10/21.
//

import UIKit

// MARK: -  KB Detect
public class KBDetect: NSObject {
	
	static let shared = KBDetect()
		
	private override init() {}
    
    var hckMngYn : Bool?
    
    var permissionData : KBPermissionItem?{
        didSet{
            if let item = permissionData {
                KB.Auth.isDetectRootingUser = item.hckMng
                KB.Auth.isShowWatermarkUser = item.wtmkUse
                KB.Auth.isAllowScreenshotUser = item.scrnshtPrevnt
            }
        }
    }
    
    public var screenShotNotiReturn: NSObjectProtocol?
}

extension KBDetect{
    
    @objc public func permissionCheck(completionHandler:  @escaping () -> Void) {
                
        guard let userId = KB.Auth.userAccount else{
            return
        }
        
        KB.API.getRESTAPI(method: "participant/accessibleApp/\(KB.API.appId)/\(userId)", params: nil) { data, error in
            
            guard let data = data else { return }
            
            do {
                
                let result = try JSONDecoder().decode(KBDataResponse<KBPermissionItem>.self, from: data)
                guard let data = result.data else { return }
                
                self.permissionData = data
                
                if data.accessApp == false{
                    DispatchQueue.main.async {
                        ErrorPopupViewController(sender: nil,
                                                 msg: "IKEN 사용 권한이 없습니다.\n권한 요청 후 다시 시도해보세요.") {
                            KB.UserData.isAutoUserLogin = false
                            KB.KeyChain.isAutoUserLogin = false
                            exit(0)
                        }.show()
                    }
                }else{
                    completionHandler()
                }
            }
            catch _ {
                
            }
        }
    }
}

public struct KBPermissionItem: Codable {
    
    var accessMsg: String
    var accessApp: Bool
    var scrnshtPrevnt: Bool
    var wtmkUse: Bool
    var hckMng: Bool
}
