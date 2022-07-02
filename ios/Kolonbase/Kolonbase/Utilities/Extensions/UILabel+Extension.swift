//
//  UILabel+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/10/23.
//

import UIKit

public extension UILabel {
	
	@IBInspectable var isAdjustsFontSizeToFitWidth: Bool {
		
		get {
			
			return adjustsFontSizeToFitWidth
		}
		
		set {
			
			adjustsFontSizeToFitWidth = newValue
		}
	}
	
    // searchedText에 해당하는 첫 문자 하이라이트
	func highlight(searchedText: String?, color: UIColor = .red) {
		
		guard let txtLabel = self.text,
              let searchedText = searchedText?.lowercased() else {
			return
		}
		
		let attributeString = NSMutableAttributedString(string: txtLabel)
        let lowAttributeString = NSMutableAttributedString(string: txtLabel.lowercased())
		let range: NSRange = lowAttributeString.mutableString.range(of: searchedText, options: .caseInsensitive)

		attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
		
		self.attributedText = attributeString
	}
    
    //#10360 - searchedText에 해당하는 모든 문자 하이라이트
    func highlightAll(searchedText: String?, color: UIColor = .red) {
        
        guard let txtLabel = self.text,
              let searchedText = searchedText?.lowercased() else {
            return
        }
        
        let attributeString = NSMutableAttributedString(string: txtLabel)
        let lowAttributeString = NSMutableAttributedString(string: txtLabel.lowercased())
        
        let string:String = lowAttributeString.mutableString as String
        let ranges = string.ranges(of: searchedText, options: .caseInsensitive)
        
        for idx_range in ranges {
            let range = string.convertRange(from: idx_range)
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
        }
        
        self.attributedText = attributeString
    }
	
    func setLineHeight(lineHeight: CGFloat) {
        let text = self.text
        if let text = text {
            let attributeString = NSMutableAttributedString(string: text)
            let style = NSMutableParagraphStyle()
            
            style.lineSpacing = lineHeight
            attributeString.addAttribute(.paragraphStyle, value: style, range: NSMakeRange(0, text.count))
            self.attributedText = attributeString
        }
    }
    
    @IBInspectable var isLocalized: Bool {
        get {
            self.isLocalized
        }
        set {
            if newValue, let str = text {
                text = NSLocalizedString(str, tableName: "LocalizedStrings", bundle: Bundle.main, value: str, comment: "")
            }
        }
    }
    
    @IBInspectable var isStarHighlighted: Bool {
        get {
            self.isStarHighlighted
        }
        set {
            if newValue, text?.contains("*") ?? false {
                let targetRange = (text! as NSString).range(of: "*")
                let statusArrtibutedString = NSMutableAttributedString(string: text!)
                statusArrtibutedString.addAttributes([NSAttributedString.Key.foregroundColor : UIColor.red], range: targetRange)
                
                attributedText = statusArrtibutedString
            }
        }
    }
}
