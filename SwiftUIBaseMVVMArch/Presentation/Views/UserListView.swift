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
    @State private var searchText = ""
    @State private var isSearching = false
    
    // MARK: - Initialization
    
    init(viewModel: UserListViewModel = UserListViewModel()) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    // MARK: - Body
    
    var body: some View {
        BaseView(viewModel: viewModel) {
            VStack(spacing: 0) {
                searchBar
                
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        // Add user action would go here
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
        }
    }
    
    // MARK: - Search Bar
    
    private var searchBar: some View {
        HStack {
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.gray)
                
                TextField("Search users", text: $searchText, onEditingChanged: { isEditing in
                    withAnimation {
                        isSearching = isEditing
                    }
                })
                .foregroundColor(.primary)
                
                if !searchText.isEmpty {
                    Button(action: {
                        searchText = ""
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                    }
                }
            }
            .padding(8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            if isSearching {
                Button("Cancel") {
                    searchText = ""
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    withAnimation {
                        isSearching = false
                    }
                }
                .transition(.move(edge: .trailing))
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 4)
    }
    
    // MARK: - User List View
    
    private var userListView: some View {
        ScrollView {
            LazyVStack(spacing: 12) {
                ForEach(filteredUsers) { user in
                    NavigationLink(destination: UserDetailView(userId: user.id)) {
                        UserRow(user: user)
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
    }
    
    // MARK: - Filtered Users
    
    private var filteredUsers: [User] {
        if searchText.isEmpty {
            return viewModel.users
        } else {
            return viewModel.users.filter { user in
                user.name.lowercased().contains(searchText.lowercased()) ||
                user.email.lowercased().contains(searchText.lowercased())
            }
        }
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
            
            AppButton(
                title: "Refresh",
                icon: "arrow.clockwise",
                style: .primary,
                action: {
                    viewModel.fetchUsers()
                }
            )
            .buttonSize(.medium)
            .cornerRadius(10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

/// View for displaying a user row in the list
struct UserRow: View {
    let user: User
    
    var body: some View {
        CardView(cornerRadius: 12, shadowRadius: 3, padding: 12) {
            HStack(spacing: 12) {
                // Avatar placeholder
                Circle()
                    .fill(Color.primaryColor.opacity(0.15))
                    .frame(width: 50, height: 50)
                    .overlay(
                        Text(user.name.prefix(1))
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(.primaryColor)
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
                    .font(.system(size: 14, weight: .semibold))
            }
        }
    }
}

#Preview {
    NavigationView {
        UserListView()
    }
}
