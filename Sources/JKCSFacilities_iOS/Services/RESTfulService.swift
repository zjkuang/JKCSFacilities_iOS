//
//  RESTfulService.swift
//  
//
//  Created by Zhengqian Kuang on 2019-10-05.
//

import Foundation
import Combine

public enum JKCS_RESTful_Error: String, Error {
    case genericError = "Generic Error"
    case invalidURL = "Invalid URL"
    case invalidResponse = "Invalid response"
    case httpStatusError = "HTTP status code error"
}

public class RESTfulService {
    
    public init() {
        
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
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Data in
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
