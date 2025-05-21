//
//  SwiftUIBaseMVVMArchApp.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

@main
struct SwiftUIBaseMVVMArchApp: App {
    // MARK: - Properties
    
    /// The navigation router for the app
    @StateObject private var router = NavigationRouter<AppRoute>()
    
    /// The selected tab
    @State private var selectedTab: Int = 0
    
    // MARK: - Body
    
    var body: some Scene {
        WindowGroup {
            mainView
                .onAppear {
                    setupAppearance()
                    AppLogger.info("App launched", category: .general)
                }
        }
    }
    
    // MARK: - Main View
    
    private var mainView: some View {
        TabBarView(selectedTab: $selectedTab, tabs: tabItems) {
            tabView
        }
    }
    
    // MARK: - Tab Items
    
    private var tabItems: [TabItem] {
        AppTab.allCases.map { tab in
            TabItem(
                title: tab.title,
                icon: tab.icon,
                selectedIcon: tab.selectedIcon
            )
        }
    }
    
    // MARK: - Tab View
    
    private var tabView: some View {
        Group {
            switch AppTab(rawValue: selectedTab) {
            case .home:
                NavigationStack(path: $router.path) {
                    UserListView()
                        .navigationDestination(for: AppRoute.self) { route in
                            switch route {
                            case .userDetail(let id):
                                UserDetailView(userId: id)
                            case .settings:
                                Text("Settings")
                                    .navigationTitle("Settings")
                            case .about:
                                Text("About")
                                    .navigationTitle("About")
                            }
                        }
                }
                .environmentObject(router)
                
            case .profile:
                NavigationStack {
                    Text("Profile Tab")
                        .navigationTitle("Profile")
                }
                
            case .settings:
                NavigationStack {
                    Text("Settings Tab")
                        .navigationTitle("Settings")
                }
                
            case .none:
                Text("Invalid Tab")
            }
        }
    }
    
    // MARK: - Setup
    
    /// Sets up the appearance of the app
    private func setupAppearance() {
        // Set navigation bar appearance
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        
        // Set tab bar appearance
        UITabBar.appearance().backgroundColor = UIColor.systemBackground
    }
}
