//
//  CombineCheatSheet.swift
//  
//
//  Created by Zhengqian Kuang on 2020-05-17.
//

import Foundation
import Combine

public class CombineCheatSheet {
    public enum ModelResponse: Int {
        case immediateModelResponse = 1
        case asynchronousModelResponse = 2
    }

    public enum ModelError: Error {
        case modelErrorInvalidInput, modelErrorRemoteFailure
        
        public var code: Int {
            switch self {
            case .modelErrorInvalidInput:
                return 1
            case .modelErrorRemoteFailure:
                return 2
            }
        }
        
        public var message: String {
            switch self {
            case .modelErrorInvalidInput:
                return "(Model) Invalid input"
            case .modelErrorRemoteFailure:
                return "(Model) Remote failure"
            }
        }
    }

    public enum ViewModelResponse: String {
        case immediateViewModelResponse = "(Viewmodel) Immediate value"
        case asynchronousViewModelResponse = "Fetched from remote server"
    }

    public enum ViewModelError: Error {
        case viewModelErrorInvalidInput
        case viewModelErrorModelFailure(code: Int)

        public var message: String {
            switch self {
            case .viewModelErrorInvalidInput:
                return "(Viewmodel) Invalid input"
            case .viewModelErrorModelFailure(let code):
                return "(Viewmodel) Model failure (code \(code))"
            }
        }
    }

    public enum Expectation {
        case immediateViewModelAnswerExpected
        case immediateViewModelFailureExpected
        case immediateModelAnswerExpected
        case immediateModelFailureExpected
        case asynchronousAnswerExpected
        case asynchronousFailureExpected
    }
    
    public init() {
        
    }

    public func modelRequest(expectation: Expectation) -> AnyPublisher<ModelResponse, ModelError> {
        switch expectation {
        case .immediateModelAnswerExpected:
            return Just<ModelResponse>(.immediateModelResponse).setFailureType(to: ModelError.self).eraseToAnyPublisher()
        case .immediateModelFailureExpected:
            return Fail<ModelResponse, ModelError>(error: .modelErrorInvalidInput).eraseToAnyPublisher()
        case .asynchronousAnswerExpected, .asynchronousFailureExpected:
            return Future<ModelResponse, ModelError> { (promise) in
                DispatchQueue.main.async {
                    let result = (expectation == .asynchronousAnswerExpected) ? Result.success(ModelResponse.asynchronousModelResponse) : Result.failure(ModelError.modelErrorRemoteFailure)
                    promise(result)
                }
            }.eraseToAnyPublisher()
        default:
            return Fail<ModelResponse, ModelError>(error: .modelErrorInvalidInput).eraseToAnyPublisher()
        }
    }

    public func viewModelRequest(expectation: Expectation) -> AnyPublisher<ViewModelResponse, ViewModelError> {
        switch expectation {
        case .immediateViewModelFailureExpected:
            return Fail<ViewModelResponse, ViewModelError>(error: .viewModelErrorInvalidInput).eraseToAnyPublisher()
        case .immediateViewModelAnswerExpected:
            return Just<ViewModelResponse>(.immediateViewModelResponse).setFailureType(to: ViewModelError.self).eraseToAnyPublisher()
        case .immediateModelFailureExpected, .immediateModelAnswerExpected, .asynchronousFailureExpected, .asynchronousAnswerExpected:
            return modelRequest(expectation: expectation)
                .map { (modelResponse) -> ViewModelResponse in
                    switch modelResponse {
                    case .immediateModelResponse, .asynchronousModelResponse:
                        return .asynchronousViewModelResponse
                    }
            }
            .mapError { (modelError) -> ViewModelError in
                switch modelError {
                case .modelErrorInvalidInput, .modelErrorRemoteFailure:
                    return .viewModelErrorModelFailure(code: modelError.code)
                }
            }
            .eraseToAnyPublisher()
        }
    }
}
