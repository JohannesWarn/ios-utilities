//
//  URLRequestExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-11.
//

import Foundation

extension URLRequest {
    
    enum HTTPMethod: String {
        case get = "GET"
        case head = "HEAD"
        case post = "POST"
        case put = "PUT"
        case delete = "DELETE"
        case connect = "CONNECT"
        case options = "OPTIONS"
        case trace = "TRACE"
        case patch = "PATCH"
    }
    
    mutating func setMethod(_ method: HTTPMethod) {
        httpMethod = method.rawValue
    }
    
    var jsonHTTPBody: [String: Any]? {
        set {
            guard let newValue else {
                httpBody = nil
                return
            }
            
            setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            httpBody = try? JSONSerialization.data(withJSONObject: newValue, options: [])
        }
        get {
            fatalError("get jsonHTTPBody has not been implemented")
        }
    }
    
}
