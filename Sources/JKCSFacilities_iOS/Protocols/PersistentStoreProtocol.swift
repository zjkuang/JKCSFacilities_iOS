//
//  PersistentStoreProtocol.swift
//  
//
//  Created by Zhengqian Kuang on 2020-04-27.
//

import Foundation
import KeychainAccess

fileprivate let serviceUUID = "E7DB5457-B178-42A0-B4A5-C7803B5FEED3" // fixed service string required by KeychainAccess when absent from being provided by Caller

public enum PersistentStorageType: String {
    case userDefaults, keychain, backend
}

public protocol PersistentStoreProtocol: Encodable, Decodable {
    // key can be specified by Caller, or, if Caller gives nil, will be dynamically generated either locally (as for .keychain or .userDefaults) or by backend (as for .backend). The key will be returned through completionHandler wrapped in Result's .success case
    // When .keychain is specified, KeychainAccess requires a service string. Caller can specify the service string, or, if omitted, a fixed value serviceUUID will be applied.
    func save(storage: PersistentStorageType, key: String?, service: String?, completionHandler: @escaping (Result<String, JKCSError>) -> ())
    
    static func retrieve<T: PersistentStoreProtocol>(storage: PersistentStorageType, key: String, service: String?, completionHandler: @escaping (Result<T, JKCSError>) -> ())
    
    static func clearFromStorage(storage: PersistentStorageType, key: String, service: String?, completionHandler: @escaping (Result<ExpressibleByNilLiteral?, JKCSError>) -> ())
}

public extension PersistentStoreProtocol {
    func save(storage: PersistentStorageType, key: String? = nil, service: String? = nil, completionHandler: @escaping (Result<String, JKCSError>) -> ()) {
        let key = key ?? UUID().uuidString
        let service = service ?? serviceUUID
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            // print(String(data: data, encoding: .utf8)!)
            
            switch storage {
            case .backend:
                completionHandler(Result.failure(JKCSError.customError(message: "To be implemented")))
                
            case .keychain:
                let keychain = Keychain(service: service)
                do {
                    try keychain.set(data, key: key)
                    completionHandler(Result.success(key))
                }
                catch {
                    completionHandler(Result.failure(JKCSError.customError(message: "Failed to save data")))
                }
                
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: key)
                completionHandler(Result.success(key))
            }
        }
        catch {
            completionHandler(Result.failure(JKCSError.customError(message: "Failed to encode")))
        }
    }
    
    static func retrieve<T: PersistentStoreProtocol>(storage: PersistentStorageType, key: String, service: String? = nil, completionHandler: @escaping (Result<T?, JKCSError>) -> ()) {
        let service = service ?? serviceUUID
        switch storage {
        case .backend:
            completionHandler(Result.failure(JKCSError.customError(message: "To be implemented")))
            
        case .keychain:
            let keychain = Keychain(service: service)
            var tryData: Data?
            do {
                tryData = try keychain.getData(key)
            }
            catch {
                completionHandler(Result.success(nil))
                return
            }
            guard let data = tryData else {
                completionHandler(Result.success(nil))
                return
            }
            let decoder = JSONDecoder()
            do {
                let instance = try decoder.decode(T.self, from: data)
                completionHandler(Result.success(instance))
            }
            catch {
                completionHandler(Result.failure(JKCSError.customError(message: "Failed to decode")))
            }
            
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: key) else {
                completionHandler(Result.success(nil))
                return
            }
            let decoder = JSONDecoder()
            do {
                let instance = try decoder.decode(T.self, from: data)
                completionHandler(Result.success(instance))
            }
            catch {
                completionHandler(Result.failure(JKCSError.customError(message: "Failed to decode")))
            }
        }
    }
    
    static func clearFromStorage(storage: PersistentStorageType, key: String, service: String? = nil, completionHandler: @escaping (Result<ExpressibleByNilLiteral?, JKCSError>) -> ()) {
        let service = service ?? serviceUUID
        switch storage {
        case .backend:
            completionHandler(Result.failure(JKCSError.customError(message: "To be implemented")))
            
        case .keychain:
            let keychain = Keychain(service: service)
            keychain[key] = nil
            completionHandler(Result.success(nil))
            
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
            completionHandler(Result.success(nil))
        }
    }
}
