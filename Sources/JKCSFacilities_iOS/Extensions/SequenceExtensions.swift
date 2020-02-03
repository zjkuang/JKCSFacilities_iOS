//
//  SequenceExtensions.swift
//  MyLabAWS
//
//  Created by Zhengqian Kuang on 2019-09-04.
//  Copyright © 2019 Zhengqian Kuang. All rights reserved.
//

import Foundation

public extension Sequence {
    
    func all(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return reduce(true) { $0 && predicate($1) }
    }
    
    func any(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return reduce(false) { $0 || predicate($1) }
    }
    
    func none(_ predicate: (Iterator.Element) -> Bool) -> Bool {
        return !any(predicate)
    }
    
}
