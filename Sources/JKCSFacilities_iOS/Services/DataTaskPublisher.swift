//
//  DataTaskPublisher.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-07.
//

import Foundation
import Combine

class DataTaskPublisher {
    enum DataTaskError: Error {
        case genericError
        case invalidURL
        case invalidResponse
        case dataDecodeToJSONObjectAbnormal
        case httpStatusCode(Int)
    }
    
    public enum HTTP_Method: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    func dataTaskPublisher(method: HTTP_Method, url: String, headers: Dictionary<String, String>?, body: Dictionary<String, Any>?) -> AnyPublisher<Any, Error> {
        guard let url = URL(string: url) else {
            return Fail(error: DataTaskError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        var headers: [String:String] = headers ?? [:]
        let contentType = headers["content-type"]
        if contentType == nil {
            headers["content-type"] = "application/json"
        }
        for (httpHeaderField, value) in headers {
            request.addValue(value, forHTTPHeaderField: httpHeaderField)
        }
        if (body != nil) && (body!.count > 0) {
            request.httpBody = try! JSONSerialization.data(withJSONObject: body!, options: [])
        }
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { (data, response) -> Any in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw DataTaskError.invalidResponse
                }
                guard httpResponse.statusCode >= 200 && httpResponse.statusCode < 300 else {
                    // https://www.restapitutorial.com/httpstatuscodes.html
                    // 1xx Informational, 2xx Success, 3xx Redirection, 4xx Client Error, 5xx Server Error
                    throw DataTaskError.httpStatusCode(httpResponse.statusCode)
                }
                guard let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) else {
                    throw DataTaskError.dataDecodeToJSONObjectAbnormal
                }
                return jsonData
            }
            .mapError { error in
                return error
            }
            .eraseToAnyPublisher()
    }
}
