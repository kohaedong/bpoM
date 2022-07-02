//  Desc : 토스트 메시지 UI
//
//  ToastView.swift
//  Kolonbase
//
//  Created by mk on 2020/10/20.
//

import UIKit

//@IBDesignable
public class ToastView: UIView {
	
	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var messageLabel: UILabel!
	
	// Ver. 2
	var messageString: String?
	var confirmHandler: (() -> Void)?
	var sender: UIViewController?
	
	public convenience init(message: String, completion: (() -> Void)? = nil, sender: UIViewController? = nil) {
		
		self.init()
		
		self.messageString = message
		self.confirmHandler = completion
		self.sender = sender
	}
	
	public func flash(delay: TimeInterval = 0.4) {
		
		// XIB 로드
		let className = String(describing: ToastView.self)

		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {

			self.addSubview(nibView)
		}
		
		// 메시지 설정
		messageLabel.text = messageString ?? ""
		
		// 프레임 설정
		frame.size.width = SCREEN_WIDTH - 32 //SCREEN_WIDTH - DEFAULT_WIDTH * 2
		frame.size.height = 54 //DEFAULT_HEIGHT * 2
		center.x = SCREEN_WIDTH / 2
		center.y = baseView.safeAreaInsets.top + 70 //SCREEN_HEIGHT - (DEFAULT_HEIGHT * 4)
		
		// 토스트 표시
		if let vc = sender {
			vc.view.addSubview(self)
		}
		else {
			if let w = UIApplication.shared.keyWindow {
				w.addSubview(self)
			}
		}
		
		baseView.frame = frame
		baseView.frame.origin = CGPoint(x: 0, y: 0)
		
		// 페이드 아웃 처리
		self.alpha = 1.0
		
		UIView.animate(withDuration: 1.4, delay: delay, animations: {
			
			self.alpha = 0.0
		}
		, completion: { finished in
			
			if let handle = self.confirmHandler { handle() }
			
			self.removeFromSuperview()
		})
	}
	
	// Ver. 1
	@objc public func show(sender: UIView, message: String?) {
		
		// XIB 로드
		let className = String(describing: ToastView.self)

		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {

			self.addSubview(nibView)
		}
		
		// 메시지 설정
		if let string = message {
			
			messageLabel.text = string
		}
		
        // 프레임 설정
        frame.size.width = SCREEN_WIDTH - 32 //SCREEN_WIDTH - DEFAULT_WIDTH * 2
        frame.size.height = 54 //DEFAULT_HEIGHT * 2
        center.x = SCREEN_WIDTH / 2
        center.y = baseView.safeAreaInsets.top + 70 //SCREEN_HEIGHT - (DEFAULT_HEIGHT * 4)

//		frame.size.width = SCREEN_WIDTH - DEFAULT_WIDTH * 2
//		frame.size.height = DEFAULT_HEIGHT * 2
//		center.x = SCREEN_WIDTH / 2
//		center.y = SCREEN_HEIGHT - (DEFAULT_HEIGHT * 4)
		sender.addSubview(self)
		
		baseView.frame = frame
		baseView.frame.origin = CGPoint(x: 0, y: 0)
		
		// 페이드 아웃 처리
		self.alpha = 1.0
		
		UIView.animate(withDuration: 1.4, delay: 0.4, animations: {
			
			self.alpha = 0.0
		}
		, completion: { finished in
						
			self.removeFromSuperview()
		})
	}

}
