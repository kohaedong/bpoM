//  Desc : 로그인UI(OAuth)
//
//  LoginViewController.swift
//  Kolonbase-Sample
//
//  Created by mk on 2020/10/14.
//

import UIKit

@objc public protocol LoginWithOAuthViewControllerDelegate {
	
	func performAfterAuthIn(username: String, password: String)
}

class LoginWithOAuthViewController: UIViewController {
	
	// 자동 로그인
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var ikenLogoImageView: UIImageView!
	@IBOutlet weak var kolonLogoImageView: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	// 로그인 입력 화면
	@IBOutlet weak var loginView: UIView!
    @IBOutlet weak var loginViewTopConst: NSLayoutConstraint!
    
	@IBOutlet weak var logoImageView: UIImageView!
	
	@IBOutlet weak var idView: UIView!
	@IBOutlet weak var pwView: UIView!
	
	@IBOutlet weak var idTextField: UITextField!
	@IBOutlet weak var pwTextField: UITextField!
	
	@IBOutlet weak var idClearButton: UIButton!
	@IBOutlet weak var pwClearButton: UIButton!
	
	@IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var messageLabelBottomView: UIView!
    
	@IBOutlet weak var userIdStoreButton: UIButton!
    @IBOutlet weak var userIdStoreLabel: UILabel!
	@IBOutlet weak var userAutoLoginButton: UIButton!
    @IBOutlet weak var userAutoLoginLabel: UILabel!
	@IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var splashImageView: UIImageView!
    
	var delegate: LoginWithOAuthViewControllerDelegate?
	
	var loginViewY: CGFloat = 0.0
    let reachability = try! KBReachability.init()
	
    override public func viewDidLoad() {
		
        super.viewDidLoad()
        
        if let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, targetName.contains("Global") {
            
            idTextField.placeholder = "TR_IKEN3_00093".localized
            pwTextField.placeholder = "TR_IKEN3_00094".localized
            
            messageLabel.text = "TR_IKEN3_00098".localized
            
            //userIdStoreButton.setTitle("TR_IKEN3_00096".localized, for: .normal)
            //userAutoLoginButton.setTitle("TR_IKEN3_00097".localized, for: .normal)
            userAutoLoginLabel.text = "TR_IKEN3_00097".localized
            userIdStoreLabel.text = "TR_IKEN3_00096".localized
            
            loginButton.setTitle("TR_IKEN3_00095".localized, for: .normal)
        }
        
        let paddingRight = (SCREEN_WIDTH - userAutoLoginButton.frame.maxX)
        
        userAutoLoginButton.sizeToFit()
        userAutoLoginButton.frame.size.width += 25
        userAutoLoginButton.frame.origin.x = SCREEN_WIDTH - userAutoLoginButton.frame.width - paddingRight
		
        // UI 설정
		loginViewY = loginView.frame.origin.y
		loginView.center.x = view.center.x
		logoImageView.center.x = loginView.center.x
		
		// 에러 메시지 레이블
		messageLabel.isHidden = true
        messageLabelBottomView.isHidden = true
		
		// ID/PW 설정
        
        if KB.KeyChain.isStoreUserId == true { idTextField.text = KB.KeyChain.userId }
        if KB.KeyChain.isAutoUserLogin == true { pwTextField.text = KB.KeyChain.userPw }
        
        if KB.KeyChain.isDev {
            if KB.UserData.isStoreUserId == true { idTextField.text = KB.UserData.userId }
            if KB.UserData.isAutoUserLogin == true { pwTextField.text = KB.UserData.userPw }
        }
		
		// ID/PW 클리어 버튼 표시
		idClearButton.isHidden = idTextField.text?.count ?? 0 > 0 ? false: true
		pwClearButton.isHidden = pwTextField.text?.count ?? 0 > 0 ? false: true
		
        userIdStoreButton.isSelected = KB.KeyChain.isStoreUserId
        userAutoLoginButton.isSelected = KB.KeyChain.isAutoUserLogin
        
        if KB.KeyChain.isDev {
            // 체크 박스 표시
            userIdStoreButton.isSelected = KB.UserData.isStoreUserId
            userAutoLoginButton.isSelected = KB.UserData.isAutoUserLogin
        }        
        // 레드마인 #10499. 네트워크 미연결인 경우
        if reachability.isConnectedToNetwork == false{
            loginView.isHidden = false
            loadingView.isHidden = true
            return
        }else{
            checkLogin()
            loadSplashImage()
        }
    }
	
	override public func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// 사용자 토큰 삭제
		//UserDefaults(suiteName: userDataSuiteName)?.removeObject(forKey: "user_token")
		
