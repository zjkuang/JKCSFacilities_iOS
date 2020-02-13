//
//  File.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-13.
//

import Foundation

public func readJSONFile(forResource resource: String, ofType type: String) -> Any? {
    if let path = Bundle.main.path(forResource: resource, ofType: type) {
        do {
            let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
            let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
            return jsonResult
        } catch let error {
            print("*** JSON parse error: \(error.localizedDescription)")
        }
    }
    return nil
}
