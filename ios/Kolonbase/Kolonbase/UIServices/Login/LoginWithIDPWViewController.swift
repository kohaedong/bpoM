//  Desc : 로그인UI(ID/PW)
//
//  LoginWithIDPWViewController.swift
//  Kolonbase-Sample
//
//  Created by mk on 2020/10/14.
//

import UIKit

@objc public protocol LoginWithIDPWViewControllerDelegate {
	
	func performAfterSignIn(username: String, password: String)
}

public class LoginWithIDPWViewController: UIViewController {
	
	// 자동 로그인
	@IBOutlet weak var loadingView: UIView!
	@IBOutlet weak var ikenLogoImageView: UIImageView!
	@IBOutlet weak var kolonLogoImageView: UIImageView!
	@IBOutlet weak var activityIndicator: UIActivityIndicatorView!
	
	// 로그인 입력 화면
	@IBOutlet weak var loginView: UIView!
	
	@IBOutlet weak var logoImageView: UIImageView!
	
	@IBOutlet weak var idTextField: UITextField!
	@IBOutlet weak var pwTextField: UITextField!
	
	@IBOutlet weak var idClearButton: UIButton!
	@IBOutlet weak var pwClearButton: UIButton!
	
	@IBOutlet weak var messageLabel: UILabel!
	
	@IBOutlet weak var userIdStoreButton: UIButton!
	@IBOutlet weak var userAutoLoginButton: UIButton!
	
	@IBOutlet weak var loginButton: UIButton!
	
	
	var delegate: LoginWithIDPWViewControllerDelegate?
	
	var baseViewY: CGFloat = 0.0
	
	
    override public func viewDidLoad() {
		
        super.viewDidLoad()

		// UI 설정
		baseViewY = loginView.frame.origin.y
		loginView.center.x = view.center.x
		logoImageView.center.x = loginView.center.x
		
		// 에러 메시지 레이블
		messageLabel.isHidden = true
		adjustViews()
		
		// ID/PW 표시
		if KB.UserData.isStoreUserId == true {
			idTextField.text = KB.UserData.userId }
		if KB.UserData.isAutoUserLogin == true {
			pwTextField.text = KB.UserData.userPw }
		
		// ID/PW 클리어 버튼 표시
		idClearButton.isHidden = idTextField.text?.count ?? 0 > 0 ? false: true
		pwClearButton.isHidden = pwTextField.text?.count ?? 0 > 0 ? false: true
		
		// 체크 박스 표시
		userIdStoreButton.isSelected = KB.UserData.isStoreUserId
		userAutoLoginButton.isSelected = KB.UserData.isAutoUserLogin
    }
	
	override public func viewWillAppear(_ animated: Bool) {
		
		super.viewWillAppear(animated)
		
		// ID/PW 입력 필드 체크
		loginButton.isEnabled = isValidateIdPw()
		
		// 키보드 알림
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
		
		return
	}
	
	public override func viewWillDisappear(_ animated: Bool) {
		
		super.viewWillDisappear(animated)
		
		// 키보드 알림 제거
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
		NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
	}
	
