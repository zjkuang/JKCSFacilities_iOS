//
//  DataExtensions.swift
//  MyLabSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-16.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

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
