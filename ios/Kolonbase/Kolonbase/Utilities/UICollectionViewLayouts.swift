//
//  UICollectionViewLayouts.swift
//  IKEN-Work
//
//  Created by mk on 2020/12/19.
//

import UIKit

class LeftAlignedCollectionViewFlowLayout: UICollectionViewFlowLayout {
	
	override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
		
		var leftMargin = sectionInset.left
		var maxY: CGFloat = -1.0
		
		let attributes = super.layoutAttributesForElements(in: rect)
		attributes?.forEach { layoutAttribute in
			
			if layoutAttribute.frame.origin.y >= maxY {
				
				leftMargin = sectionInset.left
			}
			
			layoutAttribute.frame.origin.x = leftMargin
			
			leftMargin += layoutAttribute.frame.width + minimumInteritemSpacing
			maxY = max(layoutAttribute.frame.maxY , maxY)
		}
		
		return attributes
	}
}
