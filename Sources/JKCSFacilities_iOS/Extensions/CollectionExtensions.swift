//
//  CollectionExtensions.swift
//  Tailboard
//
//  Created by Zhengqian Kuang on 2019-09-20.
//  Copyright © 2019 Robots & Pencils. All rights reserved.
//

import Combine

public extension Collection where Element: Publisher {
    
    func combineLatest() -> AnyPublisher<[Element.Output], Element.Failure> {
        guard let first = first else {
            return Just<[Element.Output]>([]).setFailureType(to: Element.Failure.self).eraseToAnyPublisher()
        }
        return first.combineLatest(dropFirst())
    }

    func combineLatestAllowingFailures() -> AnyPublisher<[Result<Element.Output, Element.Failure>], Never> {
        guard let first = first else {
            return Just<[Result<Element.Output, Element.Failure>]>([]).eraseToAnyPublisher()
        }
        return first.combineLatestAllowingFailures(dropFirst())
    }
    
}
