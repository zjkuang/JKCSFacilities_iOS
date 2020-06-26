//
//  ReachabilityDetector.swift
//  MyLabSwiftUI
//
//  Created by Zhengqian Kuang on 2019-09-27.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation
import Reachability

/**
 * You can observe the reachability in any of three ways
 *   - Instantiate ReachabilityDetector as a global variable and observe it via @Environment
 *   - Instantiate ReachabilityDetector privately and
 *     - pass the closure as the onChange handler along with detectMode = .closure
 *     - pass the detectMode = .notification and observe the internal notification .reachabilityChanged
 */

public class ReachabilityDetector: ObservableObject {
    
    public enum DetectMode {
        case closure, notification
    }
    private var detectMode: DetectMode = .closure
    
    public enum NetworkType {
        case void, disconnected, wifi, cellular
    }
    @Published public var network: NetworkType = .void
    
    private let reachability = Reachability()
    
    public init() {
        
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @discardableResult
    public func start() -> Self {
        self.detectMode = .notification
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(notification:)), name: .reachabilityChanged, object: reachability)
        
        startNotifier()
        
        return self
    }
    
    @discardableResult
    public func start(onChange: @escaping (NetworkType) -> ()) ->Self {
        self.detectMode = .closure
        
        reachability?.whenReachable = { reachability in
            if reachability.connection == .wifi {
                self.network = .wifi
            }
            else {
                self.network = .cellular
            }
            onChange(self.network)
        }
        
        reachability?.whenUnreachable = { _ in
            self.network = .disconnected
            onChange(self.network)
        }
        
        startNotifier()
        
        return self
    }
    
    private func startNotifier() {
        do {
            try reachability?.startNotifier()
        } catch {
            print("failed to start notifier for reachability")
        }
    }
    
    @objc private func reachabilityChanged(notification: Notification) {
        guard detectMode == .notification else {
            return
        }
        
        let reachability = notification.object as! Reachability
        switch reachability.connection {
        case .wifi:
            network = .wifi
        case .cellular:
            network = .cellular
        case .none:
            network = .disconnected
        }
        
        NotificationCenter.default.post(name: .reachabilityUpdated, object: nil)
    }
    
}
