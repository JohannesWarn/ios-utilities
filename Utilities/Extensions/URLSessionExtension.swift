//
//  URLSessionExtension.swift
//  Johannes Wärn
//
//  Created by Johannes Wärn on 2023-10-11.
//

import Foundation

extension URLSession {
    
    enum JSONError: Error {
        case failedToDecode(data: Data, response: URLResponse)
    }
    
    func json(for request: URLRequest) async throws -> (Any, URLResponse)
    {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        // print(String(data: data, encoding: .utf8))
        
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: data)
            return (jsonObject, response)
        } catch {
            throw JSONError.failedToDecode(data: data, response: response)
        }
    }
    
    func json<T: Decodable>(for request: URLRequest, responseFormat: T.Type, printDebugInfo: Bool = false) async throws -> (T, URLResponse)
    {
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if printDebugInfo {
            if let string = String(data: data, encoding: .utf8) {
                print(string)
            } else {
                print(data)
            }
        }
        
        let decoder = JSONDecoder()
        do {
            let jsonObject = try decoder.decode(T.self, from: data)
            return (jsonObject, response)
        } catch {
            throw JSONError.failedToDecode(data: data, response: response)
        }
    }
    
}
