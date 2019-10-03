//
//  PublisherExtensions.swift
//  Tailboard
//
//  Created by Zhengqian Kuang on 2019-09-20.
//  Copyright © 2019 Robots & Pencils. All rights reserved.
//

import Combine

public extension Publisher {
    
    func combineLatest<C: Collection, Other: Publisher>(_ others: C) -> AnyPublisher<[Output], Failure>
    where C.Element == Other, Other.Output == Output, Other.Failure == Failure {
        let selfWithArrayOutput = self.map { [$0] }.eraseToAnyPublisher()
        return others.reduce(selfWithArrayOutput) { combinedPublisher, nextPublisher in
            return combinedPublisher.combineLatest(nextPublisher) { combinedOutput, nextOutput in
                combinedOutput + [nextOutput]
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }

    func combineLatestAllowingFailures<C: Collection, Other: Publisher>(_ others: C) -> AnyPublisher<[Result<Output, Failure>], Never>
    where C.Element == Other, Other.Output == Output, Other.Failure == Failure {
        let selfWithArrayOfResultOutput = self
            .map { .success($0) }
            .catch { Just(Result.failure($0)) }
            .map { [$0] }
            .eraseToAnyPublisher()
        return others.reduce(selfWithArrayOfResultOutput) { combinedPublisher, nextPublisher in
            let nextPublisherWithResultOutput = nextPublisher
                .map { .success($0) }
                .catch { Just(Result.failure($0)) }
            return combinedPublisher.combineLatest(nextPublisherWithResultOutput) { combinedOutput, nextOutput in
                combinedOutput + [nextOutput]
            }.eraseToAnyPublisher()
        }.eraseToAnyPublisher()
    }
    
}
