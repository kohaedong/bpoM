//
//  KBNoticeWebViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/30.
//

import UIKit
import WebKit

public class KBNoticeWebViewController: UIViewController {
	
	var baseView: UIView!
	var webView: WKWebView!
	var confirmButton: UIButton!
	
	// for Popup Mode
	var noShowTodayButton: UIButton?
	var effectView: UIVisualEffectView?
	
	
    public var viewMode = NoticeViewMode.working
    
	public var messageId: String?
	public var urlString: String?
	public var bodyHtml: String?
	
	
	public convenience init(viewMode: NoticeViewMode) {
		
		self.init()
		
		self.viewMode = viewMode
	}
	
    public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// Set UI
		var viewFrame = CGRect.zero
		var webFrame = CGRect.zero
		var buttonFrame = CGRect.zero
		var buttonColor = UIColor(red: 58, green: 106, blue: 246)
		var buttonTitle = "확인"
		
		switch viewMode {
		
			case .working:
				viewFrame = view.frame
				webFrame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 52.0)
				buttonFrame = CGRect(x: 0.0, y: SCREEN_HEIGHT - 52.0, width: SCREEN_WIDTH, height: 52.0)
				buttonColor = UIColor(red: 58, green: 106, blue: 246)
				buttonTitle = "확인"
				
			case .fullscreen:
				viewFrame = view.frame
				webFrame = CGRect(x: 0.0, y: 0.0, width: SCREEN_WIDTH, height: SCREEN_HEIGHT - 52.0)
				buttonFrame = CGRect(x: SCREEN_WIDTH / 2.0, y: SCREEN_HEIGHT - 52.0, width: SCREEN_WIDTH / 2.0, height: 52.0)
				buttonColor = UIColor(red: 58, green: 106, blue: 246)
				buttonTitle = "닫기"
				
