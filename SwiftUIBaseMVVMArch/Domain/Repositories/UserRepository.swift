//
//  UserRepository.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// Protocol for user repository
protocol UserRepositoryProtocol {
    func getUsers() -> AnyPublisher<[User], Error>
    func getUserDetails(id: Int) -> AnyPublisher<User, Error>
    func searchUsers(query: String) -> AnyPublisher<[User], Error>
    func createUser(user: User) -> AnyPublisher<User, Error>
    func updateUser(id: Int, user: User) -> AnyPublisher<User, Error>
    func deleteUser(id: Int) -> AnyPublisher<Void, Error>
}

/// Implementation of user repository
class UserRepository: UserRepositoryProtocol {
    
    // MARK: - Properties
    
    private let apiClient: APIClientProtocol
    private let useMockAPI: Bool
    
    // MARK: - Initialization
    
    init(apiClient: APIClientProtocol = APIClient(), useMockAPI: Bool = true) {
        self.apiClient = apiClient
        self.useMockAPI = useMockAPI
    }
    
    // MARK: - Repository Methods
    
    /// Gets a list of users
    /// - Returns: A publisher with the list of users
    func getUsers() -> AnyPublisher<[User], Error> {
        let endpoint = APIConfig.endpoint(
            path: APIConfig.Endpoints.users,
            useMock: useMockAPI
        )
        
        return apiClient.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    /// Gets details for a specific user
    /// - Parameter id: The ID of the user
    /// - Returns: A publisher with the user details
    func getUserDetails(id: Int) -> AnyPublisher<User, Error> {
        let endpoint = APIConfig.endpoint(
            path: APIConfig.Endpoints.user(id: id),
            useMock: useMockAPI
        )
        
        return apiClient.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    /// Searches for users with a query
    /// - Parameter query: The search query
    /// - Returns: A publisher with the list of users matching the query
    func searchUsers(query: String) -> AnyPublisher<[User], Error> {
        let endpoint = APIConfig.endpoint(
            path: APIConfig.Endpoints.users,
            queryItems: [URLQueryItem(name: "q", value: query)],
            useMock: useMockAPI
        )
        
        return apiClient.request(endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    /// Creates a new user
    /// - Parameter user: The user to create
    /// - Returns: A publisher with the created user
    func createUser(user: User) -> AnyPublisher<User, Error> {
        do {
            var endpoint = APIConfig.endpoint(
                path: APIConfig.Endpoints.users,
                method: .post,
                useMock: useMockAPI
            )
            
            endpoint = try endpoint.withJSONBody(user)
            
            return apiClient.request(endpoint)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Updates an existing user
    /// - Parameters:
    ///   - id: The ID of the user to update
    ///   - user: The updated user data
    /// - Returns: A publisher with the updated user
    func updateUser(id: Int, user: User) -> AnyPublisher<User, Error> {
        do {
            var endpoint = APIConfig.endpoint(
                path: APIConfig.Endpoints.user(id: id),
                method: .put,
                useMock: useMockAPI
            )
            
            endpoint = try endpoint.withJSONBody(user)
            
            return apiClient.request(endpoint)
                .mapError { $0 as Error }
                .eraseToAnyPublisher()
        } catch {
            return Fail(error: error).eraseToAnyPublisher()
        }
    }
    
    /// Deletes a user
    /// - Parameter id: The ID of the user to delete
    /// - Returns: A publisher with a void result
    func deleteUser(id: Int) -> AnyPublisher<Void, Error> {
        let endpoint = APIConfig.endpoint(
            path: APIConfig.Endpoints.user(id: id),
            method: .delete,
            useMock: useMockAPI
        )
        
        return apiClient.request(endpoint)
            .map { (_: EmptyResponse) -> Void in return () }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

/// Empty response for endpoints that return no data
struct EmptyResponse: Decodable {}
