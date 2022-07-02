//
//  UIImageView+Extension.swift
//  Kolonbase
//
//  Created by mk on 2020/11/11.
//

import UIKit

//MARK: - Image Download
class Cache {
	
	static let imageCache = NSCache<NSString, UIImage>()
}

public extension UIImageView {
	
	func downloadedFrom(link: String, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		
		guard let url = URL(string: link) else { return }
		
		downloadedFrom(url: url, contentMode: mode)
	}
	
	func downloadedFrom(url: URL, contentMode mode: UIView.ContentMode = .scaleAspectFit) {
		
		self.contentMode = mode
		
		if let cacheImage = Cache.imageCache.object(forKey: url.absoluteString as NSString) {
			
			DispatchQueue.main.async() {
				
				UIView.transition(with: self, duration: 0.14, options: .transitionCrossDissolve, animations: {
					
					self.image = cacheImage
				}, completion: nil)
			}
		}
		else {
			
			var request = URLRequest(url: url)
			request.httpMethod = "GET"
			
			URLSession.shared.dataTask(with: request) { data, response, error in
				
				guard
					let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
					let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
					let data = data, error == nil,
					let image = UIImage(data: data)
				else {
					
					print("Download image fail : \(url)")
					return
				}
				
				DispatchQueue.main.async() {
					
					print("Download image success \(url)")
					
					Cache.imageCache.setObject(image, forKey: url.absoluteString as NSString)
					
					UIView.transition(with: self, duration: 0.15, options: .transitionCrossDissolve, animations: {
						
						self.image = image
					}, completion: nil)
				}
			}.resume()
		}
	}
    
    func setDefaultThumbnail() {
        
        self.backgroundColor = UIColor(named: "Gray P4 0.3")
        self.layer.cornerRadius = self.frame.width / 2
        self.image = UIImage(named: "icon-outlined-24-px-person", in: Bundle(identifier: baseBundleId), compatibleWith: nil)
        self.clipsToBounds = true
    }
}
