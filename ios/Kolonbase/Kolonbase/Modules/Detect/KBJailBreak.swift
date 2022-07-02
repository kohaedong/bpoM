//  Desc : 루팅
//
//  KBJailBreak.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import UIKit

// MARK: - Detect Jailbreak
extension KBDetect {
	
	@objc public func checkRooting() {
        
		// 인증 정보가 있을 경우
        if KB.Auth.isSigned == true {
            
			// 루팅 검출 예외 사용자 체크 - 업데이트 API에서 받은 정보로 설정됨
			guard KB.Auth.isDetectRootingUser == true else { return }
        }
		
        #if targetEnvironment(simulator)
            guard isJailbroken() == false else { return }
        #else
            guard isJailbroken() == true else { return }
        #endif
		
		// 얼럿 표시
		let alert = UIAlertController(title: "루팅 체크", message: "Jailbreak 된 장비입니다.", preferredStyle: .alert)
		let confirm = UIAlertAction(title: "확인", style: .default) { (action) in
			// 애플리케이션 종료(서스펜드 모드로)
			UIControl().sendAction(#selector(URLSessionTask.suspend), to: UIApplication.shared, for: nil)
		}
		alert.addAction(confirm)
		alert.show()
	}
	
	func isJailbroken() -> Bool {
        
        if let yn = hckMngYn {
            return yn
        }
		guard let cydiaUrlScheme = NSURL(string: "cydia://package/com.example.package") else {
            hckMngYn = false
            return false
        }
		
		if UIApplication.shared.canOpenURL(cydiaUrlScheme as URL) {
            hckMngYn = true
            return true
		}
				
		let fileManager = FileManager.default
		
		if fileManager.fileExists(atPath: "/Applications/Cydia.app") ||
			fileManager.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
			fileManager.fileExists(atPath: "/bin/bash") ||
			fileManager.fileExists(atPath: "/usr/sbin/sshd") ||
			fileManager.fileExists(atPath: "/etc/apt") ||
			fileManager.fileExists(atPath: "/usr/bin/ssh") ||
			fileManager.fileExists(atPath: "/private/var/lib/apt") {
            hckMngYn = true
			return true
		}
		
		if canOpen(path: "/Applications/Cydia.app") ||
			canOpen(path: "/Library/MobileSubstrate/MobileSubstrate.dylib") ||
			canOpen(path: "/bin/bash") ||
			canOpen(path: "/usr/sbin/sshd") ||
			canOpen(path: "/etc/apt") ||
			canOpen(path: "/usr/bin/ssh") {
            hckMngYn = true
			return true
		}
		
		let path = "/private/" + NSUUID().uuidString
		
		do {
			
			try "anyString".write(toFile: path, atomically: true, encoding: String.Encoding.utf8)
			try fileManager.removeItem(atPath: path)
            hckMngYn = true
			return true
		}
		catch {
            hckMngYn = false
			return false
		}
	}
	
	func canOpen(path: String) -> Bool {
		
		let file = fopen(path, "r")
		
		guard file != nil else { return false }
		
		fclose(file)
		
		return true
	}
}
