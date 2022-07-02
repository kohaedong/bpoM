//  Desc : 팝업 UI
//
//  AlertPopupViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/19.
//

import UIKit

public class AlertPopupViewController: KBPopupViewController {

	@IBOutlet weak var baseView: UIView!
	@IBOutlet weak var titleLabel: UILabel?
	@IBOutlet weak var messageLabel: UILabel!
    
    var textAlignment :NSTextAlignment?
	var titleString: String?
	var messageString: String?
    @objc var confirmHandler: (() -> Void)?
    @objc var sender: UIViewController?
	
    @objc public func initWith(title: String?,
                         message: String) -> AlertPopupViewController{
        
        return AlertPopupViewController.init(title: title,
                                        message: message)
    }
    
	public convenience init(title: String? = nil,
                            message: String,
                            alignment : NSTextAlignment? = .left,
                            completion: (() -> Void)? = nil,
                            sender: UIViewController? = nil) {
		
        self.init()
        
        self.titleString = title
        self.messageString = message
        self.confirmHandler = completion
        self.sender = sender
        self.textAlignment = alignment
	}
	
	public override func loadView() {
		
		super.loadView()
				
        let className = (self.titleString != nil) ? String(describing:AlertPopupViewController.self) : "NoTitleAlertPopupViewController"

		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
			
			view = nibView
		}
	}
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// Set UI
		if let v = baseView {
			
			v.frame.size.width = SCREEN_WIDTH - (DEFAULT_WIDTH * 2)
			v.center = view.center
		}
		
		// 팝업 메시지 설정
        titleLabel?.text = titleString
		
		if let message = messageString {
			
			messageLabel.text = message
             
//			let split = message.split(separator: "\n")
//			messageLabel.numberOfLines = split.count + 1
		}
        
        if let alignment = self.textAlignment{
            messageLabel.textAlignment = alignment
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
		
		dismiss(animated: false, completion: nil)
	}
	
	@IBAction func confirmButtonTouchUpInside(_ sender: UIButton) {
		
		if let handle = confirmHandler { handle() }
		
		dismiss(animated: false, completion: nil)
	}
}
