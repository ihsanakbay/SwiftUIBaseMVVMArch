//
//  AppRoute.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

/// Enum defining the app routes
enum AppRoute: Route {
    case userDetail(id: Int)
    case settings
    case about
}
