//
//  Dictionary+Extension.swift
//  Kolonbase
//
//  Created by 이가람 on 2021/06/16.
//

import UIKit

public extension Dictionary {
    
   func toJsonString() -> String {
     do {
           let jsonData = try JSONSerialization.data(withJSONObject: self, options: [])

           let jsonString = String(data: jsonData, encoding: .utf8)

        return jsonString ?? ""
       } catch {
           print(error.localizedDescription)
        return ""
       }
  }
}
