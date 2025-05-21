//
//  APIConfig.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

/// Environment for API configuration
enum APIEnvironment: String, CaseIterable {
    case development
    case staging
    case production
    
    var baseURL: String {
        switch self {
        case .development:
            return "https://dev-api.example.com"
        case .staging:
            return "https://staging-api.example.com"
        case .production:
            return "https://api.example.com"
        }
    }
}

/// Configuration for API endpoints
struct APIConfig {
    // MARK: - Properties
    
    /// The current environment
    static var environment: APIEnvironment = .development
    
    /// The base URL for the API
    static var baseURL: String {
        return environment.baseURL
    }
    
    /// The base URL for the mock API (for testing)
    static let mockBaseURL = "https://jsonplaceholder.typicode.com"
    
    /// Default timeout interval for requests
    static let defaultTimeoutInterval: TimeInterval = 30.0
    
    /// Default headers for all requests
    static var defaultHeaders: [String: String] {
        return [
            "Content-Type": "application/json",
            "Accept": "application/json",
            "App-Version": Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
        ]
    }
    
    // MARK: - API Endpoints
    
    struct Endpoints {
        // User endpoints
        static let users = "/users"
        static func user(id: Int) -> String { return "/users/\(id)" }
        
        // Add more endpoints as needed
        static let posts = "/posts"
        static func post(id: Int) -> String { return "/posts/\(id)" }
        
        static let comments = "/comments"
        static func comment(id: Int) -> String { return "/comments/\(id)" }
    }
    
    // MARK: - Helper Methods
    
    /// Sets the environment for the API
    /// - Parameter environment: The environment to set
    static func setEnvironment(_ environment: APIEnvironment) {
        self.environment = environment
        AppLogger.info("API environment set to \(environment.rawValue)", category: .network)
    }
    
    /// Creates an endpoint for the API
    /// - Parameters:
    ///   - path: The path for the endpoint
    ///   - method: The HTTP method for the endpoint
    ///   - headers: Additional headers for the endpoint
    ///   - queryItems: Query items for the endpoint
    ///   - useMock: Whether to use the mock API
    /// - Returns: An endpoint for the API
    static func endpoint(
        path: String,
        method: HTTPMethod = .get,
        headers: [String: String]? = nil,
        queryItems: [URLQueryItem]? = nil,
        useMock: Bool = false
    ) -> Endpoint {
        var allHeaders = defaultHeaders
        
        if let headers = headers {
            for (key, value) in headers {
                allHeaders[key] = value
            }
        }
        
        return Endpoint(
            baseURL: useMock ? mockBaseURL : baseURL,
            path: path,
            method: method,
            headers: allHeaders,
            queryItems: queryItems,
            timeoutInterval: defaultTimeoutInterval
        )
    }
}
