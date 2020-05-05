//
//  StringExtensions.swift
//  MyLabSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-09.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

public extension String {
    
    static func isValid(_ str: String?) -> Bool {
        return (str != nil) && (str! != "")
    }
    
    @discardableResult mutating func append(str: String, separator: String) -> String {
        if self != "" {
            self += separator
        }
        self += str
        return self
    }
    
    func strikeThru() -> String { // https://gist.github.com/joltguy/d7f8ea304c30c492c2257f9c9f7acba3
        var struck = ""
        let strikeChar: Character = "\u{0336}"
        self.forEach { (char) in
            var xchar = UnicodeScalarView(char.unicodeScalars)
            xchar.append(strikeChar.unicodeScalars.first!)
            struck.append(String(xchar))
        }
        return struck
    }
    
}
