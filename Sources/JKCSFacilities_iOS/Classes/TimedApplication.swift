#if os(iOS)
#if canImport(UIKit)
import UIKit
#endif
#endif

class TimedApplication: UIApplication {
    private var idleTimer: Timer?
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(userDidBecomeActive), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        resetIdleTimer()
    }
    
    override func sendEvent(_ event: UIEvent) {
        super.sendEvent(event)
        
        if let touches = event.allTouches,
            touches.any({ $0.phase == .began }){
            userDidBecomeActive()
        }
    }
    
    private func resetIdleTimer() {
        if let idleTimer = idleTimer {
            idleTimer.invalidate()
        }
        if Preferences.userActivityTimeoutInSeconds > 0.01 {
            idleTimer = Timer.scheduledTimer(timeInterval: Preferences.userActivityTimeoutInSeconds, target: self, selector: #selector(idleTimerExceeded), userInfo: nil, repeats: false)
        }
    }
    
    @objc
    private func idleTimerExceeded() {
        NotificationCenter.default.post(name: .userDidBecomeInactive, object: nil)
    }
    
    @objc
    internal func userDidBecomeActive() {
        NotificationCenter.default.post(name: .userDidBecomeActive, object: nil)
        resetIdleTimer()
    }
}
