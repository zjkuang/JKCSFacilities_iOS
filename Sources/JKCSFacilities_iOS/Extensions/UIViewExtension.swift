//
//  UIViewExtension.swift
//  MyLab
//
//  Created by Zhengqian Kuang on 2019-09-05.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

public extension UIView {
    @discardableResult
    func makeRound() -> UIView {
        layoutIfNeeded()
        self.layer.cornerRadius = min(self.frame.width, self.frame.height) / 2
        return self
    }
    
    @discardableResult
    func addBorder(width: CGFloat, color: UIColor? = .black) -> UIView {
        layer.borderWidth = width
        layer.borderColor = color?.cgColor
        return self
    }
}
