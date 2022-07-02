//  Desc : 로컬 데이터 저장(앱 그룹)
//
//  KBUserData.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import Foundation
import UIKit

// MARK: -  KB Data(DB)
public class KBUserData: NSObject {
	
	static let shared = KBUserData()
	
	private override init() {}
	
	//let keychainServiceName = Bundle.main.bundleIdentifier ?? "group.com.kolon.ikenapp2dev"
	let userDataSuiteName = "group.com.kolon.ikenapp2"	// 개발/릴리즈 상관없이 같은 앱 그룹 사용
	
	// MARK: - UserData
	public func set(key: String, value: Any) {
		
		UserDefaults(suiteName: userDataSuiteName)?.setValue(value, forKey: key)
	}
	
	public func get(key: String) -> Any? {
		
		let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: key)
		return data
	}
	
	
	// MARK: - 로그인 정보
	// 사용자 아이디 저장 플래그
	public var isStoreUserId: Bool {
		
		get { UserDefaults(suiteName: userDataSuiteName)?.bool(forKey: "is_store_user_id") ?? false }
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "is_store_user_id") }
	}
	
	// 사용자 자동 로그인 플래그
	public var isAutoUserLogin: Bool {
		
		get { UserDefaults(suiteName: userDataSuiteName)?.bool(forKey: "is_auto_user_login") ?? false }
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "is_auto_user_login") }
	}
	
	// 사용자 아이디
	public var userId: String {
		
		get {
			var text = ""
			if let data = UserDefaults(suiteName: userDataSuiteName)?.data(forKey: "user_id") {
				text = KB.Crypto.decrypt(data: data) ?? ""
			}
			return text
		}
		set {
			let data = KB.Crypto.encrypt(text: newValue) ?? nil
			UserDefaults(suiteName: userDataSuiteName)?.setValue(data, forKey: "user_id")
		}
	}
	
	// 사용자 패스워드
	public var userPw: String {
		
		get {
			var text = ""
			if let data = UserDefaults(suiteName: userDataSuiteName)?.data(forKey: "user_pw") {
				text = KB.Crypto.decrypt(data: data) ?? ""
			}
			return text
		}
		set {
			let data = KB.Crypto.encrypt(text: newValue) ?? nil
			UserDefaults(suiteName: userDataSuiteName)?.setValue(data, forKey: "user_pw")
		}
	}
	
	// FCM 토큰
	public var userFcm: String {
		
		get { UserDefaults(suiteName: userDataSuiteName)?.string(forKey: "user_fcm") ?? ""}
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "user_fcm") }
	}
	
	// MARK: - 인증 정보
	// 사용자 액세스 토큰
	public var userToken: String? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "user_token") {
				
				return data as? String
			}
			else {
				
				return nil
			}
		}
		
		set(value) {
			
			if let token = value {
				
				UserDefaults(suiteName: userDataSuiteName)?.setValue(token, forKey: "user_token")
			}
		}
	}
	
	public var refreshToken: String? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "refresh_token") {
				
				return data as? String
			}
			else {
				
				return nil
			}
		}
		
		set {
			
			UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "refresh_token")
		}
	}
	
	// 토큰 만료 시간
	public var expiresIn: Int? {
		
		get { UserDefaults(suiteName: userDataSuiteName)?.integer(forKey: "expires_in") }
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "expires_in") }
	}
	
	// 토큰 만료 일시
	public var expiresDate: Date? {
		
		get {
			guard let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "expires_date") else { return nil }
			return data as? Date
		}
		
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "expires_date") }
	}
	
	// 사용자 정보 토큰
	var userInfo: KBUserInfo? {
		
		get {
			guard let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "user_info") as? Data else { return nil }
			let decoder = JSONDecoder()
			let userInfo = try? decoder.decode(KBUserInfo.self, from: data)
			return userInfo
		}
		
		set {
			let encoder = JSONEncoder()
			guard let json = try? encoder.encode(newValue) else { return }
			UserDefaults(suiteName: userDataSuiteName)?.setValue(json, forKey: "user_info")
		}
	}
	
	
	// MARK: - 업데이트 정보
	// 사용자 디바이스 UUID
	public var uuid: String {
		
		get {
			if let uuid = UserDefaults(suiteName: userDataSuiteName)?.string(forKey: "user_uuid") {
				
				return uuid as String
			}
			else {
				
				let uuid = UUID().uuidString
				UserDefaults(suiteName: userDataSuiteName)?.setValue(uuid, forKey: "user_uuid")
				
				return uuid
			}
		}
	}
	
	// 업데이트 버전
	public var resourceDate: String? {
		get {
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "resource_date") {
				return data as? String
			}
			else {
				return nil
			}
		}
		set {
			if let token = newValue {
				UserDefaults(suiteName: userDataSuiteName)?.setValue(token, forKey: "resource_date")
			}
		}
	}
	
	public var lastestAppVersion: String? {
		get {
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "lastest_app_version" + (KB.KeyChain.isDev ? "_dev" : "")) {
				return data as? String
			}
			else {
				return nil
			}
		}
		set {
			if let token = newValue {
                UserDefaults(suiteName: userDataSuiteName)?.setValue(token, forKey: "lastest_app_version" + (KB.KeyChain.isDev ? "_dev" : ""))
			}
		}
	}
	
	public var lastestBuildNumber: String? {
		get {
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "lastest_build_number" + (KB.KeyChain.isDev ? "_dev" : "")) {
				return data as? String
			}
			else {
				return nil
			}
		}
		set {
			if let token = newValue {
				UserDefaults(suiteName: userDataSuiteName)?.setValue(token, forKey: "lastest_build_number" + (KB.KeyChain.isDev ? "_dev" : ""))
			}
		}
	}
	
	public var lastestResourceDate: String? {
		get {
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "lastest_resource_date") {
				return data as? String
			}
			else {
				return nil
			}
		}
		set {
			if let token = newValue {
				UserDefaults(suiteName: userDataSuiteName)?.setValue(token, forKey: "lastest_resource_date")
			}
		}
	}
	
	// 튜토리얼 표시 여부
	public var isShowedTutorial: Bool {
		get { UserDefaults(suiteName: userDataSuiteName)?.bool(forKey: "is_show_tutorial") ?? false }
		set { UserDefaults(suiteName: userDataSuiteName)?.setValue(newValue, forKey: "is_show_tutorial") }
	}
	
	// 사용자 설정 폰트 사이즈
	public var userFontSize: Int? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "user_font_size") {
				
				return data as? Int
			}
			else {
				
				return nil
			}
		}
		
		set {
			
			if let count = newValue {
				
				UserDefaults(suiteName: userDataSuiteName)?.setValue(count, forKey: "user_font_size")
			}
		}
	}
	
    public func getFontSize(_ font: UIFont) -> UIFont{
        
        var size = font.pointSize
        switch KB.UserData.userFontSize {
        case 0:
            size = font.pointSize - 2
        case 2:
            size = font.pointSize + 2
        case 3:
            size = font.pointSize + 4
        default:
            return font
        }
        
        if font.fontName.contains("SFUI") {
            if font.fontName.contains("Bold") {
                return UIFont.boldSystemFont(ofSize: size)
            }
            return UIFont.systemFont(ofSize: size)
        }
        return UIFont.init(name: font.fontName, size: size) ?? font
    }
    
	// 검색어
	var searchedList: [String]?	// No Use.
	
	// 멤버 검색어 히스토리
	public var searchMemeberList: [String]? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "search_member_list") {
				
				return data as? [String]
			}
			else {
				
				return nil
			}
		}
		
		set(value) {
			
			if let date = value {
				
				UserDefaults(suiteName: userDataSuiteName)?.setValue(date, forKey: "search_member_list")
			}
		}
	}
	
	// 키워드 검색어 히스토리
	public var searchWordList: [String]? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "search_word_list") {
				
				return data as? [String]
			}
			else {
				
				return nil
			}
		}
		
		set(value) {
			
			if let date = value {
				
				UserDefaults(suiteName: userDataSuiteName)?.setValue(date, forKey: "search_word_list")
			}
		}
	}
	
	// 홈 탭 설정 - WORK, NEWS, MY
	public var userHomeTab: String? {
		
		get {
			
			if let data = UserDefaults(suiteName: userDataSuiteName)?.value(forKey: "user_home_tab") {
				
				return data as? String
			}
			else {
				
				return nil
			}
		}
		
		set {
			
			if let string = newValue {
				
				UserDefaults(suiteName: userDataSuiteName)?.setValue(string, forKey: "user_home_tab")
			}
		}
	}
    
    public var userTmpToVC: String?
}

//extension SealedBox: Encodable, Decodable {
//
//	public init(from decoder: Decoder) throws {}
//
//	public func encode(to encoder: Encoder) throws {}
//}
