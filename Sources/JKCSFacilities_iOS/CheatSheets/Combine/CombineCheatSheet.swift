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
                return "(model) Invalid input"
            case .modelErrorRemoteFailure:
                return "(model) Remote failure"
            }
        }
    }

    public enum ViewModelResponse: String {
        case immediateViewModelResponse = "(viewmodel) Immediate value"
        case asynchronousViewModelResponse = "(viewmodel) Fetched from model"
    }

    public enum ViewModelError: Error {
        case viewModelErrorInvalidInput
        case viewModelErrorModelFailure(code: Int)

        public var message: String {
            switch self {
            case .viewModelErrorInvalidInput:
                return "(viewmodel) Invalid input"
            case .viewModelErrorModelFailure(let code):
                return "(viewmodel) Model failure (code \(code))"
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

public class TestCombineCheatSheet {
    private var combineCheatSheet = CombineCheatSheet()
    private var immediateViewModelFailureExpected: AnyCancellable?
    private var immediateViewModelAnswerExpected: AnyCancellable?
    private var immediateModelFailureExpected: AnyCancellable?
    private var immediateModelAnswerExpected: AnyCancellable?
    private var asynchronousFailureExpected: AnyCancellable?
    private var asynchronousAnswerExpected: AnyCancellable?
    
    public init() {
        
    }
    
    public func test() {
        immediateViewModelFailureExpected = combineCheatSheet.viewModelRequest(expectation: .immediateViewModelFailureExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error): // CombineCheatSheet.ViewModelError
                    print("immediateViewModelFailureExpected failed. \(error.message)")
                case .finished:
                    self.immediateViewModelFailureExpected = nil
                }
            }, receiveValue: { (_) in // CombineCheatSheet.ViewModelResponse
                
            })
        
        immediateViewModelAnswerExpected = combineCheatSheet.viewModelRequest(expectation: .immediateViewModelAnswerExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(_): // CombineCheatSheet.ViewModelError
                    break
                case .finished:
                    self.immediateViewModelAnswerExpected = nil
                }
            }, receiveValue: { (response) in // CombineCheatSheet.ViewModelResponse
                print("immediateViewModelAnswerExpected: \(response.rawValue)")
            })
            
        immediateModelFailureExpected = combineCheatSheet.viewModelRequest(expectation: .immediateModelFailureExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error): // CombineCheatSheet.ViewModelError
                    print("immediateModelFailureExpected failed. \(error.message)")
                case .finished:
                    self.immediateModelFailureExpected = nil
                }
            }, receiveValue: { (_) in // CombineCheatSheet.ViewModelResponse
                
            })
            
        immediateModelAnswerExpected = combineCheatSheet.viewModelRequest(expectation: .immediateModelAnswerExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(_): // CombineCheatSheet.ViewModelError
                    break
                case .finished:
                    self.immediateModelAnswerExpected = nil
                }
            }, receiveValue: { (response) in // CombineCheatSheet.ViewModelResponse
                print("immediateModelAnswerExpected: \(response.rawValue)")
            })
                
        asynchronousFailureExpected = combineCheatSheet.viewModelRequest(expectation: .asynchronousFailureExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(let error): // CombineCheatSheet.ViewModelError
                    print("asynchronousFailureExpected failed. \(error.message)")
                case .finished:
                    self.asynchronousFailureExpected = nil
                }
            }, receiveValue: { (_) in // CombineCheatSheet.ViewModelResponse
                
            })
                
        asynchronousAnswerExpected = combineCheatSheet.viewModelRequest(expectation: .asynchronousAnswerExpected)
            .sink(receiveCompletion: { (completion) in
                switch completion {
                case .failure(_): // CombineCheatSheet.ViewModelError
                    break
                case .finished:
                    self.asynchronousAnswerExpected = nil
                }
            }, receiveValue: { (response) in // CombineCheatSheet.ViewModelResponse
                print("asynchronousAnswerExpected: \(response.rawValue)")
            })
    }
}
