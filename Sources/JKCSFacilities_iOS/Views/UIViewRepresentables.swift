//
//  UIViewRepresentables.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-05.
//

import SwiftUI

public struct ActivityIndicatorView: UIViewRepresentable {
    public var uiActivityIndicatorView = UIActivityIndicatorView()
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        return UIActivityIndicatorView()
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        
    }
    
    public func startAnimating() {
        uiActivityIndicatorView.startAnimating()
    }
    
    public func stopAnimating() {
        uiActivityIndicatorView.stopAnimating()
    }
}
