//
//  AppTab.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

enum AppTab: Int, CaseIterable {
    case home = 0
    case profile = 1
    case settings = 2

    var title: String {
        switch self {
        case .home: return "Home"
        case .profile: return "Profile"
        case .settings: return "Settings"
        }
    }

    var icon: String {
        switch self {
        case .home: return "house"
        case .profile: return "person"
        case .settings: return "gear"
        }
    }

    var selectedIcon: String {
        switch self {
        case .home: return "house.fill"
        case .profile: return "person.fill"
        case .settings: return "gear.circle.fill"
        }
    }
}
