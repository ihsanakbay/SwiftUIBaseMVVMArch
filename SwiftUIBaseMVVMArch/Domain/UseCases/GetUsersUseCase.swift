//
//  GetUsersUseCase.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// Protocol for the get users use case
protocol GetUsersUseCaseProtocol {
    func execute() -> AnyPublisher<[User], Error>
}

/// Implementation of the get users use case
class GetUsersUseCase: GetUsersUseCaseProtocol {
    
    // MARK: - Properties
    
    private let userRepository: UserRepositoryProtocol
    
    // MARK: - Initialization
    
    init(userRepository: UserRepositoryProtocol = UserRepository()) {
        self.userRepository = userRepository
    }
    
    // MARK: - Use Case Methods
    
    /// Executes the use case to get a list of users
    /// - Returns: A publisher with the list of users
    func execute() -> AnyPublisher<[User], Error> {
        return userRepository.getUsers()
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
