//
//  UIKitAgent.swift
//  MyLab
//
//  Created by Zhengqian Kuang on 2020-06-25.
//  Copyright © 2020 Zhengqian Kuang. All rights reserved.
//

import UIKit

public class JKCSUIKitAgent {
    public lazy var isPad: Bool = {
        return (UIDevice.current.userInterfaceIdiom == .pad)
    }()
    
    public lazy var isPhone: Bool = {
        return (UIDevice.current.userInterfaceIdiom == .phone)
    }()
}

public final class JKCSOrientationObservable: ObservableObject { // https://developer.apple.com/forums/thread/126878
    public enum Orientation {
        case unknown
        case portrait
        case landscape
    }
    
    @Published public var orientation: Orientation
    
    private var _observer: NSObjectProtocol?
    
    public init() {
        // fairly arbitrary starting value for 'flat' orientations
        if UIDevice.current.orientation.isLandscape {
            self.orientation = .landscape
        }
        else {
            self.orientation = .portrait
        }
        
        // unowned self because we unregister before self becomes invalid
        _observer = NotificationCenter.default.addObserver(forName: UIDevice.orientationDidChangeNotification, object: nil, queue: nil) { [unowned self] note in
            guard let device = note.object as? UIDevice else {
                return
            }
            if device.orientation.isPortrait {
                self.orientation = .portrait
            }
            else if device.orientation.isLandscape {
                self.orientation = .landscape
            }
        }
    }
    
    deinit {
        if let observer = _observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
    // Usage
//    struct ContentView: View {
//        @EnvironmentObject var orientationObservable: JKCSOrientationObservable
//
//        var body: some View {
//            Text("Orientation is '\(orientationObservable.orientation == .portrait ? "portrait" : "landscape")'")
//        }
//    }
}
