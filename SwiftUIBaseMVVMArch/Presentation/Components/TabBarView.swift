//
//  TabBarView.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// Represents a tab in the tab bar
struct TabItem: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let selectedIcon: String
    
    init(title: String, icon: String, selectedIcon: String? = nil) {
        self.title = title
        self.icon = icon
        self.selectedIcon = selectedIcon ?? icon
    }
}

/// A custom tab bar view that can be used in the application
struct TabBarView<Content: View>: View {
    
    // MARK: - Properties
    
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    let content: Content
    
    // MARK: - Initialization
    
    init(selectedTab: Binding<Int>, tabs: [TabItem], @ViewBuilder content: () -> Content) {
        self._selectedTab = selectedTab
        self.tabs = tabs
        self.content = content()
    }
    
    // MARK: - Body
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // Main content
            content
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding(.bottom, 49) // Height of the tab bar
            
            // Custom Tab Bar
            HStack(spacing: 0) {
                ForEach(0..<tabs.count, id: \.self) { index in
                    Button(action: {
                        withAnimation {
                            selectedTab = index
                        }
                    }) {
                        VStack(spacing: 4) {
                            Image(systemName: selectedTab == index ? tabs[index].selectedIcon : tabs[index].icon)
                                .font(.system(size: 24))
                            
                            Text(tabs[index].title)
                                .font(.caption)
                        }
                        .foregroundColor(selectedTab == index ? .blue : .gray)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                    }
                }
            }
            .background(
                Rectangle()
                    .fill(Color.backgroundColor)
                    .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: -5)
            )
            .frame(height: 49)
        }
    }
}

/// A view modifier that applies a tab bar to a view
struct WithTabBar: ViewModifier {
    @Binding var selectedTab: Int
    let tabs: [TabItem]
    
    func body(content: Content) -> some View {
        TabBarView(selectedTab: $selectedTab, tabs: tabs) {
            content
        }
    }
}

extension View {
    /// Adds a custom tab bar to a view
    /// - Parameters:
    ///   - selectedTab: Binding to the selected tab index
    ///   - tabs: Array of tab items
    /// - Returns: A view with a custom tab bar
    func withTabBar(selectedTab: Binding<Int>, tabs: [TabItem]) -> some View {
        modifier(WithTabBar(selectedTab: selectedTab, tabs: tabs))
    }
}
