//
//  UITextField+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/12/11.
//

import UIKit

private var __maxLengths = [UITextField: Int]()

@IBDesignable
public extension UITextField {
	
	@IBInspectable var padding: CGFloat {
		
		get {
			
			return 0
		}
		
		set (value) {
			
			layer.sublayerTransform = CATransform3DMakeTranslation(value, 0, 0)
		}
	}
	
    @IBInspectable var isLocalized: Bool {
        get {
            self.isLocalized
        }
        set {
            if newValue, let str = self.text {
                self.placeholder = NSLocalizedString(str, tableName: "LocalizedStrings", bundle: Bundle.main, value: str, comment: "")
            }
        }
    }
    
    @IBInspectable var maxLength: Int {
        get {
            guard let l = __maxLengths[self] else {
               return 150 // (global default-limit. or just, Int.max)
            }
            return l
        }
        set {
            __maxLengths[self] = newValue
            addTarget(self, action: #selector(fix), for: .editingChanged)
        }
    }
    @objc func fix(textField: UITextField) {
        if let t: String = textField.text {
            textField.text = String(t.prefix(maxLength))
        }
    }
}
