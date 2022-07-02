//  Desc : 파일뷰어 UI
//
//  FileView.swift
//  Kolonbase
//
//  Created by mk on 2020/10/20.
//

import UIKit

@IBDesignable
public class FileView: UIView {
	
	@IBOutlet weak var baseView: UIView!
    @IBOutlet weak var filetypeButton: UIButton!
	@IBOutlet weak var filenameButton: UIButton!
    
    @objc public var selectedRow: Int = 0
	
    // 파일 타입(확장자)
    @objc var filetype: String? {
		didSet { filetypeButton.setTitle(filetype, for: .normal) }}
	
    // 파일 이름
	@objc public var filename: String? {
		didSet {
            
			filenameButton.setTitle(filename, for: .normal)
            //filenameButton.sizeToFit()
            filenameButton.layer.zPosition = 100
//            filenameButton.frame.size.height = filenameButton.sizeThatFits(filenameButton.frame.size).height
			
			if let string = filename {
				filetype = NSString(string: string).pathExtension
			}
			
			switch filetype {
				case "png": filetype = "PNG"
				case "jpg", "jpeg": filetype = "JPEG"
				case "gif": filetype = "GIF"
				case "hwp": filetype = "한글"
				case "pdf": filetype = "PDF"
				case "doc", "docx": filetype = "Word"
				case "xls", "xlsx": filetype = "Excel"
                case "ppt": filetype = "ppt"
                case "pptx": filetype = "pptx"
				//case "ppt", "pptx": filetype = "Powerpoint"
				case "zip": filetype = "ZIP"
				default: break
			}
            
//            resizeFileView()
		}
	}
	
    /**
     FileView의 폭과 너비를 조절한다.
     */
    public func resizeFileView() {
        
        DispatchQueue.main.async { [self] in
            
            baseView.frame = self.frame
            
            filenameButton.frame.origin = CGPoint(x: filetypeButton.frame.maxX + 8, y: 0)
            filenameButton.frame.size.width = baseView.frame.size.width - filetypeButton.frame.maxX - 8
            filenameButton.frame.size.height = filenameButton.sizeThatFits(filenameButton.frame.size).height
            
            if filenameButton.frame.height > baseView.frame.height {
                baseView.frame.size.height = filenameButton.frame.height
            } else {
                filenameButton.frame.size.height = baseView.frame.height
            }
        }
    }
    
	override public init(frame: CGRect) {
		
		super.init(frame: frame)
		
		loadNib()
	}
	
	required init?(coder: NSCoder) {
		
		super.init(coder: coder)
		
		loadNib()
	}
	
	func loadNib() {
		
		// XIB 로드
		let className = String(describing: FileView.self)
		
		if let bundle = Bundle(identifier: baseBundleId),
		   let nib = bundle.loadNibNamed(className, owner: self),
		   let nibView = nib.first as? UIView {
            (nibView as? FileView)?.filenameButton.titleLabel?.numberOfLines = 0
            nibView.frame.size.width = self.frame.size.width
			self.addSubview(nibView)
		}
	}
	
	// MARK: - UIButton Actions
	@IBAction func filetypeButtonTouchUpInside(_ sender: UIButton) {
		
        // Synap API - 첨부파일 변환 후 표시
        getSynapJobAPI()
	}
	
	@IBAction func filenameButtonTouchUpInside(_ sender: UIButton) {
		
        // Synap API - 첨부파일 변환 후 표시
        getSynapJobAPI()
	}
	
    @objc func filenameButtonTouchEvent(_ sender: Any?) {
        getSynapJobAPI()
    }
	
	// MARK: - Synap API: Request Data
	var synapConvertType = 1	// 0: HTML, 1: IMAGE
	var synapFileType = "URL"
    @objc public var synapFilePath: String?
    @objc public var synapFID: String?
	
	// MARK: - Synap API: Response Data
	var synapResultDirPath = ""	// No Use
	var synapFileName = ""		// No Use
	var synapKey = ""
	
	// MARK: - Synap API: Functions
	func getSynapJobAPI() {

        // 레드마인 #10445, #10578 - 선택된 row number를 notification object로 전송
        NotificationCenter.default.post(name: NSNotification.Name("openFile"), object: self.selectedRow)
        
		guard let filePath = synapFilePath else { return }
//		guard let fileFid = synapFID else { return }
        
		let params = [
//			"convertType" : synapConvertType,
			"fileType" : synapFileType,
			"filePath" : filePath,
            "fid" : synapFID ?? "test"
		] as [String : Any]
		
        let urlString = KB.KeyChain.isDev == true ? "https://mkolonviewdev.kolon.com:8000/SynapDocViewServer/job" : "https://mkolonview.kolon.com/SynapDocViewServer/job"
		
		if let url = URL(string: urlString) {
			
			var request = URLRequest(url: url)
			request.httpMethod = "POST"
			request.allHTTPHeaderFields = ["Content-Type": "application/json"]
			
			do {
				try request.httpBody = JSONSerialization.data(withJSONObject: params, options: [])
			}
			catch let error {
				print("API Error: \(error.localizedDescription)")
				return
			}
			
			URLSession.shared.dataTask(with: request) { [self] (data, response, error) -> Void in
                
                // Error Check
				guard error == nil else {
					print(error.debugDescription)
					return
				}
				
				// Response Check≥
				guard let response = response as? HTTPURLResponse, 200...299 ~= response.statusCode else { return }
				//print("Post Message Success:", response)
				
				// Data Check
				guard let data = data else {
					print("Data Nil Error!")
					return
				}
				
				do {
					guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
						print("Invalid JSON Type Error!")
						return
					}
					
                    // 응답 결과 처리
					if let path = json["resultDirPath"] as? String {
						self.synapResultDirPath = path
					}
					
					if let name = json["resultDirPath"] as? String {
						self.synapFileName = name
					}
					
					if let key = json["key"] as? String {
						self.synapKey = key
					}
					
					// 파일 링크 컬러 설정
					//DispatchQueue.main.async { filenameButton.setTitleColor(.systemBlue, for: .normal) }
                    
                    // 첨부 파일 표시
                    showSynapView()
				}
				catch let error {
					print(error.localizedDescription)
				}
			}.resume()
		}
	}
	
	func showSynapView() {
        
		DispatchQueue.main.async {
			let v = SynapWebViewController()            
			v.messageId = self.filename
            if KB.KeyChain.isDev {
                v.urlString = "https://mkolonviewdev.kolon.com:8000/SynapDocViewServer/viewer/doc.html?key=\(self.synapKey)&contextPath=/SynapDocViewServer"
            } else {
                v.urlString = "https://mkolonview.kolon.com/SynapDocViewServer/viewer/doc.html?key=\(self.synapKey)&contextPath=/SynapDocViewServer"
            }
            v.modalPresentationStyle = .fullScreen
			let vc = UIApplication.shared.getCurrentViewController()
			vc?.present(v, animated: true, completion: nil)
		}
	}
}
