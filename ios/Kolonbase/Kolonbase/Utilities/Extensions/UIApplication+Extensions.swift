//
//  UIApplication+Extensions.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import UIKit

public extension UIApplication {
	
	// iOS 13
//	var currentWindow: UIWindow? {
//
//		connectedScenes
//			.filter({$0.activationState == .foregroundActive})
//			.map({$0 as? UIWindowScene})
//			.compactMap({$0})
//			.first?.windows
//			.filter({$0.isKeyWindow}).first
//	}
	
	func getCurrentViewController() -> UIViewController? {
		
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		
		if var viewController = keyWindow?.rootViewController {
			
			while let presentedViewController = viewController.presentedViewController {
				
				viewController = presentedViewController
			}
			
			return viewController
		}
		
		return nil
	}
	
	func getRootViewController() -> UIViewController? {
		
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		return keyWindow?.rootViewController
	}
	
	func getMainViewController() -> UIViewController? {
		
		let keyWindow = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
		return keyWindow?.rootViewController?.presentedViewController
	}
}
