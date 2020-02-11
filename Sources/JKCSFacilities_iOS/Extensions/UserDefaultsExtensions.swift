//
//  File.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-11.
//

import Foundation

fileprivate let deviceUUIDKey = "B56EE8BF-327C-41F3-83D5-107C8879BAA7"

public extension UserDefaults {
    func deviceUUID() -> String {
        if let deviceUUID = self.string(forKey: deviceUUIDKey) {
            return deviceUUID
        }
        else {
            let deviceUUID = UUID().uuidString
            self.set(deviceUUID, forKey: deviceUUIDKey)
            return deviceUUID
        }
    }
    
    func clearDeviceUUID() {
        self.removeObject(forKey: deviceUUIDKey)
    }
}
