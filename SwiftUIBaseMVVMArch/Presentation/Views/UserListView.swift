//
//  UserListView.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// View for displaying a list of users
struct UserListView: View, BaseViewProtocol {
    
    // MARK: - Properties
    
    @StateObject var viewModel: UserListViewModel
    
    // MARK: - Initialization
    
    init(viewModel: UserListViewModel = UserListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack {
                if viewModel.users.isEmpty && !viewModel.isLoading {
                    emptyStateView
                } else {
                    userListView
                }
            }
            .navigationTitle("Users")
            .onAppear {
                if viewModel.users.isEmpty {
                    viewModel.fetchUsers()
                }
            }
            .refreshable {
                viewModel.refreshUsers()
            }
        }
    }
    
    // MARK: - User List View
    
    private var userListView: some View {
        List {
            ForEach(viewModel.users) { user in
                NavigationLink(destination: UserDetailView(userId: user.id)) {
                    UserRow(user: user)
                }
            }
        }
        .listStyle(InsetGroupedListStyle())
    }
    
    // MARK: - Empty State View
    
    private var emptyStateView: some View {
        VStack(spacing: 20) {
            Image(systemName: "person.3")
                .font(.system(size: 60))
                .foregroundColor(.gray)
            
            Text("No Users Found")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Tap to refresh and try again")
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            Button(action: {
                viewModel.fetchUsers()
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

/// View for displaying a user row in the list
struct UserRow: View {
    let user: User
    
    var body: some View {
        HStack(spacing: 12) {
            // Avatar placeholder
            Circle()
                .fill(Color.gray.opacity(0.3))
                .frame(width: 50, height: 50)
                .overlay(
                    Text(user.name.prefix(1))
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 4) {
                Text(user.name)
                    .font(.headline)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.gray)
        }
        .padding(.vertical, 4)
    }
}

#Preview {
    NavigationView {
        UserListView()
    }
}
