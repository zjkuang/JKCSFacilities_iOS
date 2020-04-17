//
//  UIApplicationExtensions.swift
//  
//
//  Created by Zhengqian Kuang on 2020-04-16.
//

import UIKit

public extension UIApplication {
    func openAppSettings() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            open(url, options: [:], completionHandler: nil)
        }
    }
}
