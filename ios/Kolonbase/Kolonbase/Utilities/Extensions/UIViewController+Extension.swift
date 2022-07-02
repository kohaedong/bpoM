//
//  UIViewController+LoadFromNib.swift
//  Kolonbase
//
//  Created by mk on 2020/10/19.
//

import UIKit

public extension UIViewController {
	
	@IBAction func unwindToViewController(_ segue: UIStoryboardSegue){
		dismiss(animated: true, completion: nil)
	}
	
	static func loadFromNib() -> Self {
		
		func instantiateFromNib<T: UIViewController>() -> T {
			
			return T.init(nibName: String(describing: T.self), bundle: nil)
		}
		
		return instantiateFromNib()
	}
    
    /**
     키보드 높이를 새로 가져와서 UIConstants.swift의 KEYBOARD_HEIGHT에 반영한다.
     - warning: UIApplication.shared의 첫번째 뷰에 임시로 뷰를 추가하기 때문에, 뷰 전환 관련 오류가 발생할 수 있음. 오류가 발생할 경우 선언하는 위치를 옮길 필요가 있음.
     */
    func getKeyboardHeight() {
        
        let temp = UITextField()
        
        NotificationCenter.default.addObserver(self, selector: #selector(getKeyboardHeightTempMethod(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        UIApplication.shared.windows.first?.addSubview(temp)
        temp.becomeFirstResponder()
        temp.resignFirstResponder()
        temp.removeFromSuperview()
        
        NotificationCenter.default.removeObserver(self)
        temp.removeFromSuperview()
    }
    
    @objc private func getKeyboardHeightTempMethod(_ noti: Notification) {
        if let keyboardFrame: NSValue = noti.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            
            let keyboardRectangle = keyboardFrame.cgRectValue
            KEYBOARD_HEIGHT = keyboardRectangle.height
        }
    }
}