		// 사용자 토큰 확인
//		if let expiresDate = KB.UserData.expiresDate {
//
//			let today = Date()
//			print(today, ">", expiresDate)
//
//			if today > expiresDate {
//
//				// 사용자 액세스 토큰 만료,
//				// 로그인 화면 표시
//			}
//			else {
//
//				// 사용자 액세스 토큰 만료 전,
//				// 리프레시 토큰으로 액세스 토큰 재발급
//				KB.Auth.extendSignIn()
//			}
//		}
		
		// ID/PW 입력 필드 체크
		loginButton.isEnabled = isValidateIdPw()
		
		// 키보드 알림 추가
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        
//        if reachability.isConnectedToNetwork == false{
//            ErrorPopupViewController(sender: self).show()
//            return
//        }
	}
    
    
	
	override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		
		// 키보드 알림 제거
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
        
        UIView.animate(withDuration: 0.4) { [self] in
            loginViewTopConst.constant = 45
            view.layoutIfNeeded()
        }
	}
	  
	@objc private func keyboardWillHide(_ notification: Notification) {
        UIView.animate(withDuration: 0.4) { [self] in
            loginViewTopConst.constant = 123
            view.layoutIfNeeded()
        }
    }
	
	override public func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
       
	}
    
    func checkLogin() {
        
        var isAutoUserLogin = KB.KeyChain.isAutoUserLogin
        if KB.KeyChain.isDev {
            isAutoUserLogin = KB.UserData.isAutoUserLogin
        }
        if isAutoUserLogin == true {
            
            // 자동 로그인 처리
            loginView.isHidden = true
            loadingView.isHidden = false
            
            loginButtonTouchUpInside(loginButton)
        }
        else {
            
            // 로그인 입력 화면
            loginView.isHidden = false
            loadingView.isHidden = true
        }
    }
	
    func loadSplashImage() {
        KB.Notice.loadSpalshImage { image in
            DispatchQueue.main.async { [self] in
                splashImageView.image = image
            }
        }
    }
	// MARK: - UIButton Actions
	@IBAction func idClearButtonTouchUpInside(_ sender: UIButton) {
		
		idTextField.text = ""
		idClearButton.isHidden = true
		
		loginButton.isEnabled = isValidateIdPw()
	}
	
	@IBAction func pwClearButtonTouchUpInside(_ sender: UIButton) {
		
		pwTextField.text = ""
		pwClearButton.isHidden = true
		
		loginButton.isEnabled = isValidateIdPw()
	}
	
	// MARK: - UITextField Actions
	@IBAction func textFieldEditingChanged(_ sender: UITextField) {
		
		let count = sender.text?.count ?? 0
		
		if sender == idTextField {
			idClearButton.isHidden = count > 0 ? false: true
		}
		else {
			pwClearButton.isHidden = count > 0 ? false: true
		}
		
		loginButton.isEnabled = isValidateIdPw()
	}
	
	// MARK: - UIView Events
	override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		view.endEditing(true)
	}
}


// MARK: - UIButton Actions

extension LoginWithOAuthViewController {
	
	@IBAction func userIdStoreButtonTouchUpInside(_ sender: UIButton) {
		
        userIdStoreButton.isSelected.toggle()
		
		KB.UserData.isStoreUserId = userIdStoreButton.isSelected
        KB.KeyChain.isStoreUserId = userIdStoreButton.isSelected

		if userIdStoreButton.isSelected == false {
			
			userAutoLoginButton.isSelected = false
			KB.UserData.isAutoUserLogin = false
            KB.KeyChain.isAutoUserLogin = false
		}
	}
	
	@IBAction func userAutoLoginButtonTouchUpInside(_ sender: UIButton) {
		
        userAutoLoginButton.isSelected.toggle()
		
		if userAutoLoginButton.isSelected == true {
			
			userIdStoreButton.isSelected = true
			KB.UserData.isStoreUserId = true
            KB.KeyChain.isStoreUserId = true
		}
		
		KB.UserData.isAutoUserLogin = userAutoLoginButton.isSelected		// 자동 로그인
        KB.KeyChain.isAutoUserLogin = userAutoLoginButton.isSelected
	}
	
	@IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
        // 레드마인 #10499. 네트워크 미연결인 경우
        let reachability = try! KBReachability.init()
        if reachability.isConnectedToNetwork == false{
            ErrorPopupViewController(sender: self).show()
            return
        }
		
		guard sender.isEnabled == true else {
			
			DispatchQueue.main.async {
				// 로그인 화면 표시 - 자동 로그인에서 에러가 발생할 경우 화면 전환 필요
				self.loginView.isHidden = false
				self.loadingView.isHidden = true
				
                if let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, targetName.contains("Global") {
                    self.messageLabel.text = "TR_IKEN3_00098".localized
                } else {
                    self.messageLabel.text = "아이디 또는 비밀번호를 확인해 주세요."
                }
				
				self.messageLabel.isHidden = false
                self.messageLabelBottomView.isHidden = false
			}
			return
		}
		
