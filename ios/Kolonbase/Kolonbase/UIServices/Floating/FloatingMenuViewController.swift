//  Desc : Floting 메뉴
//
//  FloatingMenuViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/19.
//

import UIKit

//public enum QuickMenu: String {
//
//	case reserve = "자원예약"
//	case service = "서비스 요청"
//	case vpn = "VPN/반출 신청"
//	case visit = "방문객 예약"
//	case oi = "OI제안"
//}

enum MenuType: Int { case scheme = 0; case service = 1; case link = 2; case none = 3 }
struct MenuItem {
	
	var menuType: MenuType
	var menuUrl: String
	var menuName: String
	var imageName: String
	var order: Int
	var useCount: Int
	var isInstalled: Bool
}

public protocol FloatingMenuViewControllerDelegate {
	
	func handleQuickMenuSelected(menuName: String)
}

public class FloatingMenuViewController: UIViewController {

	@IBOutlet weak var menuListView: UIView!
    @IBOutlet weak var menuListViewBottomConst: NSLayoutConstraint!
    @IBOutlet var menuButtons: [UIButton]!
	@IBOutlet weak var closeButton: UIButton!
    public var isTabbarHidden : Bool = false
	public var delegate: FloatingMenuViewControllerDelegate?
	
	var menuListFrame: CGRect?
	
	public convenience init(frame: CGRect) {
		
		self.init()
		
		menuListFrame = frame
	}
	
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: FloatingMenuViewController.self)
		
		guard let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView else { return }
		
		view = nibView
	}
	
	public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// UI 설정
//		let r = CGFloat.pi / 4
//		closeButton.transform = CGAffineTransform(rotationAngle: r)
		//if let frame = menuListFrame { menuListView.frame = frame }
        if isTabbarHidden {
            menuListViewBottomConst.constant = 12
        }        
		// 데이터 설정
		var menuItems: [MenuItem]!
		
		// 권한 레벨 처리
        switch KB.Auth.securityLevel {
        
        case .regular:
            menuItems = [
                MenuItem(menuType: .service, menuUrl: "", menuName: "자원예약", imageName: "", order: 1, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "서비스 요청", imageName: "", order: 2, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "VPN/반출 신청", imageName: "", order: 3, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "방문객 예약", imageName: "", order: 4, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "OI제안", imageName: "", order: 5, useCount: 0, isInstalled: false),
            ]
            
        case .temporary, .cooperator:
            menuItems = [
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 1, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 2, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "서비스 요청", imageName: "", order: 3, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "VPN/반출 신청", imageName: "", order: 4, useCount: 0, isInstalled: false),
            ]
            
        default:
            menuItems = [
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 1, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 2, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 3, useCount: 0, isInstalled: false),
                MenuItem(menuType: .service, menuUrl: "", menuName: "", imageName: "", order: 4, useCount: 0, isInstalled: false),
            ]
        }
        
        //#10570 - 권한 3레벨의 메뉴 노출 예외적용
        if KB.Auth.securityLevel == .cooperator { //권한 3레벨
            var addButtonName = ""
        
            if KB.Auth.userCompanyCode == CompanyCode.kii.rawValue { // 3레벨 + 인더제조 소속
            addButtonName = "방문객 예약"
            } else if [CompanyCode.csh.rawValue, CompanyCode.kpc.rawValue].contains(KB.Auth.userCompanyCode) { // 3레벨 + 코오롱 혹은 제약 소속
                addButtonName = "자원예약"
            }

            if addButtonName.contains("예약") {
                menuItems.append(MenuItem(menuType: .service, menuUrl: "", menuName: addButtonName, imageName: "", order: 5, useCount: 0, isInstalled: false))
            }
        }
         
		for (index, item) in menuItems.enumerated() {
			
			if item.menuName == "" {
				
				menuButtons[index].isHidden = true
			}
			else {
				
				menuButtons[index].isHidden = false
				menuButtons[index].setTitle(item.menuName, for: .normal)
			}
		}
        
        //플로팅 버튼 활성화 시 X버튼 외 다른영역 선택 시 플로팅버튼 닫혀야 함
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.handleTap))
        self.view.addGestureRecognizer(gestureRecognizer)
        self.view.isUserInteractionEnabled = true
    }
    
    @objc func handleTap(gestureRecognizer: UIGestureRecognizer) {
        dismiss(animated: true, completion: nil)
    }
	
	public override func viewWillAppear(_ animated: Bool) {

		super.viewWillAppear(animated)

		menuListView.alpha = 0.0

		UIView.animate(withDuration: 0.4, delay: 0, animations: {
            let r = CGFloat.pi / 4
            self.closeButton.transform = CGAffineTransform(rotationAngle: r)
			self.menuListView.alpha = 1.0
		})
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
	@IBAction func menuButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
		
		let name = sender.currentTitle ?? ""
		delegate?.handleQuickMenuSelected(menuName: name)
	}
	
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
	}
}
