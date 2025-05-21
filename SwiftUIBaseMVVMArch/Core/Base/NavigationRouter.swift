//
//  NavigationRouter.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// A protocol that defines a route in the application
protocol Route: Hashable {}

/// A navigation router that handles navigation in the application
class NavigationRouter<R: Route>: ObservableObject {
    
    // MARK: - Properties
    
    /// The path of routes to navigate to
    @Published var path = NavigationPath()
    
    /// The currently presented sheet
    @Published var presentedSheet: R?
    
    /// The currently presented full-screen cover
    @Published var presentedFullScreenCover: R?
    
    // MARK: - Navigation Methods
    
    /// Pushes a route onto the navigation stack
    /// - Parameter route: The route to push
    func push(_ route: R) {
        path.append(route)
        AppLogger.debug("Pushed route: \(route)", category: .ui)
    }
    
    /// Pops the top route from the navigation stack
    func pop() {
        if !path.isEmpty {
            path.removeLast()
            AppLogger.debug("Popped route", category: .ui)
        }
    }
    
    /// Pops to the root of the navigation stack
    func popToRoot() {
        path = NavigationPath()
        AppLogger.debug("Popped to root", category: .ui)
    }
    
    /// Presents a sheet with the given route
    /// - Parameter route: The route to present as a sheet
    func presentSheet(_ route: R) {
        presentedSheet = route
        AppLogger.debug("Presented sheet: \(route)", category: .ui)
    }
    
    /// Dismisses the currently presented sheet
    func dismissSheet() {
        presentedSheet = nil
        AppLogger.debug("Dismissed sheet", category: .ui)
    }
    
    /// Presents a full-screen cover with the given route
    /// - Parameter route: The route to present as a full-screen cover
    func presentFullScreenCover(_ route: R) {
        presentedFullScreenCover = route
        AppLogger.debug("Presented full-screen cover: \(route)", category: .ui)
    }
    
    /// Dismisses the currently presented full-screen cover
    func dismissFullScreenCover() {
        presentedFullScreenCover = nil
        AppLogger.debug("Dismissed full-screen cover", category: .ui)
    }
}
