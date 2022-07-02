//
//  NSError+Extension.swift
//  Kolonbase
//
//  Created by 백상휘 on 2021/05/13.
//

import Foundation

public extension NSError {
    
    func getURLError() -> KBErrorMessageType {
        
        if self.domain == NSURLErrorDomain {
//            return (400...499 ~= self.code ? .networkError : .serverProcessingError)
            return (400...499 ~= self.code ? .clientProcessingError : .serverProcessingError)
        } else {
            return .clientProcessingError
        }
    }
}
