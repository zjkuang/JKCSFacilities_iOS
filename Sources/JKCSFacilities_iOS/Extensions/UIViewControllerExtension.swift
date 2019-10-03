//
//  UIViewControllerExtension.swift
//  MyLabAWS
//
//  Created by Zhengqian Kuang on 2019-09-04.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

extension UIViewController {
    internal func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidBecomeInactive), name: Notification.Name.userDidBecomeInactive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidBecomeActive), name: Notification.Name.userDidBecomeActive, object: nil)
    }
    
    @objc
    internal func applicationDidBecomeActive() {}
    
    @objc
    internal func applicationWillResignActive() {}
    
    @objc
    internal func applicationDidEnterBackground() {}
    
    @objc
    internal func applicationWillEnterForeground() {}
    
    @objc
    internal func userDidBecomeInactive() {}
    
    @objc
    internal func userDidBecomeActive() {}
}
