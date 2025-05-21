//
//  AppButton.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// Button styles for the application
enum AppButtonStyle {
    case primary
    case secondary
    case outline
    case destructive
    case plain
    case custom(backgroundColor: Color, foregroundColor: Color)
    
    var backgroundColor: Color {
        switch self {
        case .primary:
            return .primaryColor
        case .secondary:
            return .secondaryColor
        case .outline, .plain:
            return .clear
        case .destructive:
            return .errorColor
        case .custom(let backgroundColor, _):
            return backgroundColor
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .primary, .secondary, .destructive:
            return .white
        case .outline:
            return .primaryColor
        case .plain:
            return .textPrimary
        case .custom(_, let foregroundColor):
            return foregroundColor
        }
    }
    
    var borderColor: Color? {
        switch self {
        case .outline:
            return .primaryColor
        default:
            return nil
        }
    }
    
    var borderWidth: CGFloat {
        switch self {
        case .outline:
            return 1.5
        default:
            return 0
        }
    }
}

/// Button sizes for the application
enum AppButtonSize {
    case small
    case medium
    case large
    case custom(height: CGFloat, horizontalPadding: CGFloat)
    
    var height: CGFloat {
        switch self {
        case .small:
            return 32
        case .medium:
            return 44
        case .large:
            return 56
        case .custom(let height, _):
            return height
        }
    }
    
    var horizontalPadding: CGFloat {
        switch self {
        case .small:
            return 12
        case .medium:
            return 16
        case .large:
            return 20
        case .custom(_, let horizontalPadding):
            return horizontalPadding
        }
    }
    
    var font: Font {
        switch self {
        case .small:
            return .system(size: 14, weight: .medium)
        case .medium:
            return .system(size: 16, weight: .semibold)
        case .large:
            return .system(size: 18, weight: .semibold)
        case .custom:
            return .system(size: 16, weight: .semibold)
        }
    }
}

/// A custom button component with various styles and sizes
struct AppButton: View {
    // MARK: - Properties
    
    private let title: String
    private let icon: String?
    private let style: AppButtonStyle
    private let size: AppButtonSize
    private let cornerRadius: CGFloat
    private let isFullWidth: Bool
    private let isLoading: Bool
    private let action: () -> Void
    
    // MARK: - Initialization
    
    init(
        title: String,
        icon: String? = nil,
        style: AppButtonStyle = .primary,
        size: AppButtonSize = .medium,
        cornerRadius: CGFloat = 10,
        isFullWidth: Bool = false,
        isLoading: Bool = false,
        action: @escaping () -> Void
    ) {
        self.title = title
        self.icon = icon
        self.style = style
        self.size = size
        self.cornerRadius = cornerRadius
        self.isFullWidth = isFullWidth
        self.isLoading = isLoading
        self.action = action
    }
    
    // MARK: - Body
    
    var body: some View {
        Button(action: {
            if !isLoading {
                action()
            }
        }) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: style.foregroundColor))
                        .scaleEffect(0.8)
                } else if let icon = icon {
                    Image(systemName: icon)
                        .font(size.font)
                }
                
                Text(title)
                    .font(size.font)
                    .lineLimit(1)
            }
            .padding(.horizontal, size.horizontalPadding)
            .frame(height: size.height)
            .frame(maxWidth: isFullWidth ? .infinity : nil)
            .background(style.backgroundColor)
            .foregroundColor(style.foregroundColor)
            .cornerRadius(cornerRadius)
            .overlay(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .stroke(style.borderColor ?? .clear, lineWidth: style.borderWidth)
            )
            .opacity(isLoading ? 0.8 : 1.0)
        }
        .disabled(isLoading)
    }
}

// MARK: - Modifiers

extension AppButton {
    /// Sets the button style
    func buttonStyle(_ style: AppButtonStyle) -> AppButton {
        AppButton(
            title: title,
            icon: icon,
            style: style,
            size: size,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Sets the button size
    func buttonSize(_ size: AppButtonSize) -> AppButton {
        AppButton(
            title: title,
            icon: icon,
            style: style,
            size: size,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Sets the corner radius of the button
    func cornerRadius(_ radius: CGFloat) -> AppButton {
        AppButton(
            title: title,
            icon: icon,
            style: style,
            size: size,
            cornerRadius: radius,
            isFullWidth: isFullWidth,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Sets whether the button should take up the full width
    func fullWidth(_ isFullWidth: Bool = true) -> AppButton {
        AppButton(
            title: title,
            icon: icon,
            style: style,
            size: size,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth,
            isLoading: isLoading,
            action: action
        )
    }
    
    /// Sets whether the button is in a loading state
    func loading(_ isLoading: Bool = true) -> AppButton {
        AppButton(
            title: title,
            icon: icon,
            style: style,
            size: size,
            cornerRadius: cornerRadius,
            isFullWidth: isFullWidth,
            isLoading: isLoading,
            action: action
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        AppButton(title: "Primary Button", action: {})
        
        AppButton(title: "Secondary Button", style: .secondary, action: {})
        
        AppButton(title: "Outline Button", style: .outline, action: {})
        
        AppButton(title: "Destructive Button", style: .destructive, action: {})
        
        AppButton(title: "Plain Button", style: .plain, action: {})
        
        AppButton(title: "Custom Button", style: .custom(backgroundColor: .purple, foregroundColor: .white), action: {})
        
        AppButton(title: "Small Button", size: .small, action: {})
        
        AppButton(title: "Large Button", size: .large, action: {})
        
        AppButton(title: "Full Width Button", isFullWidth: true, action: {})
        
        AppButton(title: "Loading Button", isLoading: true, action: {})
        
        AppButton(title: "Button with Icon", icon: "star.fill", action: {})
            .buttonStyle(.secondary)
            .buttonSize(.large)
            .cornerRadius(25)
            .fullWidth()
    }
    .padding()
}
