//
//  File.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-03.
//

import Foundation

public extension URL {
    
    static func urlEscaped(scheme: String?, host: String, path: String, queryItems: [String: String]) -> URL? {
        var urlQueryItems: [URLQueryItem] = []
        for (key, value) in queryItems {
            let urlQueryItem = URLQueryItem(name: key, value: value)
            urlQueryItems.append(urlQueryItem)
        }
        
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = path
        urlComponents.queryItems = urlQueryItems
        return urlComponents.url
    }
    
    static func urlQueryStringEscaped(queryItems: [String: String]) -> String? {
        var urlQueryItems: [URLQueryItem] = []
        for (key, value) in queryItems {
            let urlQueryItem = URLQueryItem(name: key, value: value)
            urlQueryItems.append(urlQueryItem)
        }
        
        var urlComponents = URLComponents()
        urlComponents.queryItems = urlQueryItems
        return urlComponents.string
    }
    
}
