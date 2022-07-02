//  Desc : UI 메소드 정의
//
//  UIUtilities.swift
//  Kolonbase
//
//  Created by mk on 2020/10/12.
//

import UIKit

// MARK: - Print Log
public func print(_ object: Any) {
#if DEBUG
	Swift.print(object)
#endif
}
public func print(_ object: Any...) {
#if DEBUG
	for item in object {
		Swift.print(item)
	}
#endif
}

// MARK: - Debug Log
public func DLog(_ message: String) {
#if DEBUG
	print("\(message)")
#endif
}
public func DLog(message: String, function: String = #function) {
#if DEBUG
	print("\(function): \(message)")
#endif
}

// MARK: - Show Storyboard
public enum ShowStyle { case show; case detail; case modal; case popover; case push; }
public func showStoryboard(bundleId: String? = nil, storyboardId: String, controllerId: String? = nil, sender: UIViewController? = nil, style: ShowStyle = .show) {
	
	// 번들
	var bundle: Bundle?
	if let id = bundleId {
		bundle = Bundle(identifier: id)
	}
	else {
		bundle = Bundle.main
	}
	
	// 스토리보드
	let s = UIStoryboard(name: storyboardId, bundle: bundle)
	
	// 뷰 컨트롤러
	var v: UIViewController?
	if let id = controllerId {
		v = s.instantiateViewController(withIdentifier: id)
	}
	else {
		v = s.instantiateInitialViewController()
	}
	
	// 뷰 컨트롤러 호출
	guard let vc = v else { return }
	let p = sender != nil ? sender: UIApplication.shared.getCurrentViewController()
	switch style {
		case .show: p?.show(vc, sender: nil)
		case .detail: p?.showDetailViewController(vc, sender: nil)
		case .modal: p?.present(vc, animated: true, completion: nil)
		case .popover: p?.present(vc, animated: true, completion: nil)
		case .push: p?.navigationController?.pushViewController(vc, animated: true)
	}
}


// MARK: - UIViews
public func adjustViewsFrame(views: [UIView], margin: CGFloat = 0.0) {
	
	var frame = CGRect(x: 0, y: 0, width: SCREEN_WIDTH, height: 0)
	var prev = views.first
	
	for view in views {
		
		if view == views.first { frame.origin.y = view.frame.origin.y; continue }
		
		// 프레임 재설정
		frame.size.width = view.frame.width
		frame.size.height = view.frame.height
		frame.origin.x = view.frame.origin.x
		frame.origin.y += prev?.frame.height ?? 0	// y만 prev에 누적해서 위치 변경
		frame.origin.y += margin					// 간격 추가
		view.frame = frame
		
		prev = view
	}
	
	let maxY = prev?.frame.maxY ?? 0
	prev?.superview?.frame.size.height = maxY
}

public func adjustSubViewsFrame(view: UIView, margin: CGFloat = 0.0) {
	
	let views = view.subviews
	var prev: UIView?
	var frame = CGRect.zero
	
	for v in views {
		
		// 1. 조정 제외 대상 처리
		// 히든 뷰 제외
		if v.isHidden == true { continue }
		
		// 특정 뷰 타입 제외
		let vDesc = String(describing: v)
		if let endIndex = vDesc.firstIndex(of: ":") {
			let vName = vDesc[vDesc.startIndex ... endIndex]
			if vName.contains("<UIScrollViewScrollIndicator:")	// 스크롤뷰 인디케이터
				|| vName.contains("<UIActivityIndicatorView:")	// 액티비티 인디케이터
				|| vName.contains("<UIVisualEffectView:")		// 비주얼 이펙트
				|| vName.contains("<UIRefreshControl:")			// 리프레시 컨트롤
			{ continue }
		}
		// 특정 태그 제외
		//if view.tag < 0 { continue }
		
		
		// 2. 화면 맨 위 첫번째 뷰 처리
		if prev == nil {
			frame.origin.y = v.frame.origin.y;
			prev = v
			continue
		}
		
		
		// 3. 뷰 프레임 처리
		frame.size.width = v.frame.width
		frame.size.height = v.frame.height
		frame.origin.x = v.frame.origin.x
		frame.origin.y += prev?.frame.height ?? 0	// y만 prev에 누적해서 위치 변경
		frame.origin.y += margin					// 간격 추가
		v.frame = frame
		
		// 4. 다음 뷰 위치 처리를 위한 기준 뷰 지정
		prev = v
	}
	
	let maxY = prev?.frame.maxY ?? 0
	if let scrollView = view as? UIScrollView {
		scrollView.contentSize.height = maxY
	}
	else {
		view.frame.size.height = maxY
	}
}

