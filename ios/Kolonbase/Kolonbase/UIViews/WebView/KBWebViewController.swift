//
//  KBWebViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/30.
//

import UIKit
import WebKit

public class KBWebViewController: UIViewController {
	
	var webView: WKWebView?
	
	public var urlString: String?
	public var messageId: String?
	
    public override func viewDidLoad() {
		
        super.viewDidLoad()
		
		// Set WebView Message ID
		guard let id = messageId else { return }
		let contentController = WKUserContentController()
		contentController.add(self, name: id)
		
		let userScript = WKUserScript(source: "initPage()", injectionTime: .atDocumentEnd, forMainFrameOnly: true)
		contentController.addUserScript(userScript)
		
		let configuration = WKWebViewConfiguration()
		configuration.userContentController = contentController
		
		// Set WebView
		webView = WKWebView(frame: view.frame, configuration: configuration)
		webView?.scrollView.showsVerticalScrollIndicator = false
		webView?.scrollView.showsHorizontalScrollIndicator = false
		webView?.scrollView.bounces = false
		webView?.navigationDelegate = self
		webView?.uiDelegate = self
		view.addSubview(webView!)
		
		// Set User Agent
		//webView.customUserAgent = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ko-kr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
		
		// Set URL
		if let string = urlString,
		   let url = URL(string: string) {
			
			//let request = URLRequest(url: url)
			let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
			webView?.load(request)
		}

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


extension KBWebViewController: WKScriptMessageHandler {
	
	public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
		
		print("FBWebViewrController Message: \(message)")
		
		if message.name == messageId {
			
			if let dictionary: [String: String] = message.body as? Dictionary {
				
				if let action = dictionary["action"] {
					
					if action == "setDate",
                       let name = dictionary["name"] {
						
						if name == "UserAccessDate" {
							
							let dateString = Date().description
							self.webView?.evaluateJavaScript("var \(name) = '\(dateString)';", completionHandler: nil)
						}
					}
					else if action == "confirm",
                            let param = dictionary["function"] {   // 'function'은 --> 'param'으로 변경 예정
						
						var message = ""
						
						if param == "proceed" {
							
							message = "Confirmed!"
						}
						
						self.webView?.evaluateJavaScript("\(param)('\(message)')", completionHandler: nil)
					}
				}
			}
			else if let message = message.body as? String {
				
				if message == "tapCancel" {
					
					self.dismiss(animated: true, completion: nil)
				}
			}
		}
	}
}

extension KBWebViewController: WKNavigationDelegate {
	
	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		print("WebView Did Finished")
		
		return
	}
}

extension KBWebViewController: WKUIDelegate {
	
	public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
		alertController.addAction(otherAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