		// ID/PW
		guard let id = idTextField.text, let pw = pwTextField.text else { return }
		
		// 사용자 정보 저장 (임시)
		KB.UserData.userId = id
        KB.UserData.userPw = pw
		
		// 키체인 저장
		KB.KeyChain.userId = id	// KB.KeyChain.set(key: "UserID", value: id)
		KB.KeyChain.userPw = pw	// KB.KeyChain.set(key: "UserPW", value: pw)
        
        DispatchQueue.main.async { KB.Splash.show(view: self.view) }

		// OAuth 인증
		KB.Auth.signin(username: id, password: pw, completionHandler: { (result) in
            
            DispatchQueue.main.async { KB.Splash.hide(view: self.view) }
            
			// 메시지 레이블 UI 처리
			DispatchQueue.main.async {
				self.messageLabel.isHidden = true
                self.messageLabelBottomView.isHidden = true
			}
			
			switch result {
			
				case .success(let info):
					print(info)
					// 디바이스 토큰(UUID) 저장
					KB.Auth.saveUserDeviceTokenAPI() {
						
						// FCM 토큰 저장
						KB.Auth.saveUserFCMTokenAPI() {
							
							// 로그인 후 처리
							self.delegate?.performAfterAuthIn(username: id, password: pw)
							
							// 메인 화면으로 분기
							DispatchQueue.main.async { self.dismiss(animated: true, completion: nil) }
						}
					}
					
				case .failure(let error as NSError):
					print(error)
										
                    if let message = error.userInfo["message"] as? String{
                        
                        if message == "No HTTP Status" {
                            DispatchQueue.main.async {
                                self.loginView.isHidden = false
                                self.loadingView.isHidden = true
                                ErrorPopupViewController(sender: self).show()
                            }
                        }else{
                            DispatchQueue.main.async {
                                // 로그인 화면 표시 - 자동 로그인에서 에러가 발생할 경우 화면 전환 필요
                                self.loginView.isHidden = false
                                self.loadingView.isHidden = true
                                
                                if let targetName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String, targetName.contains("Global") {
                                    self.messageLabel.text = "TR_IKEN3_00098".localized
                                } else {
                                    self.messageLabel.text = message
                                }
                                self.messageLabel.isHidden = false
                                self.messageLabelBottomView.isHidden = false
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.loginView.isHidden = false
                            self.loadingView.isHidden = true
                            ErrorPopupViewController(sender: self).show()
                        }
                    }
					
				default:
					break
			}
		})
	}
}


// MARK: - UITextField Delegate
extension LoginWithOAuthViewController: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if let view = textField.superview{
            view.borderColor = #colorLiteral(red: 0.4117647059, green: 0.5215686275, blue: 0.9725490196, alpha: 1)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let view = textField.superview{
            view.borderColor = #colorLiteral(red: 0.8, green: 0.8, blue: 0.8, alpha: 0.8)
        }
    }
    
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		return true
	}
}

// MARK: - Input Checking
extension LoginWithOAuthViewController {
	
	func isValidateIdPw() -> Bool {
		// 레드마인 #10516
		guard idTextField.text?.count ?? 0 >= 1 else { return false }
		guard pwTextField.text?.count ?? 0 >= 1 else { return false }
        // 레드마인 #10518
        guard idTextField.text?.replacingOccurrences(of: " ", with: "").count ?? 0 >= 1 else { return false }
        guard pwTextField.text?.replacingOccurrences(of: " ", with: "").count ?? 0 >= 1 else { return false }
        
		return true
	}
}

private extension String {
    var localized: String? {
        
        var bundle: Bundle?
        
        if let gBundle = Bundle(identifier: "com.kolon.ikenapp2g") {
            bundle = gBundle
        } else if let gBundle = Bundle(identifier: "com.kolon.ikenapp2gdev") {
            bundle = gBundle
        }
        
        if let bundle = bundle {
            return NSLocalizedString(self, tableName: "LocalizedStrings", bundle: bundle, value: self, comment: "")
        } else {
            return nil
        }
    }
}

private extension Optional where Wrapped == String {
    var localized: String? {
        
        guard let txt = self else {
            return nil
        }
        
        var bundle: Bundle?
        
        if let gBundle = Bundle(identifier: "com.kolon.ikenapp2g") {
            bundle = gBundle
        } else if let gBundle = Bundle(identifier: "com.kolon.ikenapp2gdev") {
            bundle = gBundle
        }
        
        if let bundle = bundle {
            return NSLocalizedString(txt, tableName: "LocalizedStrings", bundle: bundle, value: txt, comment: "")
        } else {
            return nil
        }
    }
}
