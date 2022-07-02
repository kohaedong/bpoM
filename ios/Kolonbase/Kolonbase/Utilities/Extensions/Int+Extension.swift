//
//  Int+Extension.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/03/29.
//

import UIKit

public extension Int{

    var toString: String {
        return String(self)
    }
    
    func getMaxCountDescription(_ max : Int) ->String{
        if self > max{
            return "\(max)+"
        }
        return "\(self)"
    }
    
    func toTimeParts() -> TimeParts {
        let seconds = self % 60
        let mins = self / 60
        return TimeParts(seconds: seconds, minutes: mins)
    }
    
}

public struct TimeParts: CustomStringConvertible {
    public var seconds = 0
    public var minutes = 0
    public var description: String {
        if minutes == 0 {
            return NSString(format: "%d초", seconds) as String
        }else{
            return NSString(format: "%d분 %d초", minutes, seconds) as String
        }
    }
}

public extension Optional where Wrapped == Int {
    
    /**
     nil일 경우 "0"을 리턴한다.
     */
    var toString: String {
        return String(self == nil ? 0 : self!)
    }
}
