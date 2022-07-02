//
//  UIButton+Extension.swift
//  OnStudy iOS
//
//  Created by mk on 2020/06/15.
//  Copyright © 2020 mk. All rights reserved.
//

import UIKit

public extension UIButton {
	
    func resizeToFit(margin: CGFloat = 8.0) {
		
        sizeToFit()
        
        let imageWidth = currentImage?.size.width ?? 0
        frame.size.width += imageWidth
        let space = frame.width - imageWidth - margin
        imageEdgeInsets = UIEdgeInsets(top: 0, left: space, bottom: 0, right: 0)
	}
        
    func highlight(searchedText: String?,
                   highlightColor: UIColor = .red,
                   textColor: UIColor?,
                   font: UIFont?,
                   state : UIControl.State) {
        
        guard let txtLabel = self.title(for: state), let searchedText = searchedText else {
            return
        }
        
        var attributeString = NSMutableAttributedString(string: txtLabel)
        if let color = textColor {
            attributeString = NSMutableAttributedString(string: txtLabel,
                                                               attributes: [NSAttributedString.Key.foregroundColor : color])
        }
        
        let range: NSRange = attributeString.mutableString.range(of: searchedText, options: .caseInsensitive)
        
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: highlightColor, range: range)
        
        if let font = font {
            let textRange = NSMakeRange(0, txtLabel.count)
            attributeString.addAttribute(.font, value: font, range: textRange)
        }
        
        self.setAttributedTitle(attributeString, for: state)
    }
    
    @IBInspectable var isLocalized: Bool {
        get {
            self.isLocalized
        }
        set {
            if newValue, let str = self.currentTitle {
                self.setTitle(NSLocalizedString(str, tableName: "LocalizedStrings", bundle: Bundle.main, value: str, comment: ""), for: .normal)
            }
        }
    }
}
