//
//  GetUserDetailsUseCase.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// Protocol for the get user details use case
protocol GetUserDetailsUseCaseProtocol {
    func execute(userId: Int) -> AnyPublisher<User, Error>
}

/// Implementation of the get user details use case
class GetUserDetailsUseCase: GetUserDetailsUseCaseProtocol {
    
    // MARK: - Properties
    
    private let userRepository: UserRepositoryProtocol
    
    // MARK: - Initialization
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
    
    // MARK: - Use Case Methods
    
    /// Executes the use case to get details for a specific user
    /// - Parameter userId: The ID of the user
    /// - Returns: A publisher with the user details
    func execute(userId: Int) -> AnyPublisher<User, Error> {
        return userRepository.getUserDetails(id: userId)
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
