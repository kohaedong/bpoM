//
//  UIImageExtension.swift
//  OnStudy iOS
//
//  Created by mk on 2020/06/15.
//  Copyright © 2020 mk. All rights reserved.
//

import UIKit
import CoreImage

//MARK: - Image Transform
public extension UIImage {
	
	// MARK: - Image Scale
	func scaled(with scale: CGFloat) -> UIImage? {
		
		let size = CGSize(width: floor(self.size.width * scale), height: floor(self.size.height * scale))
		
		UIGraphicsBeginImageContext(size)
		draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	func scaled(with size: CGSize) -> UIImage? {
		
		UIGraphicsBeginImageContext(size)
		draw(in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
		let image = UIGraphicsGetImageFromCurrentImageContext()
		UIGraphicsEndImageContext()
		
		return image
	}
	
	
	// MARK: - Image Rotate
	func rotate(radians: CGFloat) -> UIImage {
		
		let rotatedSize = CGRect(origin: .zero, size: size)
			.applying(CGAffineTransform(rotationAngle: CGFloat(radians)))
			.integral.size
		UIGraphicsBeginImageContext(rotatedSize)
		
		if let context = UIGraphicsGetCurrentContext() {
			
			let origin = CGPoint(x: rotatedSize.width / 2.0, y: rotatedSize.height / 2.0)
			context.translateBy(x: origin.x, y: origin.y)
			context.rotate(by: radians)
			draw(in: CGRect(x: -origin.y, y: -origin.x, width: size.width, height: size.height))
			let rotatedImage = UIGraphicsGetImageFromCurrentImageContext()
			UIGraphicsEndImageContext()
			
			return rotatedImage ?? self
		}
		
		return self
	}
}
