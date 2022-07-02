//
//  SNSWebViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/04/15.
//

import UIKit
import WebKit

public class SNSWebViewController: UIViewController {
    
    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var goBackButton: UIButton!
    @IBOutlet weak var goForwardButton: UIButton!
    @IBOutlet weak var reloadButton: UIButton!
    
    public var urlString: String?
    
    public override func loadView() {
        
        super.loadView()
        
        let className = String(describing: SNSWebViewController.self)
        
        guard let bundle = Bundle(identifier: baseBundleId),
              let nib = bundle.loadNibNamed(className, owner: self),
              let nibView = nib.first as? UIView else { return }
        
        view = nibView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
                           
        // Set WebView
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
        webView.configuration.preferences.javaScriptEnabled = true
        
        // Set URL
        if let string = urlString,
           let encoded = string.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
           let url = URL(string: encoded) {
            let request = URLRequest(url: url)
            webView.load(request)
        }

    }
    
    @IBAction func closeButtonTouchUpInside(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func goBackButtonTouchUpInside(_ sender: Any) {
        webView.goBack()
    }
    
    @IBAction func goForwardButtonTouchUpInside(_ sender: Any) {
        webView.goForward()
    }
    
    @IBAction func reloadButtonTouchUpInside(_ sender: Any) {
        webView.reload()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension SNSWebViewController: WKScriptMessageHandler {
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        
        print("FBWebViewrController Message: \(message)")
              
    }
}

extension SNSWebViewController: WKNavigationDelegate {
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        
        print("WebView Did Finished")
        
        
        return
    }
    
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        //성공하리 콘텐츠(블로그, 페이스북..)내의 링크 처리 추가
        if navigationAction.navigationType == .linkActivated {
            
            let urlString = navigationAction.request.url?.absoluteString
            guard let url = URL(string: urlString!) else { return }
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                decisionHandler(.cancel)
                return
            }
            decisionHandler(.allow)
        }
        else{
            decisionHandler(.allow)
        }

    }
}

extension SNSWebViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alertController.addAction(otherAction)
        self.present(alertController, animated: true, completion: nil)
    }
}
