//
//  Endpoint.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

/// HTTP methods for network requests
enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case delete = "DELETE"
    case patch = "PATCH"
}

/// Protocol for defining API endpoints
protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var url: URL? { get }
}

/// Implementation of an API endpoint
struct Endpoint: EndpointProtocol {
    
    // MARK: - Properties
    
    var baseURL: String
    var path: String
    var method: HTTPMethod
    var headers: [String: String]?
    var queryItems: [URLQueryItem]?
    var body: Data?
    
    // MARK: - Computed Properties
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        components?.path = path
        components?.queryItems = queryItems
        
        return components?.url
    }
    
    // MARK: - Initialization
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
    }
    
    // MARK: - Helper Methods
    
    /// Creates a new endpoint with the same properties but a different HTTP method
    /// - Parameter method: The new HTTP method
    /// - Returns: A new endpoint with the updated method
    func with(method: HTTPMethod) -> Endpoint {
        return Endpoint(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            queryItems: queryItems,
            body: body
        )
    }
    
    /// Creates a new endpoint with the same properties but different headers
    /// - Parameter headers: The new headers
    /// - Returns: A new endpoint with the updated headers
    func with(headers: [String: String]?) -> Endpoint {
        return Endpoint(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            queryItems: queryItems,
            body: body
        )
    }
    
    /// Creates a new endpoint with the same properties but a different body
    /// - Parameter body: The new body
    /// - Returns: A new endpoint with the updated body
    func with(body: Data?) -> Endpoint {
        return Endpoint(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            queryItems: queryItems,
            body: body
        )
    }
    
    /// Creates a new endpoint with the same properties but different query items
    /// - Parameter queryItems: The new query items
    /// - Returns: A new endpoint with the updated query items
    func with(queryItems: [URLQueryItem]?) -> Endpoint {
        return Endpoint(
            baseURL: baseURL,
            path: path,
            method: method,
            headers: headers,
            queryItems: queryItems,
            body: body
        )
    }
}