			case .popup:
				viewFrame.size = CGSize(width: 328.0, height: 430.0)
				webFrame = CGRect(x: 0.0, y: 0.0, width: 328.0, height: 374.0)
				buttonFrame = CGRect(x: 207.0, y: 375.0, width: 120.0, height: 55.0)
				buttonColor = .clear
				buttonTitle = "닫기"
		}
		
		if viewMode == .popup {
			
			let effect = UIBlurEffect(style: .regular)
			effectView = UIVisualEffectView(effect: effect)
			effectView?.frame = view.frame
			effectView?.backgroundColor = .clear
			effectView?.alpha = 0.6
			view.addSubview(effectView!)
		}
		
		baseView = UIView(frame: viewFrame)
		baseView.backgroundColor = .clear
		baseView.isUserInteractionEnabled = true
		view.addSubview(baseView)
		
		confirmButton = UIButton(frame: buttonFrame)
		confirmButton.backgroundColor = buttonColor
		confirmButton.setTitle(buttonTitle, for: .normal)
		confirmButton.addTarget(self, action: #selector(confirmButtonTouchUpInside(sender:)), for: .touchUpInside)
		baseView.addSubview(confirmButton)
		
		if viewMode == .fullscreen {
			var frame = buttonFrame
			frame.origin.x = 0.0
			noShowTodayButton = UIButton(frame: frame)
			noShowTodayButton?.backgroundColor = UIColor(red: 236, green: 241, blue: 255)
			noShowTodayButton?.setTitleColor(UIColor(red: 58, green: 106, blue: 246), for: .normal)
			noShowTodayButton?.setTitle("오늘 다시 보지 않기", for: .normal)
			noShowTodayButton?.addTarget(self, action: #selector(noShowTodayButtonTouchUpInside(sender:)), for: .touchUpInside)
			baseView.addSubview(noShowTodayButton!)
		}
		else if viewMode == .popup {
			
			noShowTodayButton = UIButton(frame: CGRect(x: 0.0, y: 374.0, width: 207.0, height: 55.0))
			noShowTodayButton?.setImage(UIImage(named: "checkbox-medium-purple-checked"), for: .selected)
			noShowTodayButton?.setTitleColor(UIColor(red: 20, green: 22, blue: 24), for: .normal)
			noShowTodayButton?.setTitle("  오늘 다시 보지 않기  ", for: .normal)
			noShowTodayButton?.addTarget(self, action: #selector(noShowTodayButtonTouchUpInside(sender:)), for: .touchUpInside)
			baseView.addSubview(noShowTodayButton!)
			
			confirmButton.frame = CGRect(x: 207.0, y: 374.0, width: 120.0, height: 55.0)
			confirmButton.setTitleColor(UIColor(red: 20, green: 22, blue: 24), for: .normal)
			
			let horizontalLine = UIView(frame: CGRect(x: 0.0, y: 375.0, width: 328.0, height: 1.0))
			horizontalLine.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
			baseView.addSubview(horizontalLine)
			
			let verticalLine = UIView(frame: CGRect(x: 207.0, y: 375.0, width: 1.0, height: 55.0))
			verticalLine.backgroundColor = UIColor(red: 204, green: 204, blue: 204)
			baseView.addSubview(verticalLine)
			
			baseView.center = view.center
			baseView.borderColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
			baseView.borderWidth = 1.0
			baseView.cornerRadius = 8.0
		}
		
		// Set WebView Message ID
		//guard let id = messageId else { return }
		let contentController = WKUserContentController()
		contentController.add(self, name: "web_action")
		
		//let userScript = WKUserScript(source: "initPage()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		//contentController.addUserScript(userScript)
		
		let configuration = WKWebViewConfiguration()
		configuration.userContentController = contentController
		
		// Set WebView
		webView = WKWebView(frame: webFrame, configuration: configuration)
		webView.scrollView.showsVerticalScrollIndicator = false
		webView.scrollView.showsHorizontalScrollIndicator = false
		webView.scrollView.bounces = false
		webView.navigationDelegate = self
		webView.uiDelegate = self
		baseView.addSubview(webView)
		
		// Set User Agent
		webView.customUserAgent = "Mozilla/5.0 (iphone; U; CPU iPhone OS 4_3_3 like Mac OS X; ko-kr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
		
		// Set URL
		if let string = urlString,
		   let url = URL(string: string) {
			
			//let request = URLRequest(url: url)
			let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
			webView.load(request)
		}
		else {
			
			guard let body = bodyHtml else { return }
			webView.loadHTMLString(body, baseURL: nil)
		}

        return
    }
	
	@objc func confirmButtonTouchUpInside(sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
	}
	
	@objc func noShowTodayButtonTouchUpInside(sender: UIButton) {
		
		if viewMode == .fullscreen {
			
			dismiss(animated: true, completion: nil)
		}
		else {	// if viewMode == .popup {
			
			sender.isSelected.toggle()
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
	// 웹뷰 캐시 삭제
	public func clearWebViewCache() {
		
		URLCache.shared.removeAllCachedResponses()
		URLCache.shared.diskCapacity = 0
		URLCache.shared.memoryCapacity = 0
		
		HTTPCookieStorage.shared.removeCookies(since: Date.distantPast)
		print("[WebCacheCleaner] All cookies deleted")
		
		WKWebsiteDataStore.default().fetchDataRecords(ofTypes: WKWebsiteDataStore.allWebsiteDataTypes()) { records in
			
			records.forEach { record in
				
				WKWebsiteDataStore.default().removeData(ofTypes: record.dataTypes, for: [record], completionHandler: {})
				print("[WebCacheCleaner] Record \(record) deleted")
			}
		}
	}
}


extension KBNoticeWebViewController: WKScriptMessageHandler {
	
	public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		
		print("KBNoticeWebViewrController Message: \(message)")
		
		//guard if message.name == messageId else { return }
		
		if let dictionary: [String: String] = message.body as? Dictionary {
			
			if let action = dictionary["methodName"] {
				
				if action == "confirm", let param = dictionary["methodParam"] {
					
					webView?.evaluateJavaScript("\(action)('\(param)')", completionHandler: nil)
				}
				else if action == "cancel" {
					
					self.dismiss(animated: true, completion: nil)
				}
				else if action == "open", let param = dictionary["methodParam"] {
					
					// URL 오픈
					if let url = URL(string: param) {
						UIApplication.shared.open(url) { success in
							if success == false {
								AlertPopupViewController(title: nil, message: "유효하지 않은 URL 입니다.").show()
							}
						}
					}
					
					// 앱 오픈
//					if let url = URL(string: menuUrl) {
//						UIApplication.shared.open(url) { success in
//							print("Open", menuUrl, "-", success)
//							if success == false {
//								ConfirmPopupViewController(title: "알림", message: "\(menu.menuName) 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
//									confirm: {
//										if let url = URL(string: "https://ikenapp.kolon.com") {
//											UIApplication.shared.open(url) { success in } }},
//									cancel: nil,
//									sender: sender).show()
//							}
//						}
//					}
				}
			}
		}
		else if let message = message.body as? String {
			
			if message == "cancel" {
				
				self.dismiss(animated: true, completion: nil)
			}
		}
	}
}

extension KBNoticeWebViewController: WKNavigationDelegate {
	
	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		print("WebView Did Finished")
		
		return
	}
}

extension KBNoticeWebViewController: WKUIDelegate {
	
	public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
		
		let confirmController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let confirmAction = UIAlertAction(title: "확인", style: .default, handler: {action in completionHandler(true)})
		let cancelAction = UIAlertAction(title: "취소", style: .default, handler: {action in completionHandler(false)})
		confirmController.addAction(confirmAction)
		confirmController.addAction(cancelAction)
		self.present(confirmController, animated: true, completion: nil)
	}
	
	public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
		alertController.addAction(otherAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
