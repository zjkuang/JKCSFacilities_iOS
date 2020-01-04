//
//  BundleExtensions.swift
//  
//
//  Created by Zhengqian Kuang on 2020-01-03.
//

import Foundation

public extension Bundle {
    
    var displayName: String? {
        return object(forInfoDictionaryKey: "CFBundleDisplayName") as? String ?? object(forInfoDictionaryKey: "CFBundleName") as? String
    }
    
    var releaseVersionNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
    
    var buildVersionNumber: String? {
        return object(forInfoDictionaryKey: "CFBundleVersion") as? String
    }
    
}