	@objc private func keyboardWillShow(_ notification: Notification) {
	  if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
		let keybaordRectangle = keyboardFrame.cgRectValue
		let keyboardHeight = keybaordRectangle.height
		
		if loginView.frame.maxY > SCREEN_HEIGHT - keyboardHeight {
			
			let disp = loginView.frame.maxY - (SCREEN_HEIGHT - keyboardHeight)
			loginView.frame.origin.y -= disp
		}
	  }
	}
	  
	@objc private func keyboardWillHide(_ notification: Notification) {
		
		loginView.frame.origin.y = baseViewY
	}
    
	override public func viewDidAppear(_ animated: Bool) {
		
		super.viewDidAppear(animated)
		
		if KB.UserData.isAutoUserLogin == true {
			
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	// MARK: - Methods
	func adjustViews() {
		
		if messageLabel.isHidden == true {
			userIdStoreButton.frame.origin.y = pwTextField.frame.maxY + 16.0
		}
		else {
			userIdStoreButton.frame.origin.y = messageLabel.frame.maxY + 16.0
		}
		
		userAutoLoginButton.frame.origin.y = userIdStoreButton.frame.origin.y
		loginButton.frame.origin.y = userAutoLoginButton.frame.maxY + 45.0
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
	public override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
		
		view.endEditing(true)
	}
}


// MARK: - UIButton Actions
extension LoginWithIDPWViewController {
	
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
	
	@IBAction func userIdStoreButtonTouchUpInside(_ sender: UIButton) {
		
		sender.isSelected.toggle()
		
		KB.UserData.isStoreUserId = sender.isSelected
		
		if sender.isSelected == false {
			
			userAutoLoginButton.isSelected = false
			KB.UserData.isAutoUserLogin = false
		}
		
		return
	}
	
	@IBAction func userAutoLoginButtonTouchUpInside(_ sender: UIButton) {
		
		sender.isSelected.toggle()
		
		KB.UserData.isAutoUserLogin = sender.isSelected
		
		if sender.isSelected == true {
			
			userIdStoreButton.isSelected = true
			KB.UserData.isStoreUserId = true
		}
		
		return
	}
	
	@IBAction func loginButtonTouchUpInside(_ sender: UIButton) {
		
        if sender.isSelected == false {
            
            DispatchQueue.main.async {
				self.messageLabel.text = "아이디와 패스워드를 확인해주세요."
				self.messageLabel.isHidden = false
				self.adjustViews()
			}
            return
        }
		
        guard let id = idTextField.text, let pw = pwTextField.text else { return }
        
		// 사용자 정보 저장 - 옵션
		if KB.UserData.isStoreUserId == true {
			KB.UserData.userId = id }
		if KB.UserData.isAutoUserLogin == true {
			KB.UserData.userPw = pw }
		
		// ID/PW 로그인
		KB.Auth.login(id: id, pw: pw, completionHandler: { (result) in
			
			DispatchQueue.main.async {
				self.messageLabel.isHidden = true
				self.adjustViews()
			}
			
			switch result {
			
				case .success(let info):
					print(info)
					// 디바이스 토큰(UUID) 저장
					KB.Auth.saveUserDeviceTokenAPI() {
						
						// FCM 토큰 저장
						KB.Auth.saveUserFCMTokenAPI() {
							
							// 로그인 후 처리
							self.delegate?.performAfterSignIn(username: id, password: pw)
							
							// 메인 화면으로 분기
							DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { self.dismiss(animated: true, completion: nil) }
						}
					}
					
				case .failure(let error as NSError):
					print(error)
                    
                    if let message = error.userInfo["message"] as? String{
                        
                        if message == "No HTTP Status" {
                            DispatchQueue.main.async {
                                self.loginView.isHidden = false
                                self.loadingView.isHidden = true
                                self.adjustViews()

                                ErrorPopupViewController(sender: self).show()
                            }
                        }else{
                            DispatchQueue.main.async {
                                // 로그인 화면 표시 - 자동 로그인에서 에러가 발생할 경우 화면 전환 필요
                                self.loginView.isHidden = false
                                self.loadingView.isHidden = true
                                
                                self.messageLabel.text = message
                                self.messageLabel.isHidden = false
                                self.adjustViews()
                            }
                        }
                        
                    }else{
                        DispatchQueue.main.async {
                            self.loginView.isHidden = false
                            self.loadingView.isHidden = true
                            self.adjustViews()

                            ErrorPopupViewController(sender: self).show()
                        }
                    }                    					
				default:
					break
			}
		})
		
		return
	}
}


// MARK: - UITextField Delegate
extension LoginWithIDPWViewController: UITextFieldDelegate {
	
	public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
		
		return true
	}
}


// MARK: - Input Checking
extension LoginWithIDPWViewController {
	
	func isValidateIdPw() -> Bool {
		
		guard idTextField.text?.count ?? 0 > 1 else { return false }
		guard pwTextField.text?.count ?? 0 > 1 else { return false }
		
		return true
	}
}

