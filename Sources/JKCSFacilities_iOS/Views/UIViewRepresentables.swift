//
//  UIViewRepresentables.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-05.
//

import SwiftUI

public struct ActivityIndicatorView: UIViewRepresentable {
    public var uiActivityIndicatorView = UIActivityIndicatorView()
    @Binding var isAnimating: Bool
    
    public func makeUIView(context: Context) -> UIActivityIndicatorView {
        return uiActivityIndicatorView
    }
    
    public func updateUIView(_ uiView: UIActivityIndicatorView, context: Context) {
        $isAnimating.wrappedValue ? uiView.startAnimating() : uiView.stopAnimating()
    }
}
