//  Desc : 키체인 저장
//
//  KBKeyChain.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import Foundation

let kKeyChainUserIdKey       = "ID"           // 아이디
let kKeyChainPasswordKey     = "PW"           // 패스워드
let kKeyChainSaveIDKey       = "SAVEID"       // 아이디 저장 구분 (Y/N)
let kKeyChainAutoLoginKey    = "AUTOLOGIN"    // 자동로그인 구분 (Y/N)
let kKeyChainAppLinkKey      = "APPLINK"      // 타 앱 실행여부 (Y/N)
let kKeyChainParamKey        = "PARAM"        // 타 앱 실행시 넘길 파라미터 (데이터가 다수면 ^ 로 구분)

// MARK: -  KB Keychain
public class KBKeychain: NSObject {
	
	static let shared = KBKeychain()
    
    let miaps: MiapsFramework = MiapsFramework()
    
    private let APP_ID = "5HTJST6WX6"
    
    private var COMPANYCODE: String {
        get {
            guard let dictionary = Bundle.main.infoDictionary,
                  let code = dictionary["MiapsCompanyCode"] as? String else { return "KOLON" }
            return code
        }
    }
    public var isDev : Bool{
        get{
            return COMPANYCODE == "KOLONDEV"
        }
    }
	private override init() {}
	
	// MARK: - KeyChain
	public func set(key: String, value: String) {
        miaps.saveKeyChain(APP_ID, group: COMPANYCODE, key: key, value: value)
        
	}
    
	public func get(key: String) -> String? {
        return miaps.loadKeyChain(APP_ID, group: COMPANYCODE, key: key)
	}
	
	// 사용자 아이디
    @objc public var userId: String {
        get {
            let id = get(key: kKeyChainUserIdKey) ?? ""
            return id.decodeMiaps
        }
        set {
            let newId = newValue.encodeMiaps
            set(key: kKeyChainUserIdKey, value: newId)
        }
	}
	
	// 사용자 패스워드
    @objc public var userPw: String {
        get {
            let pwd = get(key: kKeyChainPasswordKey) ?? ""
            return pwd.decodeMiaps
        }
        set {
            let newPwd = newValue.encodeMiaps
            set(key: kKeyChainPasswordKey, value: newPwd)
        }
	}
    
    @objc public var isStoreUserId: Bool {
        get { get(key: kKeyChainSaveIDKey) == "Y" ? true : false }
        set { set(key: kKeyChainSaveIDKey, value: newValue == true ? "Y" : "N") }
    }
    
    @objc public var isAutoUserLogin: Bool {
        get { get(key: kKeyChainAutoLoginKey) == "Y" ? true : false }
        set { set(key: kKeyChainAutoLoginKey, value: newValue == true ? "Y" : "N") }
    }
    
}
