//
//  StringExtensions.swift
//  MyLabSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-09.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

public extension String {
    
    static func isValid(str: String?) -> Bool {
        return (str != nil) && (str! != "")
    }
    
    @discardableResult mutating func append(str: String, separator: String) -> String {
        if self != "" {
            self += separator
        }
        self += str
        return self
    }
    
}
