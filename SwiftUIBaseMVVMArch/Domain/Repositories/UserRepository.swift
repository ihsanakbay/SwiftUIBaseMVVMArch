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
}

/// Implementation of user repository
class UserRepository: UserRepositoryProtocol {
    
    // MARK: - Properties
    
    private let networkService: NetworkServiceProtocol
    
    // MARK: - Initialization
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    // MARK: - Repository Methods
    
    /// Gets a list of users
    /// - Returns: A publisher with the list of users
    func getUsers() -> AnyPublisher<[User], Error> {
        let endpoint = Endpoint(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/users",
            method: .get,
            headers: ["Content-Type": "application/json"]
        )
        
        return networkService.request(endpoint: endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    /// Gets details for a specific user
    /// - Parameter id: The ID of the user
    /// - Returns: A publisher with the user details
    func getUserDetails(id: Int) -> AnyPublisher<User, Error> {
        let endpoint = Endpoint(
            baseURL: "https://jsonplaceholder.typicode.com",
            path: "/users/\(id)",
            method: .get,
            headers: ["Content-Type": "application/json"]
        )
        
        return networkService.request(endpoint: endpoint)
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}
