//
//  APIClient.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Combine
import Foundation

/// Defines the errors that can occur during API operations
enum APIError: Error, LocalizedError {
    case invalidURL
    case requestFailed(Error)
    case invalidResponse
    case httpError(statusCode: Int, data: Data?)
    case decodingError(Error)
    case encodingError(Error)
    case unauthorized
    case noInternetConnection
    case timeout
    case serverError
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The URL is invalid"
        case .requestFailed(let error):
            return "Request failed: \(error.localizedDescription)"
        case .invalidResponse:
            return "Invalid response from the server"
        case .httpError(let statusCode, _):
            return "HTTP error with status code: \(statusCode)"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .encodingError(let error):
            return "Failed to encode request: \(error.localizedDescription)"
        case .unauthorized:
            return "You are not authorized to perform this action"
        case .noInternetConnection:
            return "No internet connection"
        case .timeout:
            return "Request timed out"
        case .serverError:
            return "Server error occurred"
        case .unknown(let error):
            return "Unknown error: \(error.localizedDescription)"
        }
    }
}

/// Protocol for API client
protocol APIClientProtocol {
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError>
    func requestWithProgress<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<(T?, Double), APIError>
    func upload<T: Decodable>(endpoint: Endpoint, data: Data, mimeType: String) -> AnyPublisher<T, APIError>
    func download(from url: URL, to destinationURL: URL) -> AnyPublisher<URL, APIError>
}

/// Implementation of API client
final class APIClient: APIClientProtocol {
    // MARK: - Properties
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    private let retryCount: Int
    private let retryDelay: TimeInterval
    
    // MARK: - Initialization
    
