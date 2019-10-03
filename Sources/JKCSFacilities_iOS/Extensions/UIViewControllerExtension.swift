//
//  UIViewControllerExtension.swift
//  MyLabAWS
//
//  Created by Zhengqian Kuang on 2019-09-04.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

extension UIViewController {
    open func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillResignActive), name: UIApplication.willResignActiveNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationDidEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(applicationWillEnterForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidBecomeInactive), name: Notification.Name.userDidBecomeInactive, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(userDidBecomeActive), name: Notification.Name.userDidBecomeActive, object: nil)
    }
    
    @objc
    open func applicationDidBecomeActive() {}
    
    @objc
    open func applicationWillResignActive() {}
    
    @objc
    open func applicationDidEnterBackground() {}
    
    @objc
    open func applicationWillEnterForeground() {}
    
    @objc
    open func userDidBecomeInactive() {}
    
    @objc
    open func userDidBecomeActive() {}
}
