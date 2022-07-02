//
//  UIScrollView+Extension.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/02/09.
//

import UIKit

public extension UIScrollView {
    
    func setContentOffsetBottom(_ animated : Bool){
        
        let bottomOffset = CGPoint(x: 0, y: self.contentSize.height - self.bounds.height + self.contentInset.bottom)
        self.setContentOffset(bottomOffset, animated: animated)
        
    }
    
    /**
     키보드를 불러오는 경우 실행하면 타겟을 키보드 위로 올림.
     
     - parameter target: 타겟이 될 뷰. 텍스튜뷰나 텍스트필드.
     - parameter target: 키보드의 높이.
    
     # Notes: #
     1. 스크롤뷰의 슈퍼뷰는 뷰컨트롤러의 뷰여야 한다.
     2. 타겟이 되는 뷰의 슈퍼뷰가 스크롤뷰가 아니더라도 위치를 감지해낸다.
     3. 스크롤뷰는 키보드를 덮을 정도의 높이와 위치를 가지고 있어야 한다.
     4. VALUE_MOVED_BY_KEYBOARD값에 키보드로 인해 이동한 높이값을 저장해놓는다.
     5. UIScrollView에 정의된 resumeViewAtUpperKeyboard() 메소드를 이용하면 VALUE_MOVED_BY_KEYBOARD 값을 이용하여 스크롤뷰를 원래대로 돌린다.
     */
    func setContentUpperKeyboard(target: UIView, _ keyboardHeight: CGFloat = KEYBOARD_HEIGHT, margin: CGFloat = 20, completionHandler: ((CGFloat?)->Void)? = nil) {
        
        DispatchQueue.main.async {
            
            guard var tempSuperView = target.superview else {
                return
            }
            
            let keyboardMinYPositionInScreen = SCREEN_HEIGHT - keyboardHeight
            var tempXPosition = self.contentOffset.x + target.frame.minX
            var tempYPosition = target.frame.maxY - self.contentOffset.y
            
            if tempSuperView != self {
                
                while tempSuperView.superview != self, tempSuperView.superview != nil {
                    
                    tempYPosition += (tempSuperView.frame.height - target.frame.minY)
                    tempXPosition += tempSuperView.superview!.frame.minX
                    tempSuperView = tempSuperView.superview!
                }
                
                tempYPosition += tempSuperView.frame.minY
            }
            
            guard tempYPosition > 0 else {
                return
            }
            
            let targetMaxYPositionInScreen = self.frame.minY + tempYPosition
            if targetMaxYPositionInScreen > keyboardMinYPositionInScreen {
                
                let movingValue = targetMaxYPositionInScreen - keyboardMinYPositionInScreen + margin
                
                UIView.animate(withDuration: 0.3) {
                    
                    self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y + movingValue), animated: true)
                    VALUE_MOVED_BY_KEYBOARD = movingValue
                }
            } else {
                VALUE_MOVED_BY_KEYBOARD = 0
            }
        }
    }
    
    /**
     키보드에 의해 올라간 스크롤뷰를 원래대로 돌린다.
     
     - warning: setContentUpperKeyboard()를 이용해서 VALUE_MOVED_BY_KEYBOARD를 저장해놓지 않은 상황이라면 원치 않는 결과를 얻을 수 있음.
     
     # Notes: #
     1. VALUE_MOVED_BY_KEYBOARD 값을 이용하여 스크롤뷰를 원래대로 돌린다.
     */
    func resumeViewAtUpperKeyboard() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.3) {
                if self.contentOffset.y > VALUE_MOVED_BY_KEYBOARD {
                    self.setContentOffset(CGPoint(x: 0, y: self.contentOffset.y - VALUE_MOVED_BY_KEYBOARD), animated: true)
                } else {
                    self.setContentOffset(CGPoint(x: 0, y: 0), animated: true)
                }
            }
        }
    }
}
