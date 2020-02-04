//
//  DataTask.swift
//  
//
//  Created by Zhengqian Kuang on 2020-02-04.
//

import Foundation

public class JKCS_DataTask: NSObject {
    
    public enum OwnerState {
        case undefined, active, inactive
    }
    
    public enum HTTP_Method: String {
        case GET = "GET"
        case POST = "POST"
        case PUT = "PUT"
        case DELETE = "DELETE"
    }
    
    public static let debug_resonse_delay: Int = 0 // to add an extra delay onto response time
    
    private weak var owner: AnyObject?
    public var ownerState: OwnerState = .undefined
    private static var dictDataTasks: [String: AnyObject] = [:] // [dataTaskId:owner]
    
    public convenience init(owner: AnyObject) {
        self.init()
        self.owner = owner
        ownerState = .active
    }
    
    private class func newDataTaskId() -> String {
        let uuidString = NSUUID().uuidString
        return uuidString
    }
    
    private func dataTask(method: HTTP_Method, sURL: String, headers dictHeaders: Dictionary<String, String>?, body dictBody: Dictionary<String, String>?, completion: @escaping (Dictionary<String, Any>?, URLResponse?, Error?) -> ()) {
        let url = URL(string: sURL)
        if url != nil {
            // URLSession.shared.dataTask(with: url!, completionHandler: completion).resume()
            
            var request = URLRequest(url: url!)
            request.httpMethod = method.rawValue
            var dictHeaders: [String:String] = dictHeaders ?? [:]
            let contentType = dictHeaders["content-type"]
            if contentType == nil {
                dictHeaders["content-type"] = "application/json"
            }
            for (httpHeaderField, value) in dictHeaders {
                request.addValue(value, forHTTPHeaderField: httpHeaderField)
            }
            if (dictBody != nil) && (dictBody!.count > 0) {
                request.httpBody = try! JSONSerialization.data(withJSONObject: dictBody!, options: [])
            }
            
            DispatchQueue.main.async {
                let dataTaskId = JKCS_DataTask.newDataTaskId()
                JKCS_DataTask.mainThread_dataTaskWillStart(byOwner: self.owner, withDataTaskId: dataTaskId)
                _ = URLSession.shared.dataTask(with: request) { (data, urlResponse, error) in
                    DispatchQueue.main.asyncAfter(deadline: (.now() + .seconds(JKCS_DataTask.debug_resonse_delay)), execute: {
                        let owner = JKCS_DataTask.dictDataTasks[dataTaskId]
                        JKCS_DataTask.mainThread_dataTaskDidEnd(withDataTaskId: dataTaskId)
                        if (owner != nil) && (self.ownerState == .active) {
                            if let urlResponse = urlResponse,
                                let data = data,
                                let jsonData = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) {
                                let dictResponse = ["__RESPONSE__": jsonData]
                                completion(dictResponse, urlResponse, error)
                            } else {
                                let dictResponse = ["__FAILURE__": "Response abnormal. Discarded."]
                                completion(dictResponse, urlResponse, error)
                            }
                        }
                        else {
                            let dictResponse = ["__CANCELLED__": "DataTask's owner is not active. Response discarded."]
                            completion(dictResponse, urlResponse, error)
                        }
                    })}.resume()
            }
            
        }
    }
    
    /**
     *  MUST be called within MAINTHREAD
     */
    private static func mainThread_dataTaskWillStart(byOwner owner: AnyObject?, withDataTaskId dataTaskId: String) {
        if let owner = owner {
            dictDataTasks[dataTaskId] = owner
        }
    }
    
    /**
     *  MUST be called within MAINTHREAD
     */
    private static func mainThread_dataTaskDidEnd(withDataTaskId dataTaskId: String) {
        dictDataTasks.removeValue(forKey: dataTaskId)
    }
    
    public class func cancelDataTasks(forOwner owner: AnyObject) {
        if Thread.isMainThread {
            mainThread_cancelDataTasks(forOwner: owner)
        }
        else {
            DispatchQueue.main.async {
                mainThread_cancelDataTasks(forOwner: owner)
            }
        }
    }
    
    private static func mainThread_cancelDataTasks(forOwner cancellingOwner: AnyObject) {
        var dictTemp: Dictionary<String, AnyObject> = [:]
        for (dataTaskId, owner) in dictDataTasks {
            if !(owner === cancellingOwner) {
                dictTemp[dataTaskId] = owner
            }
        }
        dictDataTasks = dictTemp
    }
    
    public class func cancelAllDataTasks() {
        if Thread.isMainThread {
            dictDataTasks = [:]
        }
        else {
            DispatchQueue.main.async {
                dictDataTasks = [:]
            }
        }
    }

}
