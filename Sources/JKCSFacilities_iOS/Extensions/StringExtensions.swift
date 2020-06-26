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

// MARK: - Substring

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
    
    static func <=(lhs: String, rhs: String) -> Bool {
        return !(lhs > rhs)
    }
    
    static func >=(lhs: String, rhs: String) -> Bool {
        return !(lhs < rhs)
    }
}

// MARK: - JSON

public extension String {
    func toJSONObject() -> Any? {
        guard let data = self.data(using: .utf8) else {
            return nil
        }
        let jsonObject = try? JSONSerialization.jsonObject(with: data, options: .allowFragments)
        return jsonObject
    }
}

// MARK: - Read-from/Write-to File

extension String {
    func write(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard let data = data(using: .utf8) else {
            return Result.failure(.customError(message: "Failed to convert to data using UTF8."))
        }
        return data.write(filename: filename, relativePath: relativePath, baseDirectory: baseDirectory)
    }
    
    static func read(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<Self?, JKCSError> {
        let result = Data.read(filename: filename, relativePath: relativePath, baseDirectory: baseDirectory)
        switch result {
        case .failure(let error):
            return Result.failure(error)
        case .success(let data):
            if let data = data {
                if let str = String(data: data, encoding: .utf8) {
                    return Result.success(str)
                }
                else {
                    return Result.failure(.customError(message: "Failed to decode data using UTF8."))
                }
            }
            else {
                return Result.success(nil)
            }
        }
    }
}
