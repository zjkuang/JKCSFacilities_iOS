//
//  UIViewExtensions.swift
//  MyLab
//
//  Created by Zhengqian Kuang on 2019-09-05.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import UIKit

// MARK: - Appearance

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

// MARK: - Position

public extension UIView {
    
    func absolutePosition(to outerView: UIView? = nil) -> CGPoint {
        var absolutePosition = CGPoint(x: 0, y: 0)
        if self.superview != nil {
            let window = UIApplication.shared.windows.filter {$0.isKeyWindow}.first
            absolutePosition = self.superview!.convert(self.frame.origin, to: outerView ?? window?.rootViewController?.view)
        }
        return absolutePosition
    }
    
}

// MARK: - Hierarchy

public extension UIView {
    
    func hierarchy(parent: TreeNode? = nil) -> TreeNode {
        let myNode = TreeNode(myself: self)
        myNode.myself = self
        myNode.parent = parent
        for subview in self.subviews {
            if subview.superview != self {
                continue;
            }
            let subnode = subview.hierarchy(parent: myNode)
            myNode.immediateChildren.append(subnode)
        }
        return myNode
    }
    
}
