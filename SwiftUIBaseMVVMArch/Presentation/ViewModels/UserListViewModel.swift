//
//  UserListViewModel.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// View model for the user list screen
class UserListViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    /// Published property for the list of users
    @Published var users: [User] = []
    
    /// Use case for getting users
    private let getUsersUseCase: GetUsersUseCaseProtocol
    
    // MARK: - Initialization
    
    init(getUsersUseCase: GetUsersUseCaseProtocol = GetUsersUseCase()) {
        self.getUsersUseCase = getUsersUseCase
        super.init()
    }
    
    // MARK: - View Model Methods
    
    /// Fetches the list of users
    func fetchUsers() {
        AppLogger.info("Fetching users", category: .network)
        isLoading = true
        
        getUsersUseCase.execute()
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    AppLogger.info("Successfully fetched users", category: .network)
                case .failure(let error):
                    self.handleError(error)
                }
            } receiveValue: { [weak self] users in
                self?.users = users
            }
            .store(in: &cancellables)
    }
    
    /// Refreshes the list of users
    func refreshUsers() {
        users = []
        fetchUsers()
    }
}
