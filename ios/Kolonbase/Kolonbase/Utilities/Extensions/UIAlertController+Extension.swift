//
//  UIAlertController+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import UIKit

public extension UIAlertController {
	
	func show() {
		
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		
		if var topController = keyWindow?.rootViewController {
			
			while let presentedViewController = topController.presentedViewController {
				
				topController = presentedViewController
			}
			
			topController.present(self, animated: true, completion: nil)
		}
		
		// ref.
		//		let vc = UIViewController()
		//		vc.view.backgroundColor = .systemBlue
		//
		//		let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
		//		window?.rootViewController = vc
		//		window?.windowLevel = UIWindow.Level.alert + 1
		//		window?.makeKeyAndVisible()
		//		vc.present(self, animated: true, completion: nil)
		
		// ref.
		//		let window = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
		//		window?.rootViewController?.present(self, animated: true, completion: nil)
	}
}
