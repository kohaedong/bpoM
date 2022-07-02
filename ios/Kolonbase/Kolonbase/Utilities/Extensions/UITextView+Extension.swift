//
//  UITextView+Extension.swift
//  Kolonbase
//
//  Created by cjh on 2021/08/26.
//

import UIKit

public extension UITextView{
    
    func setPlaceholder(placeholder: String, xPos:CGFloat =  5, multiline:Bool = false) -> UILabel {
        self.text = ""
        self.textColor = UIColor(named: "Text P2")
        
        let placeholderLabel = UILabel()
        placeholderLabel.text = placeholder
        placeholderLabel.font = UIFont.systemFont(ofSize: (self.font?.pointSize)!)
        placeholderLabel.sizeToFit()
        placeholderLabel.tag = 98765
        placeholderLabel.frame = self.frame
        //placeholderLabel.frame.origin = CGPoint(x: xPos, y: (self.font?.pointSize)! / 2)
        placeholderLabel.frame.origin.x = xPos
        placeholderLabel.frame.origin.y = 0
        if multiline {
            placeholderLabel.numberOfLines = 0
        }
        placeholderLabel.textColor = UIColor(named: "Text P4")
        placeholderLabel.isHidden = !self.text.isEmpty
        
        self.addSubview(placeholderLabel)
        return placeholderLabel
    }

    func checkPlaceholder() {
        let placeholderLabel = self.viewWithTag(98765) as! UILabel
        placeholderLabel.isHidden = !self.text.isEmpty
    }
}

