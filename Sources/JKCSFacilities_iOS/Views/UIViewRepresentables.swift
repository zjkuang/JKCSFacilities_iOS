//
//  UIViewRepresentables.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-05.
//

import SwiftUI

public struct ActivityIndicatorView: UIViewRepresentable {
    public var uiActivityIndicatorView = UIActivityIndicatorView()
    
    public init() {
        
    }
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        return uiActivityIndicatorView
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
    public func startAnimating() -> Self {
        uiActivityIndicatorView.startAnimating()
        return self
    }
    
    public func stopAnimating() -> Self {
        uiActivityIndicatorView.stopAnimating()
        return self
    }
}
