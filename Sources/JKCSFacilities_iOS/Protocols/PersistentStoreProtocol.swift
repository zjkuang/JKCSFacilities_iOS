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
    case userDefaults, keychain
}

public protocol PersistentStoreProtocol: Encodable, Decodable {
    // key can be specified by Caller, or, if Caller gives nil, will be dynamically generated either locally (as for .keychain or .userDefaults) or by backend (as for .backend). The key will be returned through completionHandler wrapped in Result's .success case
    // When .keychain is specified, KeychainAccess requires a service string. Caller can specify the service string, or, if omitted, a fixed value serviceUUID will be applied.
    func save(storage: PersistentStorageType, key: String, service: String?) -> Result<ExpressibleByNilLiteral?, JKCSError>
    
    static func retrieve<T: PersistentStoreProtocol>(storage: PersistentStorageType, key: String, service: String?) -> Result<T?, JKCSError>
    
    static func clearFromStorage(storage: PersistentStorageType, key: String, service: String?)
}

public extension PersistentStoreProtocol {
    func save(storage: PersistentStorageType, key: String, service: String? = nil) -> Result<ExpressibleByNilLiteral?, JKCSError> {
        let service = service ?? serviceUUID
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(self)
            // print(String(data: data, encoding: .utf8)!)
            
            switch storage {
            case .keychain:
                let keychain = Keychain(service: service)
                do {
                    try keychain.set(data, key: key)
                    return Result.success(nil)
                }
                catch {
                    return Result.failure(JKCSError.customError(message: "Failed to save data"))
                }
                
            case .userDefaults:
                UserDefaults.standard.set(data, forKey: key)
                return Result.success(nil)
            }
        }
        catch {
            return Result.failure(JKCSError.customError(message: "Failed to encode"))
        }
    }
    
    static func retrieve<T: PersistentStoreProtocol>(storage: PersistentStorageType, key: String, service: String? = nil) -> Result<T?, JKCSError> {
        let service = service ?? serviceUUID
        switch storage {
        case .keychain:
            let keychain = Keychain(service: service)
            var tryData: Data?
            do {
                tryData = try keychain.getData(key)
            }
            catch {
                return Result.success(nil)
            }
            guard let data = tryData else {
                return Result.success(nil)
            }
            let decoder = JSONDecoder()
            do {
                let instance = try decoder.decode(T.self, from: data)
                return Result.success(instance)
            }
            catch {
                return Result.failure(JKCSError.customError(message: "Failed to decode"))
            }
            
        case .userDefaults:
            guard let data = UserDefaults.standard.data(forKey: key) else {
                return Result.success(nil)
            }
            let decoder = JSONDecoder()
            do {
                let instance = try decoder.decode(T.self, from: data)
                return Result.success(instance)
            }
            catch {
                return Result.failure(JKCSError.customError(message: "Failed to decode"))
            }
        }
    }
    
    static func clearFromStorage(storage: PersistentStorageType, key: String, service: String? = nil) {
        let service = service ?? serviceUUID
        switch storage {
        case .keychain:
            let keychain = Keychain(service: service)
            keychain[key] = nil
            
        case .userDefaults:
            UserDefaults.standard.removeObject(forKey: key)
        }
    }
}
