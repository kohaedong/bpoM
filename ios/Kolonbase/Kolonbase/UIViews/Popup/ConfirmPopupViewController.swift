//  Desc : 확인/취소 가 있는 팝업
//
//  ConfirmPopupViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/19.
//

import UIKit

@objc public class ConfirmPopupViewController: KBPopupViewController {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var messageLabel: UILabel!
	@IBOutlet weak var seperateView: UIView?
    
    
	var titleString: String?
	var messageString: String?
    var messageAlignment : NSTextAlignment?
    @objc public var confirmHandler: (() -> Void)?
    @objc public var cancelHandler: (() -> Void)?
    @objc var sender: UIViewController?
    
    @objc public func initWith(title: String?,
                         message: String) -> ConfirmPopupViewController{
        
        return ConfirmPopupViewController.init(title: title,
                                        message: message)
        
    }
    
    public convenience init(title: String?,
                            message: String,
                            messageAlignment: NSTextAlignment? = .left,
                            confirm: (() -> Void)? = nil,
                            cancel: (() -> Void)? = nil,
                            sender: UIViewController? = nil) {
		
		self.init()
        
		self.titleString = title
		self.messageString = message
        self.messageAlignment = messageAlignment
		self.confirmHandler = confirm
        self.cancelHandler = cancel
		self.sender = sender
	}
	
	public override func loadView() {
		
		super.loadView()
        
        let className = (self.titleString != nil) ? String(describing:ConfirmPopupViewController.self) : "NoTitleConfirmPopupViewController"
		
		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
			
			view = nibView
		}
	}
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// UI 설정
		if let v = baseView {
			
			v.frame.size.width = SCREEN_WIDTH - DEFAULT_WIDTH * 2
			v.center = view.center
		}
        
        if let title = titleString{
            self.title = title
        }
        
        seperateView?.center = view.center
		
		// 팝업 메시지 설정
        titleLabel?.text = titleString
        
        messageLabel.textAlignment = messageAlignment ?? .left
        
		if let message = messageString {
			messageLabel.text = message
		}
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	// MARK: - Methods
    @objc public func show() {
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve

        if let vc = sender {
            vc.present(self, animated: false, completion: nil)
        }
        else {
            if let vc = UIApplication.shared.getCurrentViewController() {
                vc.present(self, animated: false, completion: nil)
            }
        }
    }
	
	// MARK: - UIButton Actions
	@IBAction func cancelButtonTouchUpInside(_ sender: UIButton) {
		                
        dismiss(animated: false) {
            if let handle = self.cancelHandler { handle() }
        }
	}
	
	@IBAction func confirmButtonTouchUpInside(_ sender: UIButton) {
						
        dismiss(animated: false) {
            if let handle = self.confirmHandler { handle() }
        }
	}
}
