//
//  DataExtensions.swift
//  MyLabSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-16.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

// MARK: - JSON

public extension Data {
    
    init?(withJSONObject jsonObject: Any) {
        do {
            self = try JSONSerialization.data(withJSONObject: jsonObject, options: []) // options can be .prettyPrinted
        }
        catch {
            return nil
        }
    }
    
    func decodeToJSONObject() -> Any? {
        do {
            return try JSONSerialization.jsonObject(with: self, options: [])
        }
        catch {
            return nil
        }
    }
    
}

// MARK: - Read-from/Write-to File

public extension Data {
    func write(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        guard var url = FileManager.default.urls(for: baseDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get base directory."))
        }
        if let relativePath = relativePath {
            url.appendPathComponent(relativePath)
        }
        url.appendPathComponent(filename)
        do {
            try write(to: url, options: .atomic)
            return Result.success(nil)
        } catch {
            return Result.failure(.customError(message: error.localizedDescription))
        }
    }
    
    static func read(filename: String, relativePath: String? = nil, baseDirectory: FileManager.SearchPathDirectory) -> Result<Self?, JKCSError> {
        guard var url = FileManager.default.urls(for: baseDirectory, in: .userDomainMask).first else {
            return Result.failure(.customError(message: "Failed to get base directory."))
        }
        if let relativePath = relativePath {
            url.appendPathComponent(relativePath)
        }
        url.appendPathComponent(filename)
        do {
            let data = try Data(contentsOf: url)
            return Result.success(data)
        } catch {
            return Result.success(nil)
        }
    }
}
