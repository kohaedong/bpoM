//
//  KBNoticeViewController.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/05/07.
//

import UIKit
import WebKit

public enum NoticeViewMode : String {
    case working
    case fullscreen
    case popup
    
    func getType(type : String?) -> NoticeViewMode {
        switch type {
        case "TPL1","TPL2","TPL3","URL","STF" :
            return .fullscreen
        case "TPL4":
            return .popup
        default:
            return .fullscreen
        }
    }
}

class KBNoticeViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    @IBOutlet weak var todayCheckButton: UIButton?
    
    public var dismissAction: (() -> Void)?

    public var item : KBNoticeItem?{
        didSet{
            if let item = item {
                                
                messageId = String(item.id)
                bodyHtml = item.ntcDscr
                urlString = item.ntcLnkAddr
            }
        }
    }
    
    public var viewMode = NoticeViewMode.fullscreen
    
    public var messageId: String?
    public var urlString: String?
    public var bodyHtml: String?
           
    public func initWith(item: KBNoticeItem) -> KBNoticeViewController? {
        
        let className = String(describing: KBNoticeViewController.self)

        let bundle = Bundle(identifier: baseBundleId)
        let storyboard = UIStoryboard(name: className, bundle: bundle)
        
        var viewMode = self.viewMode.getType(type: item.ntcTmpltCd).rawValue
        var recnfrmYn = ""
        if let yn = item.recnfrmYn, yn == "y" {
            recnfrmYn = "T"
        }
        //레드마인 #10503. URL 공지 화면 형태
        if item.appNtcGbCd == "STF" || item.appNtcGbCd == "URL"{
            viewMode = "survey"
//            recnfrmYn = ""
        }
        
        if let vc = storyboard.instantiateViewController(withIdentifier: className + "_" + viewMode + recnfrmYn) as? KBNoticeViewController{
            vc.item = item
            return vc
        }
        return nil
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()

//        let contentController = WKUserContentController()
//        contentController.add(self, name: "web_action")
//
//        webView.configuration.userContentController = contentController
        
        // 레드마인 #9891. 위와 같이 설정했을 시에 script message 읽을 수 없음
        let contentController = webView.configuration.userContentController
        contentController.add(self, name: "web_action")
        
        webView.scrollView.showsVerticalScrollIndicator = false
        webView.scrollView.showsHorizontalScrollIndicator = false
        webView.scrollView.bounces = false
        webView.navigationDelegate = self
        webView.uiDelegate = self
                
        if let string = urlString,
           var url = URL(string: string) {
            
//            if let item = item,
//               item.appNtcGbCd == "STF",
//               let url = URL(string: "\(string)?systemCd=\(item.ext ?? "1")&researchId=\(KB.Auth.userAccount ?? "")"){
//
//                let request = URLRequest(url: url)
//                webView.load(request)
//                return
//            }
            if !string.contains("http"){
                url = URL(string: "https://" + string) ?? URL(string: string)!
            }
            
            let request = URLRequest(url: url)
//            let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData)
            webView.load(request)
        }
        else {
            guard let body = bodyHtml else { return }
            webView.loadHTMLString(body, baseURL: nil)
        }
    }
        
    public func show() {
        
        self.modalPresentationStyle = .custom
        self.modalTransitionStyle = .crossDissolve

        if let vc = UIApplication.shared.getCurrentViewController() {
            vc.present(self, animated: false, completion: nil)
        }
    }
    
    
    
    @IBAction func todayButtonTouchUpInside(_ sender: Any) {
        
        if let button = todayCheckButton {
            button.isSelected.toggle()
        }else{
            KB.Notice.saveNoticeTodayHide(id: self.item?.id)
            doneButtonTouchUpInside(sender)
        }
    }
    
    @IBAction func doneButtonTouchUpInside(_ sender: Any) {
        
        if let item = self.item, let appCbgtYn = item.appCbgtYn, appCbgtYn == "n" {
            exit(0)
        }
        
        if let button = todayCheckButton, button.isSelected {
            KB.Notice.saveNoticeTodayHide(id: self.item?.id)
        }
        
        dismiss(animated: false) { [self] in
            if let action = dismissAction{
                action()
            }
        }
    }
}

extension KBNoticeViewController: WKScriptMessageHandler {
    
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
//                    if let url = URL(string: menuUrl) {
//                        UIApplication.shared.open(url) { success in
//                            print("Open", menuUrl, "-", success)
//                            if success == false {
//                                ConfirmPopupViewController(title: "알림", message: "\(menu.menuName) 앱이 설치되지 않았습니다.\n설치하시겠습니까?",
//                                    confirm: {
//                                        if let url = URL(string: "https://ikenapp.kolon.com") {
//                                            UIApplication.shared.open(url) { success in } }},
//                                    cancel: nil,
//                                    sender: sender).show()
//                            }
//                        }
//                    }
                }
            }
        }
        else if let message = message.body as? String {
            
            if message == "cancel" {
                
                self.dismiss(animated: false, completion: nil)
            }
        }
    }
}
extension KBNoticeViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        //아래 코드 적용 시 정상적인 페이지에 문제 있음(만족도 조사), 따라서 관리자 페이지에 meta tag를 정상적으로 사용해야 함.
        //#10515 - 공지 full팝업 및 modal 팝업 유형에 이미지 등록된 경우 팝업 사이즈에 fit하게 띄워져야함.
        /*
        let css = "img {max-width: 100%; width: 100%; height: auto; vertical-align: middle;}"
        let jscript = "var meta = document.createElement('meta'); meta.setAttribute('name', 'viewport'); meta.setAttribute('content', 'width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no'); var style = document.createElement('style'); style.innerHTML = '\(css)'; style.setAttribute('width', 'viewport'); document.getElementsByTagName('head')[0].appendChild(meta); document.getElementsByTagName('head')[0].appendChild(style);"
        webView.evaluateJavaScript(jscript)
        */
    }
    
    public func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("WebView Did Finished")
        return
    }
    // 레드마인 #10506 - webView 내 링크 클릭
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == WKNavigationType.linkActivated {
            if let loadUrl = navigationAction.request.mainDocumentURL?.absoluteString{
                //#10596 - 외부 브라우저로 연결하기.
                if let url = URL(string: loadUrl) {
                    UIApplication.shared.open(url, options: [:])
                }
/*
                let url : URL? = URL(string:loadUrl)
                webView.load(URLRequest(url: url!))
*/
                decisionHandler(.cancel)
                
                return
            }
        }
        decisionHandler(.allow)
    }
}

extension KBNoticeViewController: WKUIDelegate {
    
    public func webView(_ webView: WKWebView, runJavaScriptConfirmPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping (Bool) -> Void) {
        
        let confirmController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: {action in completionHandler(true)})
        let cancelAction = UIAlertAction(title: "취소", style: .default, handler: {action in completionHandler(false)})
        confirmController.addAction(confirmAction)
        confirmController.addAction(cancelAction)
        self.present(confirmController, animated: false, completion: nil)
    }
    
    public func webView(_ webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: @escaping () -> Void) {
        
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let otherAction = UIAlertAction(title: "OK", style: .default, handler: {action in completionHandler()})
        alertController.addAction(otherAction)
        self.present(alertController, animated: false, completion: nil)
    }
}
