//  Desc : 워터마크 표시, 스크린샷 검출
//
//  KBScreenshot.swift
//  Kolonbase
//
//  Created by mk on 2020/11/17.
//

import UIKit

// MARK: - Screenshots
extension KBDetect {

    // 워터마크
    @objc public func showWaterMark() {
        
        DispatchQueue.main.async {
            let watermarkId = 0xAEA0FFFF
            
            // 워터마크 삭제
            guard let window = UIApplication.shared.keyWindow else { return }
            if let view = window.viewWithTag(watermarkId) {
                view.removeFromSuperview()
            }
            
            print("showWaterMark::",KB.Auth.isShowWatermarkUser)
            
            guard KB.Auth.isShowWatermarkUser == true else { return }

            var bottomHeight : CGFloat = 0
            if let vc = UIApplication.shared.getCurrentViewController() {
                bottomHeight = vc.view.safeAreaInsets.bottom
            }
            
            // 워터마크 추가
            if let watermark = KB.Auth.watermark{
                
                let label = UILabel()
                label.tag = watermarkId
                label.backgroundColor = .clear
                label.font = UIFont.systemFont(ofSize: 8)
                label.textColor = .darkText
                label.text = watermark
                label.sizeToFit()
                label.frame.origin = CGPoint(x: SCREEN_WIDTH - label.frame.width,
                                             y: SCREEN_HEIGHT - TABBAR_HEIGHT - bottomHeight - label.frame.height)
                window.addSubview(label)
                label.layer.zPosition = CGFloat(Float.greatestFiniteMagnitude)
                window.bringSubviewToFront(label)
            }
        }
    }
    
    // 화면 캡쳐 감지
    @objc public func setScreenshotDetector() {
            
        // 스크린샷 이벤트 알림 옵저버
        screenShotNotiReturn = NotificationCenter.default.addObserver(forName: UIApplication.userDidTakeScreenshotNotification, object: nil, queue: OperationQueue.main) { notification in
            
            DispatchQueue.main.async { [self] in
                
                // 스크린샷 캡처 가능 사용자 체크
                guard KB.Auth.isAllowScreenshotUser == true else { return }

                let imageView = UIImageView()
                if let vc = UIApplication.shared.getCurrentViewController() {
                    
                    // 스냅샷 표시
                    if let snapImage = takeSnapshotOfView(view: vc.view) {
                        
                        //                  // 캡처된 스크린샷을 화면에 표시
                        //					imageView.image = snapImage
                        //					imageView.sizeToFit()
                        //					imageView.frame = CGRect(x: 10, y: 10, width: imageView.frame.width / 4, height: imageView.frame.height / 4)
                        //					imageView.layer.borderWidth = 1.0
                        //					imageView.layer.borderColor = #colorLiteral(red: 1, green: 0.737254902, blue: 0, alpha: 1)
                        //					imageView.layer.cornerRadius = 4.0
                        //					vc.view.addSubview(imageView)
                        
                        // 스크린샷 로그 API 전달
                        #warning("앱별 기본 화면 id 변경 필요!!!")
                        self.sendScreenshotLog(image: snapImage, screenId: "MAIL_1000")
                    }
                }
                
                // 얼럿 표시
                let alert = UIAlertController(title: "스크린샷 보안주의!",
                                              message: "스크린샷이 감지되었습니다.\n업무용도 외 유포/공유 시 법적인 제재를 받을 수 있습니다.",
                                              preferredStyle: .alert)
                let confirm = UIAlertAction(title: "확인", style: .default) { (action) in

                    imageView.removeFromSuperview()
                }
                alert.addAction(confirm)
                alert.show()
            }
        }
	}
    
    public func removeScreenShotObserver(){
        NotificationCenter.default.removeObserver(screenShotNotiReturn as Any)
    }
    
    
    // MARK: - REST API: 스크린샷 로그 전송
    public func sendScreenshotLog(image: UIImage, screenId: String? = "") {
        
        // Image Data
        guard let data = image.jpegData(compressionQuality: 0.4) else {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                AlertPopupViewController(title: "에러", message: "스크린샷 이미지 인코딩에 문제가 있습니다.").show() }
            return
        }
        
        // Base64 String
        let string = data.base64EncodedString()
        
		var params: [String : Any]!
		if KB.Auth.isSigned == true || KB.Auth.authType == .oauth {
			// OAuth 인증 사용자
			params = [
				"methodName": "screenCapture",
				"methodParam": [
					"screenId" : screenId,
					"screenShot" : string
				]
			]
		}
		else {
			// ID/PW 사용자
			params = [
				"methodName": "screenCaptureByAnonymous",
				"methodParam": [
					"userId": KB.Auth.userAccount,
					"screenId" : screenId,
					"screenShot" : string,
				]
			]
		}
        //print(params)
        
        KB.API.postRESTAPI(method: "rest", params: params, completionHandler: { (data, error) in
            
            print(error as Any)
            print(data as Any)
            
            guard let data = data else { return }
            
            do {
                // 업데이트 응답 데이터 파싱
                let result = try JSONDecoder().decode(KBDataResponse<Bool>.self, from: data)
                print(result)
            }
            catch let error {
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    AlertPopupViewController(title: "에러", message: error.localizedDescription).show() }
            }
        })
        
        return
    }
}
