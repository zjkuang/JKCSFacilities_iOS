//
//  Tree.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-04.
//

import Foundation

public class TreeNode {
    public var myself: Any
    public var parent: TreeNode? = nil
    public var immediateChildren: Array<TreeNode> = []
    
    init(myself: Any) {
        self.myself = myself
    }
}
