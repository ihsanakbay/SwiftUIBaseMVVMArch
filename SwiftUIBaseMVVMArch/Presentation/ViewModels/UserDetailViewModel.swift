//
//  UserDetailViewModel.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// View model for the user detail screen
class UserDetailViewModel: BaseViewModel {
    
    // MARK: - Properties
    
    /// Published property for the user details
    @Published var user: User?
    
    /// The ID of the user
    private let userId: Int
    
    /// Use case for getting user details
    private let getUserDetailsUseCase: GetUserDetailsUseCaseProtocol
    
    // MARK: - Initialization
    
    init(userId: Int, getUserDetailsUseCase: GetUserDetailsUseCaseProtocol = GetUserDetailsUseCase()) {
        self.userId = userId
        self.getUserDetailsUseCase = getUserDetailsUseCase
        super.init()
    }
    
    // MARK: - View Model Methods
    
    /// Fetches the details for the user
    func fetchUserDetails() {
        AppLogger.info("Fetching user details for user \(userId)", category: .network)
        isLoading = true
        
        getUserDetailsUseCase.execute(userId: userId)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .finished:
                    AppLogger.info("Successfully fetched user details", category: .network)
                case .failure(let error):
                    self.handleError(error)
                }
            } receiveValue: { [weak self] user in
                self?.user = user
            }
            .store(in: &cancellables)
    }
    
    /// Refreshes the user details
    func refreshUserDetails() {
        user = nil
        fetchUserDetails()
    }
}
