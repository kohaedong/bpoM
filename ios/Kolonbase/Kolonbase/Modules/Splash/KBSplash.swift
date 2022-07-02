//  Desc : 로딩 스플래시
//
//  KBSplash.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import UIKit

// MARK: -  KB Splash
public class KBSplash: NSObject {
	
	static let shared = KBSplash()
	
	//private override init() {}
	//convenience init() { self.init() }
	
	let EffectTagId = 5925
	let SplashTagId = 5926
	
	public func show(view: UIView) {
		
		//print("KB.Splash Show!")
		
		DispatchQueue.main.async {
			
			// Set Target View
			let origin = CGPoint(x: 0, y: 0)
			let size = view.frame.size
			let center = CGPoint(x: size.width / 2, y: size.height / 2)
		
			// Show Effective View
			let blurEffect = UIBlurEffect(style: .light)
			let effectView = UIVisualEffectView(effect: blurEffect)
			effectView.translatesAutoresizingMaskIntoConstraints = false
			effectView.frame.origin = origin
			effectView.frame.size = size
			effectView.alpha = 0.4	// 투명도
			effectView.tag = self.EffectTagId	// 태그
			view.addSubview(effectView)
			
			// Show Splash
			let splash = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 44, height: 44))
			splash.center = center
			splash.startAnimating()
			splash.tag = self.SplashTagId
			view.addSubview(splash)
		}
	}
	
	public func hide(view: UIView) {
		
		//print("KB.Splash Hide!", view.tag)
		
		// Remove Effective View
		DispatchQueue.main.async {
			let effectView = view.viewWithTag(self.EffectTagId) as? UIVisualEffectView
			effectView?.removeFromSuperview()
		
			// Remove Splash
			let splash = view.viewWithTag(self.SplashTagId) as? UIActivityIndicatorView
			splash?.stopAnimating()
			splash?.removeFromSuperview()
		}
	}
}
