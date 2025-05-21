//
//  NetworkService.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// Defines the errors that can occur during network operations
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case httpError(statusCode: Int)
    case decodingError(Error)
    case unknown(Error)
    
    var localizedDescription: String {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .invalidResponse:
            return "Invalid response from server"
        case .httpError(let statusCode):
            return "HTTP error: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

/// Protocol for network service
protocol NetworkServiceProtocol {
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError>
}

/// Implementation of the network service
class NetworkService: NetworkServiceProtocol {
    
    // MARK: - Properties
    
    private let session: URLSession
    
    // MARK: - Initialization
    
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    // MARK: - Network Request
    
    /// Performs a network request and returns a publisher with the decoded response
    /// - Parameter endpoint: The endpoint to request
    /// - Returns: A publisher with the decoded response
    func request<T: Decodable>(endpoint: Endpoint) -> AnyPublisher<T, NetworkError> {
        guard let url = endpoint.url else {
            return Fail(error: NetworkError.invalidURL).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        AppLogger.info("Request: \(request.url?.absoluteString ?? "Unknown URL")", category: .network)
        
        return session.dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.invalidResponse
                }
                
                AppLogger.info("Response: \(httpResponse.statusCode)", category: .network)
                
                if !(200...299).contains(httpResponse.statusCode) {
                    throw NetworkError.httpError(statusCode: httpResponse.statusCode)
                }
                
                return data
            }
            .decode(type: T.self, decoder: JSONDecoder())
            .mapError { error in
                if let networkError = error as? NetworkError {
                    return networkError
                } else if let decodingError = error as? DecodingError {
                    AppLogger.error("Decoding error: \(decodingError.localizedDescription)", category: .network)
                    return NetworkError.decodingError(decodingError)
                } else {
                    AppLogger.error("Unknown network error: \(error.localizedDescription)", category: .network)
                    return NetworkError.unknown(error)
                }
            }
            .eraseToAnyPublisher()
    }
}
