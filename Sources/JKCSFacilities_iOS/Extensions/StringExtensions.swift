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

// Substrings https://stackoverflow.com/a/46133083/5424189
public extension String {
    subscript(_ range: CountableRange<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
        let end = index(start, offsetBy: min(self.count - range.lowerBound,
                                             range.upperBound - range.lowerBound))
        return String(self[start..<end])
    }

    subscript(_ range: CountablePartialRangeFrom<Int>) -> String {
        let start = index(startIndex, offsetBy: max(0, range.lowerBound))
         return String(self[start...])
    }
}

public extension String {
    static func <(lhs: String, rhs: String) -> Bool {
        return (lhs.compare(rhs) == .orderedAscending)
    }
    
    static func >(lhs: String, rhs: String) -> Bool {
        return (lhs.compare(rhs) == .orderedDescending)
    }
}
