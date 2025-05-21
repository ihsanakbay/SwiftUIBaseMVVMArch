//
//  BaseView.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// Base protocol for all views in the application
protocol BaseViewProtocol {
    associatedtype ViewModelType: BaseViewModel
    var viewModel: ViewModelType { get }
}

/// Base view structure that all views should inherit from
struct BaseView<Content: View, ViewModel: BaseViewModel>: View {
    
    // MARK: - Properties
    
    @ObservedObject var viewModel: ViewModel
    let content: Content
    
    // MARK: - Initialization
    
    init(viewModel: ViewModel, @ViewBuilder content: () -> Content) {
        self.viewModel = viewModel
        self.content = content()
        
        // Log view initialization
        AppLogger.debug("View initialized: \(String(describing: Self.self))", category: .ui)
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack {
            // Main content
            content
                .disabled(viewModel.isLoading)
            
            // Loading overlay
            if viewModel.isLoading {
                loadingView
            }
            
            // Error handling
            if viewModel.hasError {
                errorView
            }
        }
    }
    
    // MARK: - Loading View
    
    private var loadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
                .scaleEffect(1.5)
            
            Text("Loading...")
                .padding(.top)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
    
    // MARK: - Error View
    
    private var errorView: some View {
        VStack {
            Image(systemName: "exclamationmark.triangle.fill")
                .font(.largeTitle)
                .foregroundColor(.red)
            
            Text(viewModel.error?.localizedDescription ?? "An unknown error occurred")
                .multilineTextAlignment(.center)
                .padding()
            
            Button("Dismiss") {
                viewModel.error = nil
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding()
    }
}
