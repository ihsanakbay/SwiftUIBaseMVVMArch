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
    case head = "HEAD"
    case options = "OPTIONS"
}

/// Content types for network requests
enum ContentType: String {
    case json = "application/json"
    case formURLEncoded = "application/x-www-form-urlencoded"
    case multipartFormData = "multipart/form-data"
    case textPlain = "text/plain"
    case xml = "application/xml"
}

/// Protocol for defining API endpoints
protocol EndpointProtocol {
    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var queryItems: [URLQueryItem]? { get }
    var body: Data? { get }
    var contentType: ContentType? { get }
    var timeoutInterval: TimeInterval { get }
    var cachePolicy: URLRequest.CachePolicy { get }
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
    var contentType: ContentType?
    var timeoutInterval: TimeInterval
    var cachePolicy: URLRequest.CachePolicy
    
    // MARK: - Computed Properties
    
    var url: URL? {
        var components = URLComponents(string: baseURL)
        
        // Ensure path starts with a slash if it's not empty and doesn't already start with one
        if !path.isEmpty && !path.hasPrefix("/") {
            components?.path += "/" + path
        } else {
            components?.path += path
        }
        
        // Add query items if present
        if let queryItems = queryItems, !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        
        return components?.url
    }
    
    // MARK: - Initialization
    
    init(
        baseURL: String,
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        body: Data? = nil,
        contentType: ContentType? = .json,
        timeoutInterval: TimeInterval = 30.0,
        cachePolicy: URLRequest.CachePolicy = .useProtocolCachePolicy
    ) {
        self.baseURL = baseURL
        self.path = path
        self.method = method
        self.headers = headers
        self.queryItems = queryItems
        self.body = body
        self.contentType = contentType
        self.timeoutInterval = timeoutInterval
        self.cachePolicy = cachePolicy
    }
    
    // MARK: - Helper Methods
    
    /// Creates a new endpoint with the same properties but a different HTTP method
    /// - Parameter method: The new HTTP method
    /// - Returns: A new endpoint with the updated method
    func with(method: HTTPMethod) -> Endpoint {
        var endpoint = self
        endpoint.method = method
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but different headers
    /// - Parameter headers: The new headers
    /// - Returns: A new endpoint with the updated headers
    func with(headers: [String: String]?) -> Endpoint {
        var endpoint = self
        endpoint.headers = headers
        return endpoint
    }
    
    /// Adds headers to the existing headers
    /// - Parameter additionalHeaders: The headers to add
    /// - Returns: A new endpoint with the updated headers
    func addingHeaders(_ additionalHeaders: [String: String]) -> Endpoint {
        var endpoint = self
        var updatedHeaders = endpoint.headers ?? [:]
        
        for (key, value) in additionalHeaders {
            updatedHeaders[key] = value
        }
        
        endpoint.headers = updatedHeaders
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but a different body
    /// - Parameter body: The new body
    /// - Returns: A new endpoint with the updated body
    func with(body: Data?) -> Endpoint {
        var endpoint = self
        endpoint.body = body
        return endpoint
    }
    
    /// Creates a new endpoint with a JSON body
    /// - Parameter encodable: The encodable object to encode as JSON
    /// - Returns: A new endpoint with the updated body
    /// - Throws: An error if encoding fails
    func withJSONBody<T: Encodable>(_ encodable: T) throws -> Endpoint {
        let encoder = JSONEncoder()
        encoder.keyEncodingStrategy = .convertToSnakeCase
        encoder.dateEncodingStrategy = .iso8601
        
        let data = try encoder.encode(encodable)
        
        var endpoint = self
        endpoint.body = data
        endpoint.contentType = .json
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but different query items
    /// - Parameter queryItems: The new query items
    /// - Returns: A new endpoint with the updated query items
    func with(queryItems: [URLQueryItem]?) -> Endpoint {
        var endpoint = self
        endpoint.queryItems = queryItems
        return endpoint
    }
    
    /// Adds query items to the existing query items
    /// - Parameter additionalQueryItems: The query items to add
    /// - Returns: A new endpoint with the updated query items
    func addingQueryItems(_ additionalQueryItems: [URLQueryItem]) -> Endpoint {
        var endpoint = self
        var updatedQueryItems = endpoint.queryItems ?? []
        updatedQueryItems.append(contentsOf: additionalQueryItems)
        endpoint.queryItems = updatedQueryItems
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but a different content type
    /// - Parameter contentType: The new content type
    /// - Returns: A new endpoint with the updated content type
    func with(contentType: ContentType?) -> Endpoint {
        var endpoint = self
        endpoint.contentType = contentType
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but a different timeout interval
    /// - Parameter timeoutInterval: The new timeout interval
    /// - Returns: A new endpoint with the updated timeout interval
    func with(timeoutInterval: TimeInterval) -> Endpoint {
        var endpoint = self
        endpoint.timeoutInterval = timeoutInterval
        return endpoint
    }
    
    /// Creates a new endpoint with the same properties but a different cache policy
    /// - Parameter cachePolicy: The new cache policy
    /// - Returns: A new endpoint with the updated cache policy
    func with(cachePolicy: URLRequest.CachePolicy) -> Endpoint {
        var endpoint = self
        endpoint.cachePolicy = cachePolicy
        return endpoint
    }
}
