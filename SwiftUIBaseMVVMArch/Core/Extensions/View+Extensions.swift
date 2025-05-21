//
//  View+Extensions.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

extension View {
    /// Applies the given transform if the given condition evaluates to `true`.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - transform: The transform to apply to the source `View`.
    /// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
    @ViewBuilder func `if`<Content: View>(_ condition: Bool, transform: (Self) -> Content) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Applies a conditional modifier to a view.
    /// - Parameters:
    ///   - condition: The condition to evaluate.
    ///   - modifier: The modifier to apply if the condition is true.
    /// - Returns: The modified view if the condition is true, otherwise the original view.
    func conditionalModifier<T: ViewModifier>(_ condition: Bool, _ modifier: T) -> some View {
        Group {
            if condition {
                self.modifier(modifier)
            } else {
                self
            }
        }
    }

    /// Hides a view based on a condition.
    /// - Parameter hidden: The condition to determine if the view should be hidden.
    /// - Returns: The original view or an empty view if the condition is true.
    func isHidden(_ hidden: Bool) -> some View {
        opacity(hidden ? 0 : 1)
    }

    /// Applies a corner radius to specific corners of a view.
    /// - Parameters:
    ///   - radius: The radius to use when drawing rounded corners.
    ///   - corners: The corners to round.
    /// - Returns: A view with the specified corners rounded.
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }

    /// Adds a custom shadow to a view.
    /// - Parameters:
    ///   - color: The color of the shadow.
    ///   - radius: The blur radius of the shadow.
    ///   - x: The horizontal offset of the shadow.
    ///   - y: The vertical offset of the shadow.
    /// - Returns: A view with a shadow applied.
    func customShadow(color: Color, radius: CGFloat, x: CGFloat, y: CGFloat) -> some View {
        self.shadow(color: color, radius: radius, x: x, y: y)
    }

    /// Embeds a view in a navigation view.
    /// - Returns: A navigation view containing the original view.
    func embedInNavigation() -> some View {
        NavigationView { self }
    }
}

/// A shape that applies rounded corners to specific corners of a rectangle.
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}