public func adjustSubViewsFrame(view: UIView, margin: CGFloat = 0.0, completionHandler: @escaping () -> Void) {
	
	adjustSubViewsFrame(view: view, margin: margin)
	completionHandler()
}


// MARK: - Show Alert View
public func showAlert(sender: UIViewController, title: String, message: String, handler: ((UIAlertAction) -> Void)?) {
	
	let alertController: UIAlertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
	let confirmAction: UIAlertAction = UIAlertAction(title: "확인", style: .default, handler: handler)
	alertController.addAction(confirmAction)
	sender.present(alertController, animated: true, completion: nil)
	
	return
}


// MARK: - Norch Device Detect
public var hasTopNotch: Bool {
	
	if #available(iOS 11.0,  *) {
		
		return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
	}
	
	return false
}


// MARK: - UIImage
public func getImageFromUrlString(_ urlString: String?) -> UIImage? {
	
	guard let imageURL = URL(string: urlString!) else { return nil }
	guard let data = try? Data(contentsOf: imageURL) else { return nil }
	guard let image = UIImage(data: data) else { return nil }
	
	return image
}

public func takeSnapshotOfView(view:UIView) -> UIImage? {
	
	UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, UIScreen.main.scale)
	view.drawHierarchy(in: CGRect(x: 0.0, y: 0.0, width: view.frame.size.width, height: view.frame.size.height), afterScreenUpdates: true)
	let image = UIGraphicsGetImageFromCurrentImageContext()
	UIGraphicsEndImageContext()
	
	return image
}

public func colorToImage(_ color: UIColor) -> UIImage {
	
	let size: CGSize = CGSize(width: UIScreen.main.bounds.width, height: 1)
	
	let image: UIImage = UIGraphicsImageRenderer(size: size).image { context in
		
		color.setFill()
		context.fill(CGRect(origin: .zero, size: size))
	}
	
	return image
}


// MARK: - Kolon Talk
public func openTalk(userId: String, companyCode: String) {
	
	var components = URLComponents()
    components.scheme = Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "ikentalkdev" : "ikentalk"
	components.host = ""
	components.queryItems = [URLQueryItem(name: "id", value: userId),
							 URLQueryItem(name: "companyCode", value: companyCode),
							 URLQueryItem(name: "type", value: "Profile")]
	if let url = components.url {
		UIApplication.shared.open(url) { success in
			if success == false {
//				ConfirmPopupViewController(title: "알림", message: "\("talk") 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
//					confirm: {
//						if let url = URL(string: "https://ikenapp.kolon.com") {
//							UIApplication.shared.open(url) { success in } }},
//					cancel: nil,
//					sender: UIApplication.shared.getCurrentViewController()
//				).show()
                if let url = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "kolonappsdev://" :"kolonapps://") {
                    if UIApplication.shared.canOpenURL(url) {
                        let appId: String = UserDefaults.standard.string(forKey: "talk")!
                        let installUrl = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "kolonappsdev://?appid=\(appId)" :"kolonapps://?appid=\(appId)")
                        ConfirmPopupViewController(title: nil, message: "\("KOLON Talk") 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
                                                     confirm: {
//                                                             UIApplication.shared.open(url) { success in } },
                                                        UIApplication.shared.open(installUrl ?? url) { success in } },
                                                     cancel: nil,
                                                     sender: UIApplication.shared.getCurrentViewController()).show()
                    }
                    else{
                       ConfirmPopupViewController(title: nil, message: "[\("KOLON Talk")] 앱은 KOLON Apps에서\n설치하실 수 있습니다.\nKOLON Apps가 설치되어 있지 않습니다.\n설치하시겠습니까?",
                                                     confirm: {
                                                         if let url = URL(string: Bundle.main.bundleIdentifier == "com.kolon.ikenapp2dev" ? "https://appdev.kolon.com" :"https://ikenapp.kolon.com") {
                                                            UIApplication.shared.open(url) { success in }} },
                                                     cancel: nil,
                                                     sender: UIApplication.shared.getCurrentViewController()).show()
                    }
                 }
			}
		}
	}
}
