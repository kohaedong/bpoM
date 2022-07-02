//  Desc : 모듈 인터페이스
//
//  Kolonbase.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import Foundation

@objc public class Kolonbase: NSObject {
	
    @objc static let shared = Kolonbase()
	
	private override init() {}
	
    @objc public let Auth = KBAuth.shared         // 인증 관련
    @objc public let API = KBAPI.shared           // API 통신
    @objc public let Crypto = KBCrypto.shared     // 암호화
    @objc public let Detect = KBDetect.shared     // 권한
    @objc public let KeyChain = KBKeychain.shared // 키체인 관련
    @objc public let Member = KBMember.shared     // 임직원 조회
    @objc public let Notice = KBNotice.shared     // 공지
    @objc public let Splash = KBSplash.shared     // 스플래쉬
    @objc public let UserData = KBUserData.shared // 유저 정보
    @objc public let Update = KBUpdate.shared     // 업데이트
    
//    @objc public let Constant = KBConstants.shared
}

public let KB = Kolonbase.shared
