//  Desc : Floting 버튼
//
//  FloatingButton.swift
//  Kolonbase
//
//  Created by mk on 2020/10/20.
//

import UIKit

@objc public protocol FloatingButtonDelegate {
	
	func showQuickButton()
}

@IBDesignable
public class FloatingButton: UIButton {
	
	@IBOutlet public var delegate: FloatingButtonDelegate?
	
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
	
	override public init(frame: CGRect) {
		
		super.init(frame: frame)
		
		setup()
	}
	
	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
		
		setup()
	}
	
	func setup() {
		
		// XIB 로드
		let className = String(describing: FloatingButton.self)
		
		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
			
			self.addSubview(nibView)
		}
	}
	
	public func show(sender: UIViewController) {
		
		// XIB 로드
		let className = String(describing: FloatingButton.self)

		guard let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView  else { return }
		
		self.addSubview(nibView)
		
		// 프레임 설정
		center.x = SCREEN_WIDTH - frame.size.width
		center.y = SCREEN_HEIGHT - frame.size.height * 2
		sender.view.addSubview(self)
		
		// 페이드 인 처리
		self.alpha = 0.0
		
		UIView.animate(withDuration: 0.4, animations: {
			
			self.alpha = 1.0
		}
		, completion: { finished in
						
			//self.removeFromSuperview()
		})
	}
	
	
	// MARK: - UIButton Actions
	@IBAction func actionButtonTouchUpInside(_ sender: UIButton) {
		
		//sender.isSelected = !sender.isSelected
		
		// UIView Animate
		UIView.animate(withDuration: 0.4, animations: {
			
			let r = sender.isSelected ? CGFloat.pi / 4: 0.0
			sender.transform = CGAffineTransform(rotationAngle: r)
		}
		, completion: { finished in
			
			//self.removeFromSuperview()
			self.delegate?.showQuickButton()
			
//			let origin = self.frame.origin
//			let size = CGSize(width: 154, height: 468)	// Menu List Size
//
//			#if targetEnvironment(simulator)
//			let point = CGPoint(x: origin.x - size.width + 22, y: origin.y - size.height - 8)
//			#else
//			let point = CGPoint(x: origin.x - size.width + 40, y: origin.y - size.height - 4)
//			#endif
//
//			let frame = CGRect(origin: point, size: size)
//			let menu = FloatingMenuViewController(frame: frame)
		})
		
		return
	}
	
}
