//
//  KBWebViewController.swift
//  Kolonbase
//
//  Created by mk on 2020/10/30.
//

import UIKit
import WebKit

public class SynapWebViewController: UIViewController {
	
	@IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var titleLabel: UILabel!
    
	public var urlString: String?
	public var messageId: String?
    public var titleStr: String?
    
	public override func loadView() {
		
		super.loadView()
		
		let className = String(describing: SynapWebViewController.self)
		
		guard let bundle = Bundle(identifier: baseBundleId),
			  let nib = bundle.loadNibNamed(className, owner: self),
			  let nibView = nib.first as? UIView else { return }
		
		view = nibView
	}
	
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
		
        titleLabel.text = id
		// Set WebView
		webView.scrollView.showsVerticalScrollIndicator = false
		webView.scrollView.showsHorizontalScrollIndicator = false
		webView.scrollView.bounces = false
		webView.navigationDelegate = self
		webView.uiDelegate = self
		
		// Set User Agent
		//webView.customUserAgent = "Mozilla/5.0 (iPod; U; CPU iPhone OS 4_3_3 like Mac OS X; ko-kr) AppleWebKit/533.17.9 (KHTML, like Gecko) Version/5.0.2 Mobile/8J2 Safari/6533.18.5"
		
		// Set URL
		if let string = urlString,
		   let url = URL(string: string) {
			
			//let request = URLRequest(url: url)
			let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
			webView.load(request)
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
	
	
	// MARK: - UIButton Actions
	@IBAction func closeButtonTouchUpInside(_ sender: UIButton) {
		
		dismiss(animated: true, completion: nil)
	}
}


extension SynapWebViewController: WKScriptMessageHandler {
	
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
                            let function = dictionary["function"] {
						
						var  message = ""
						
						if function == "proceed" {
							
							 message = "PROCEED!"
						}
						
						self.webView?.evaluateJavaScript("\(function)('\( message)')", completionHandler: nil)
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

extension SynapWebViewController: WKNavigationDelegate {
	
	public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
		
		print("WebView Did Finished")
		
		return
	}
}

extension SynapWebViewController: WKUIDelegate {
	
	public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
		
		let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
		let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
		alertController.addAction(otherAction)
		self.present(alertController, animated: true, completion: nil)
	}
}
