//
//  Tree.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-04.
//

import Foundation

public protocol TreeNode {
    var myself: Any {get set}
    var parent: TreeNode {get set}
    var immediateChildren: Array<TreeNode> {get set}
}
