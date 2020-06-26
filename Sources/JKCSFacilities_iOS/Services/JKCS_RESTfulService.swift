//
//  RESTfulService.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-05.
//



// DEPRECATED



import Foundation
import Combine

public enum JKCS_RESTful_Error: String, Error {
    case genericError = "Generic Error"
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid response"
    case httpStatusError = "HTTP status code error"
}

public struct JKCS_RESTfulServiceExampleIPJSONTestCom: Decodable {
    public let ip: String
}

fileprivate var JKCS_RESTfulServiceExampleRESTfulTest: AnyCancellable?

public class JKCS_RESTfulService: ObservableObject {
    
    @Published public var JKCS_RESTfulServiceRunning = false
    private var JKCS_RESTfulServiceCounter: Int = 0 {
        didSet {
            JKCS_RESTfulServiceRunning = (JKCS_RESTfulServiceCounter > 0)
            print("*** JKCS_RESTfulServiceCounter = \(JKCS_RESTfulServiceCounter), JKCS_RESTfulServiceRunning: \(JKCS_RESTfulServiceRunning ? "true" : "false")")
        }
    }
    
    public init() {
        
    }
    
    public func example(completionHandler: @escaping (Result<JKCS_RESTfulServiceExampleIPJSONTestCom, JKCS_RESTful_Error>) -> ()) {
        let urlString = "http://ip.jsontest.com/"
        JKCS_RESTfulServiceExampleRESTfulTest = JKCS_RESTfulService().get(urlString: urlString, respondObjectType: JKCS_RESTfulServiceExampleIPJSONTestCom.self)
            .receive(on: RunLoop.main)
            .sink(receiveCompletion: { completion in
                JKCS_RESTfulServiceExampleRESTfulTest = nil
                switch completion {
                case .failure(let error):
                    print("RESTfulService().example() test failed: \(urlString) \(error.localizedDescription)")
                    completionHandler(Result.failure(error))
                    break
                case .finished:
                    break
                }
            }, receiveValue: { ipJSONTestCom in
                print("RESTfulService().example() test succeeded: \(ipJSONTestCom.ip)")
                completionHandler(Result.success(ipJSONTestCom))
            })
    }
    
    public func get<T: Decodable>(urlString: String, headers: [String: String]? = nil, respondObjectType: T.Type) -> AnyPublisher<T, JKCS_RESTful_Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        increamentCounter()
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                self.decreamentCounter()
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw JKCS_RESTful_Error.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw JKCS_RESTful_Error.httpStatusError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? JKCS_RESTful_Error {
                    return error
                }
                return .genericError
            }
            .eraseToAnyPublisher()
    }
    
    public func post<T: Decodable>(urlString: String, body: [String: Any]? = nil, headers: [String: String]? = nil, respondObjectType: T.Type) -> AnyPublisher<T, JKCS_RESTful_Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        if let body = body,
            let data = Data(withJSONObject: body)
        {
            request.httpBody = data
        }
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        increamentCounter()
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                self.decreamentCounter()
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw JKCS_RESTful_Error.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw JKCS_RESTful_Error.httpStatusError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? JKCS_RESTful_Error {
                    return error
                }
                return .genericError
            }
            .eraseToAnyPublisher()
    }
    
    public func put<T: Decodable>(urlString: String, body: [String: Any]? = nil, headers: [String: String]? = nil, respondObjectType: T.Type) -> AnyPublisher<T, JKCS_RESTful_Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        if let body = body,
            let data = Data(withJSONObject: body)
        {
            request.httpBody = data
        }
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        increamentCounter()
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                self.decreamentCounter()
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw JKCS_RESTful_Error.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw JKCS_RESTful_Error.httpStatusError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? JKCS_RESTful_Error {
                    return error
                }
                return .genericError
            }
            .eraseToAnyPublisher()
    }
    
    public func patch<T: Decodable>(urlString: String, body: [String: Any]? = nil, headers: [String: String]? = nil, respondObjectType: T.Type) -> AnyPublisher<T, JKCS_RESTful_Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        if let body = body,
            let data = Data(withJSONObject: body)
        {
            request.httpBody = data
        }
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        increamentCounter()
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                self.decreamentCounter()
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw JKCS_RESTful_Error.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw JKCS_RESTful_Error.httpStatusError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? JKCS_RESTful_Error {
                    return error
                }
                return .genericError
            }
            .eraseToAnyPublisher()
    }
    
    public func delete<T: Decodable>(urlString: String, headers: [String: String]? = nil, respondObjectType: T.Type) -> AnyPublisher<T, JKCS_RESTful_Error> {
        guard let url = URL(string: urlString) else {
            fatalError("Invalid URL: \(urlString)")
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        if let headers = headers {
            request.allHTTPHeaderFields = headers
        }
        
        increamentCounter()
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
                self.decreamentCounter()
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw JKCS_RESTful_Error.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw JKCS_RESTful_Error.httpStatusError
                }
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let error = error as? JKCS_RESTful_Error {
                    return error
                }
                return .genericError
            }
            .eraseToAnyPublisher()
    }
    
}

public extension JKCS_RESTfulService {
    
    private func increamentCounter() {
        DispatchQueue.main.async {
            if self.JKCS_RESTfulServiceCounter < 0 {
                self.JKCS_RESTfulServiceCounter = 0
            }
            self.JKCS_RESTfulServiceCounter += 1
        }
    }
    
    private func decreamentCounter() {
        DispatchQueue.main.async {
            if self.JKCS_RESTfulServiceCounter > 0 {
                self.JKCS_RESTfulServiceCounter -= 1
            }
        }
    }
    
    func resetServiceCounter() {
        DispatchQueue.main.async {
            self.JKCS_RESTfulServiceCounter = 0
        }
    }
    
}
