//
//  Networking.swift
//  
//
//  Created by Stars Momodu on 13/06/2022.
//

import Foundation
import GoDFoundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public enum NetworkingErrors: Error {
    case badRequestURL
    case badRequestJSON
    case requestFailed(Error)
    case unknownRequestFailure
    case failedToDecodeJSON
}

public final class NetworkingManager {
    private enum HTTPMethods: String {
        case GET, POST
    }
    
    public static func get<T: Decodable>(urlString: String,
                                  jsonBody body: Encodable? = nil,
                                  timeout: TimeInterval = 10) async throws -> T {
        return try await request(method: .GET, urlString: urlString, jsonBody: body, timeout: timeout)
    }

    public static func get(urlString: String,
                           jsonBody body: Encodable? = nil,
                           timeout: TimeInterval = 10) async throws -> GoDData {
        return try await request(method: .GET, urlString: urlString, jsonBody: body, timeout: timeout)
    }

    @discardableResult
    public static func post<T: Decodable>(urlString: String,
                                          jsonBody body: Encodable? = nil,
                                          timeout: TimeInterval = 10) async throws -> T {
        return try await request(method: .POST, urlString: urlString, jsonBody: body, timeout: timeout)
    }
    
    @discardableResult
    public static func post(urlString: String,
                            jsonBody body: Encodable? = nil,
                            timeout: TimeInterval = 10) async throws -> GoDData {
        return try await request(method: .POST, urlString: urlString, jsonBody: body, timeout: timeout)
    }

    private static func request<T: Decodable>(method: HTTPMethods,
                                              urlString: String,
                                              jsonBody body: Encodable? = nil,
                                              timeout: TimeInterval = 10) async throws -> T {
        
        let data: GoDData = try await request(method: method, urlString: urlString, jsonBody: body)
        guard let result = T.decodeJSON(from: data) else {
            throw NetworkingErrors.failedToDecodeJSON
        }
        return result
    }
    
    private static func request(method: HTTPMethods,
                                urlString: String,
                                jsonBody body: Encodable? = nil,
                                timeout: TimeInterval = 10) async throws -> GoDData {
        
        guard let url = URL(string: urlString) else {
            throw NetworkingErrors.badRequestURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        
        if let json = body {
            guard let jsonData = json.encodeJSON()?.data else {
                throw NetworkingErrors.badRequestJSON
            }
            request.httpBody = jsonData
        }
        
        request.timeoutInterval = timeout
        
        let (data, _) = try await URLSession.shared.data(for: request)
        return GoDData(data: data)
    }
}
