//
//  BaseViewModel.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation
import Combine

/// Base class for all view models in the application
class BaseViewModel: ObservableObject {
    
    // MARK: - Properties
    
    /// Cancellables for managing Combine subscriptions
    var cancellables = Set<AnyCancellable>()
    
    /// Published property to track loading state
    @Published var isLoading: Bool = false
    
    /// Published property to track error state
    @Published var error: Error?
    
    /// Published property to track whether there is an error
    @Published var hasError: Bool = false
    
    // MARK: - Initialization
    
    init() {
        setupErrorHandling()
    }
    
    // MARK: - Error Handling
    
    /// Sets up error handling for the view model
    private func setupErrorHandling() {
        $error
            .map { $0 != nil }
            .assign(to: &$hasError)
    }
    
    /// Handles an error that occurred during an operation
    /// - Parameter error: The error that occurred
    func handleError(_ error: Error) {
        self.error = error
        AppLogger.error("ViewModel Error: \(error.localizedDescription)", category: .ui)
    }
    
    // MARK: - Resource Management
    
    /// Called when the view model is no longer needed
    func cancelAll() {
        cancellables.forEach { $0.cancel() }
        cancellables.removeAll()
    }
    
    deinit {
        cancelAll()
        AppLogger.debug("ViewModel deinit: \(String(describing: self))", category: .ui)
    }
}
