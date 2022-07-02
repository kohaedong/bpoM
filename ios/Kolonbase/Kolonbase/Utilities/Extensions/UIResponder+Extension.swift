//
//  UIResponder+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/11/03.
//

import UIKit

public extension UIResponder {
	
    var parentViewController: UIViewController? {
        
        return next as? UIViewController ?? next?.parentViewController
    }
}