    init(
        session: URLSession = .shared,
        decoder: JSONDecoder = JSONDecoder(),
        encoder: JSONEncoder = JSONEncoder(),
        retryCount: Int = 3,
        retryDelay: TimeInterval = 1.0
    ) {
        self.session = session
        self.decoder = decoder
        self.encoder = encoder
        self.retryCount = retryCount
        self.retryDelay = retryDelay
        
        // Configure decoder
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
        
        // Configure encoder
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - API Methods
    
    /// Performs a network request and returns a publisher with the decoded response
    /// - Parameter endpoint: The endpoint to request
    /// - Returns: A publisher with the decoded response
    func request<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<T, APIError> {
        guard let request = createRequest(from: endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        AppLogger.info("Request: \(request.url?.absoluteString ?? "Unknown URL")", category: .network)
        
        return session.dataTaskPublisher(for: request)
            .retry(retryCount)
            .tryMap { [weak self] data, response -> Data in
                guard let self = self else { throw APIError.unknown(NSError(domain: "APIClient", code: -1, userInfo: nil)) }
                return try self.validateResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { [weak self] error -> APIError in
                guard let self = self else { return APIError.unknown(error) }
                return self.handleError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Performs a network request with progress tracking
    /// - Parameter endpoint: The endpoint to request
    /// - Returns: A publisher with the decoded response and progress updates
    func requestWithProgress<T: Decodable>(_ endpoint: Endpoint) -> AnyPublisher<(T?, Double), APIError> {
        guard let request = createRequest(from: endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        let progressSubject = PassthroughSubject<(T?, Double), APIError>()
        
        let task = session.dataTask(with: request) { [weak self] data, response, error in
            guard let self = self else {
                progressSubject.send(completion: .failure(APIError.unknown(NSError(domain: "APIClient", code: -1, userInfo: nil))))
                return
            }
            
            if let error = error {
                progressSubject.send(completion: .failure(self.handleError(error)))
                return
            }
            
            do {
                guard let response else { return }
                let validatedData = try self.validateResponse(data: data ?? Data(), response: response)
                let decodedResponse = try self.decoder.decode(T.self, from: validatedData)
                progressSubject.send((decodedResponse, 1.0))
                progressSubject.send(completion: .finished)
            } catch {
                progressSubject.send(completion: .failure(self.handleError(error)))
            }
        }
        
        task.resume()
        
        // Send initial progress
        progressSubject.send((nil, 0.0))
        
        return progressSubject.eraseToAnyPublisher()
    }
    
    /// Uploads data to an endpoint
    /// - Parameters:
    ///   - endpoint: The endpoint to upload to
    ///   - data: The data to upload
    ///   - mimeType: The MIME type of the data
    /// - Returns: A publisher with the decoded response
    func upload<T: Decodable>(endpoint: Endpoint, data: Data, mimeType: String) -> AnyPublisher<T, APIError> {
        guard var request = createRequest(from: endpoint) else {
            return Fail(error: APIError.invalidURL).eraseToAnyPublisher()
        }
        
        // Set up the request for upload
        request.httpMethod = "POST"
        request.setValue(mimeType, forHTTPHeaderField: "Content-Type")
        request.httpBody = data
        
        AppLogger.info("Upload request: \(request.url?.absoluteString ?? "Unknown URL")", category: .network)
        
        return session.dataTaskPublisher(for: request)
            .retry(retryCount)
            .tryMap { [weak self] data, response -> Data in
                guard let self = self else { throw APIError.unknown(NSError(domain: "APIClient", code: -1, userInfo: nil)) }
                return try self.validateResponse(data: data, response: response)
            }
            .decode(type: T.self, decoder: decoder)
            .mapError { [weak self] error -> APIError in
                guard let self = self else { return APIError.unknown(error) }
                return self.handleError(error)
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    /// Downloads a file from a URL
    /// - Parameters:
    ///   - url: The URL to download from
    ///   - destinationURL: The URL to save the downloaded file to
    /// - Returns: A publisher with the URL of the downloaded file
    func download(from url: URL, to destinationURL: URL) -> AnyPublisher<URL, APIError> {
        let downloadSubject = PassthroughSubject<URL, APIError>()
        
        let downloadTask = session.downloadTask(with: url) { tempURL, response, error in
            if let error = error {
                downloadSubject.send(completion: .failure(APIError.requestFailed(error)))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                downloadSubject.send(completion: .failure(APIError.invalidResponse))
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                downloadSubject.send(completion: .failure(APIError.httpError(statusCode: httpResponse.statusCode, data: nil)))
                return
            }
            
            guard let tempURL = tempURL else {
                downloadSubject.send(completion: .failure(APIError.invalidResponse))
                return
            }
            
            do {
                // Create the directory if it doesn't exist
                try FileManager.default.createDirectory(
                    at: destinationURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                
                // Remove the file if it already exists
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                
                // Move the temporary file to the destination
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                
                DispatchQueue.main.async {
                    downloadSubject.send(destinationURL)
                    downloadSubject.send(completion: .finished)
                }
            } catch {
                downloadSubject.send(completion: .failure(APIError.unknown(error)))
            }
        }
        
        downloadTask.resume()
        
        return downloadSubject.eraseToAnyPublisher()
    }
    
    // MARK: - Helper Methods
    
    /// Creates a URLRequest from an endpoint
    /// - Parameter endpoint: The endpoint to create a request from
    /// - Returns: A URLRequest
    private func createRequest(from endpoint: Endpoint) -> URLRequest? {
        guard let url = endpoint.url else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.method.rawValue
        
        // Add headers
        if let headers = endpoint.headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField: key)
            }
        }
        
        // Add default headers if not present
        if request.value(forHTTPHeaderField: "Content-Type") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if request.value(forHTTPHeaderField: "Accept") == nil {
            request.setValue("application/json", forHTTPHeaderField: "Accept")
        }
        
        // Add body
        if let body = endpoint.body {
            request.httpBody = body
        }
        
        return request
    }
    
    /// Validates the response from a network request
    /// - Parameters:
    ///   - data: The response data
    ///   - response: The response
    /// - Returns: The validated data
    /// - Throws: An APIError if the response is invalid
    private func validateResponse(data: Data, response: URLResponse) throws -> Data {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw APIError.invalidResponse
        }
        
        AppLogger.info("Response: \(httpResponse.statusCode)", category: .network)
        
        switch httpResponse.statusCode {
        case 200...299:
            return data
        case 401:
            throw APIError.unauthorized
        case 500...599:
            throw APIError.serverError
        default:
            throw APIError.httpError(statusCode: httpResponse.statusCode, data: data)
        }
    }
    
    /// Handles errors from network requests
    /// - Parameter error: The error to handle
    /// - Returns: An APIError
    private func handleError(_ error: Error) -> APIError {
        if let apiError = error as? APIError {
            return apiError
        }
        
        if let urlError = error as? URLError {
            switch urlError.code {
            case .notConnectedToInternet:
                return .noInternetConnection
            case .timedOut:
                return .timeout
            default:
                return .requestFailed(urlError)
            }
        }
        
        if let decodingError = error as? DecodingError {
            AppLogger.error("Decoding error: \(decodingError.localizedDescription)", category: .network)
            return .decodingError(decodingError)
        }
        
        AppLogger.error("Unknown network error: \(error.localizedDescription)", category: .network)
        return .unknown(error)
    }
}
