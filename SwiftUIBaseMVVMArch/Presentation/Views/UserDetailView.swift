//
//  UserDetailView.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// View for displaying user details
struct UserDetailView: View, BaseViewProtocol {
    // MARK: - Properties
    
    @StateObject var viewModel: UserDetailViewModel
    
    // MARK: - Initialization
    
    init(userId: Int) {
        _viewModel = StateObject(wrappedValue: UserDetailViewModel(userId: userId))
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            ScrollView {
                VStack(spacing: 20) {
                    if let user = viewModel.user {
                        userProfileView(user: user)
                        userInfoView(user: user)
                    } else if !viewModel.isLoading {
                        emptyStateView
                    }
                }
                .padding()
            }
            .navigationTitle("User Details")
            .onAppear {
                if viewModel.user == nil {
                    viewModel.fetchUserDetails()
                }
            }
            .refreshable {
                viewModel.refreshUserDetails()
            }
        }
    }
    
    // MARK: - User Profile View
    
    private func userProfileView(user: User) -> some View {
        VStack(spacing: 16) {
            // Avatar placeholder
            Circle()
                .fill(Color.blue.opacity(0.2))
                .frame(width: 100, height: 100)
                .overlay(
                    Text(user.name.prefix(1))
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.blue)
                )
            
            Text(user.name)
                .font(.title)
                .fontWeight(.bold)
            
            Text(user.email)
                .font(.subheadline)
                .foregroundColor(.secondary)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    // MARK: - User Info View
    
    private func userInfoView(user: User) -> some View {
        VStack(alignment: .leading, spacing: 20) {
            Text("User Information")
                .font(.headline)
                .padding(.bottom, 5)
            
            infoRow(title: "ID", value: "\(user.id)")
            infoRow(title: "Name", value: user.name)
            infoRow(title: "Email", value: user.email)
            
            if let avatarURL = user.avatarURL {
                infoRow(title: "Avatar URL", value: avatarURL)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: Color.black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
    
    // MARK: - Info Row
    
    private func infoRow(title: String, value: String) -> some View {
        HStack(alignment: .top) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.semibold)
                .frame(width: 80, alignment: .leading)
            
            Text(value)
                .font(.subheadline)
                .foregroundColor(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(.vertical, 4)
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.fill.questionmark")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("User Not Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap to refresh and try again")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                viewModel.fetchUserDetails()
            }) {
                Text("Refresh")
                    .fontWeight(.semibold)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    NavigationView {
        UserDetailView(userId: 1)
    }
}
