//  Desc : 에러 팝업
//
//  ErrorPopupViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/06/22.
//

import UIKit

public class ErrorPopupViewController: KBPopupViewController {
    @IBOutlet weak var contentLabel: UILabel!
    
    var sender: UIViewController?
    var contentString : String?
    @objc public var doneButtonHandler: (() -> Void)?
    
    @objc public func initWith(sender: UIViewController? = nil,
                         message: String) -> ErrorPopupViewController{
            
        return ErrorPopupViewController.init(sender: sender,
                                             msg: message)
    }
    
    public convenience init(sender: UIViewController? = nil,
                            msg : String? = nil,
                            confirm: (() -> Void)? = nil) {
        
        self.init()
        
        self.sender = sender
        self.contentString = msg
        self.doneButtonHandler = confirm
    }
    
    public override func loadView() {
        super.loadView()
        
        let className = String(describing:ErrorPopupViewController.self)
        
        if let bundle = Bundle(identifier: baseBundleId),
           let nib = bundle.loadNibNamed(className, owner: self),
           let nibView = nib.first as? UIView {
            
            view = nibView
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        if let str = contentString, let contentLabel = contentLabel {
            contentLabel.text = str
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
    
    @IBAction func doneButtonTouchUpInside(_ sender: UIButton) {
        dismiss(animated: false) {
            if let handle = self.doneButtonHandler { handle() }
        }
    }

}
