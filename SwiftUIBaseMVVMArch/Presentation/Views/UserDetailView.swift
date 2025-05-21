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
    @Environment(\.colorScheme) var colorScheme
    
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
                        actionButtons(user: user)
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
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Menu {
                        Button(action: {
                            // Edit action
                        }) {
                            Label("Edit User", systemImage: "pencil")
                        }
                        
                        Button(action: {
                            // Delete action
                        }) {
                            Label("Delete User", systemImage: "trash")
                                .foregroundColor(.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        }
    }
    
    // MARK: - User Profile View
    
    private func userProfileView(user: User) -> some View {
        CardView(backgroundColor: .primaryColor.opacity(0.1), cornerRadius: 16, shadowRadius: 4) {
            VStack(spacing: 16) {
                // Avatar placeholder with gradient background
                ZStack {
                    Circle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [.primaryColor, .accentColor]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 100, height: 100)
                    
                    Text(user.name.prefix(1))
                        .font(.system(size: 40))
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                }
                .padding(4)
                .background(Circle().fill(Color.white))
                .shadow(color: .primaryColor.opacity(0.3), radius: 5, x: 0, y: 2)
                
                Text(user.name)
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(user.email)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .padding(.bottom, 8)
                
                // User stats
                HStack(spacing: 30) {
                    statView(value: "\(user.id)", title: "ID")
                    statView(value: "4.8", title: "Rating")
                    statView(value: "42", title: "Posts")
                }
                .padding(.top, 8)
            }
            .padding(.vertical)
        }
    }
    
    // MARK: - Stat View
    
    private func statView(value: String, title: String) -> some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
            
            Text(title)
                .font(.caption)
                .foregroundColor(.secondary)
        }
    }
    
    // MARK: - User Info View
    
    private func userInfoView(user: User) -> some View {
        CardView(cornerRadius: 16, shadowRadius: 4) {
            VStack(alignment: .leading, spacing: 16) {
                Text("User Information")
                    .font(.headline)
                    .fontWeight(.bold)
                    .padding(.bottom, 5)
                
                Divider()
                
                infoRow(icon: "person.fill", title: "Name", value: user.name)
                infoRow(icon: "envelope.fill", title: "Email", value: user.email)
                infoRow(icon: "number", title: "ID", value: "\(user.id)")
                
                if let avatarURL = user.avatarURL {
                    infoRow(icon: "photo", title: "Avatar", value: avatarURL)
                }
            }
        }
    }
    
    // MARK: - Action Buttons
    
    private func actionButtons(user: User) -> some View {
        HStack(spacing: 16) {
            AppButton(
                title: "Message",
                icon: "message.fill",
                style: .primary,
                action: {
                    // Message action
                }
            )
            .buttonSize(.medium)
            .fullWidth()
            
            AppButton(
                title: "Call",
                icon: "phone.fill",
                style: .outline,
                action: {
                    // Call action
                }
            )
            .buttonSize(.medium)
            .fullWidth()
        }
        .padding(.top, 8)
    }
    
    // MARK: - Info Row
    
    private func infoRow(icon: String, title: String, value: String) -> some View {
        HStack(alignment: .center, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundColor(.primaryColor)
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(value)
                    .font(.body)
            }
            
            Spacer()
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
            
            AppButton(
                title: "Refresh",
                icon: "arrow.clockwise",
                style: .primary,
                action: {
                    viewModel.fetchUserDetails()
                }
            )
            .buttonSize(.medium)
            .cornerRadius(10)
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
