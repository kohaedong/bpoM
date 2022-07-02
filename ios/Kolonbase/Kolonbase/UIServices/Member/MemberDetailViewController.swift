//
//  MemberDetailViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/11/11.
//

import UIKit

class MemberDetailViewController: UIViewController {
	
	@IBOutlet weak var baseScrollView: UIScrollView!
	@IBOutlet weak var profileView: UIView!
	@IBOutlet weak var contentView: UIView!
	
	@IBOutlet weak var memberImageView: UIImageView!
	@IBOutlet weak var memberNameLabel: UILabel!
	@IBOutlet weak var memberTitleLabel: UILabel!
	
	@IBOutlet weak var phoneButton: UIButton!
	@IBOutlet weak var emailButton: UIButton!
	@IBOutlet weak var talkButton: UIButton!
	
	@IBOutlet weak var companyLabel: UILabel!
	@IBOutlet weak var departmentLabel: UILabel!
	
	@IBOutlet weak var emailAddressButton: UIButton!
	@IBOutlet weak var phoneNumberButton: UIButton!
	@IBOutlet weak var mobileNumberButton: UIButton!
	
	@IBOutlet weak var faxNumberLabel: UILabel!
	@IBOutlet weak var workLabel: UILabel!
	
	var member: MemberItem!
	
    override func viewDidLoad() {
		
        super.viewDidLoad()
		
//		if let imageUrl = member.image_url {
//
//			//memberImageView.downloadedFrom(link: imageUrl)
//			memberImageView.image = UIImage(systemName: imageUrl)
//		}
//		else {
			memberImageView.image = UIImage(named: "icon-outlined-24-px-person")
//		}
		
		memberNameLabel.text = member.userName
		memberTitleLabel.text = member.titleName
		
		companyLabel.text = member.companyName
		departmentLabel.text = member.deptName
		
		emailAddressButton.setTitle(member.email, for: .normal)
		phoneNumberButton.setTitle(member.telNum, for: .normal)
		mobileNumberButton.setTitle(member.mobileNum, for: .normal)
		
		faxNumberLabel.text = member.faxNum
		workLabel.text = member.roleName
		
		// 스크롤뷰 조정
		baseScrollView.contentSize = CGSize(width: view.frame.width, height: contentView.frame.maxY + DEFAULT_HEIGHT)
		
		return
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
	
	
	// MARK: - UIButton Actions
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: false, completion: nil)
		
		return
	}
	
	@IBAction func mobileButtonTouchUpInside(_ sender: UIButton) {
		
		guard let url = URL(string: "tel:\(member.mobileNum ?? "")") else { return }
		UIApplication.shared.open(url) { success in
			if success == false {
				AlertPopupViewController(title: "임직원 조회", message: "전화를 걸 수 없습니다.", completion: nil, sender: self).show()
			}
		}
		
		return
	}
	
	@IBAction func phoneButtonTouchUpInside(_ sender: UIButton) {
		
		guard let url = URL(string: "tel:\(member.telNum ?? "")") else { return }
		UIApplication.shared.open(url) { success in
			if success == false {
				AlertPopupViewController(title: "임직원 조회", message: "전화를 걸 수 없습니다.", completion: nil, sender: self).show()
			}
		}
		
		return
	}
	
	@IBAction func emailButtonTouchUpInside(_ sender: UIButton) {
		
		guard let url = URL(string: "mailto:\(member.email ?? "")") else { return }
		UIApplication.shared.open(url) { success in
			if success == false {
				AlertPopupViewController(title: "임직원 조회", message: "메일을 보낼 수 없습니다.", completion: nil, sender: self).show()
			}
		}
		
		return
	}
	
	@IBAction func talkButtonTouchUpInside(_ sender: UIButton) {
		
		guard let url = URL(string: "ikentalk:\(member.id)") else { return }
		UIApplication.shared.open(url) { success in
			if success == false {
//				ConfirmPopupViewController(title: "알림", message: "KOLON Talk 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
//					confirm: {
//						if let url = URL(string: "https://ikenapp.kolon.com") {
//							UIApplication.shared.open(url) { success in } }},
//					cancel: nil,
//					sender: self).show()
                if let url = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "kolonappsdev://" :"kolonapps://") {
                    if UIApplication.shared.canOpenURL(url) {
                        let appId: String = UserDefaults.standard.string(forKey: "talk")!
                        let installUrl = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "kolonappsdev://?appid=\(appId)" :"kolonapps://?appid=\(appId)")
                        ConfirmPopupViewController(title: nil, message: "\("KOLON Talk") 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
                                                     confirm: {
//                                                             UIApplication.shared.open(url) { success in } },
                                                        UIApplication.shared.open(installUrl ?? url) { success in } },
                                                     cancel: nil,
                                                     sender: self).show()
                    }
                    else{
                       ConfirmPopupViewController(title: nil, message: "[\("KOLON Talk")] 앱은 KOLON Apps에서\n설치하실 수 있습니다.\nKOLON Apps가 설치되어 있지 않습니다.\n설치하시겠습니까?",
                                                     confirm: {
                                                         if let url = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "https://appdev.kolon.com" :"https://ikenapp.kolon.com") {
                                                            UIApplication.shared.open(url) { success in }} },
                                                     cancel: nil,
                                                     sender: self).show()
                    }
                 }
			}
		}
		return
	}
	
}
