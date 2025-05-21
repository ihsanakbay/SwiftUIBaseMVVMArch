//
//  CardView.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

/// A card view with customizable appearance
struct CardView<Content: View>: View {
    // MARK: - Properties
    
    private let content: Content
    private let backgroundColor: Color
    private let cornerRadius: CGFloat
    private let shadowRadius: CGFloat
    private let shadowColor: Color
    private let shadowOpacity: Double
    private let borderColor: Color?
    private let borderWidth: CGFloat
    private let padding: CGFloat
    
    // MARK: - Initialization
    
    init(
        backgroundColor: Color = .backgroundColor,
        cornerRadius: CGFloat = 12,
        shadowRadius: CGFloat = 5,
        shadowColor: Color = .black,
        shadowOpacity: Double = 0.1,
        borderColor: Color? = nil,
        borderWidth: CGFloat = 0,
        padding: CGFloat = 16,
        @ViewBuilder content: () -> Content
    ) {
        self.content = content()
        self.backgroundColor = backgroundColor
        self.cornerRadius = cornerRadius
        self.shadowRadius = shadowRadius
        self.shadowColor = shadowColor
        self.shadowOpacity = shadowOpacity
        self.borderColor = borderColor
        self.borderWidth = borderWidth
        self.padding = padding
    }
    
    // MARK: - Body
    
    var body: some View {
        content
            .padding(padding)
            .background(
                RoundedRectangle(cornerRadius: cornerRadius)
                    .fill(backgroundColor)
                    .if(borderColor != nil) { view in
                        view.overlay(
                            RoundedRectangle(cornerRadius: cornerRadius)
                                .stroke(borderColor!, lineWidth: borderWidth)
                        )
                    }
                    .shadow(
                        color: shadowColor.opacity(shadowOpacity),
                        radius: shadowRadius,
                        x: 0,
                        y: 2
                    )
            )
    }
}

// MARK: - Modifiers

extension CardView {
    /// Sets the background color of the card
    func backgroundColor(_ color: Color) -> CardView {
        CardView(
            backgroundColor: color,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            borderColor: borderColor,
            borderWidth: borderWidth,
            padding: padding,
            content: { content }
        )
    }
    
    /// Sets the corner radius of the card
    func cornerRadius(_ radius: CGFloat) -> CardView {
        CardView(
            backgroundColor: backgroundColor,
            cornerRadius: radius,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            borderColor: borderColor,
            borderWidth: borderWidth,
            padding: padding,
            content: { content }
        )
    }
    
    /// Sets the shadow properties of the card
    func shadow(radius: CGFloat, color: Color = .black, opacity: Double = 0.1) -> CardView {
        CardView(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: radius,
            shadowColor: color,
            shadowOpacity: opacity,
            borderColor: borderColor,
            borderWidth: borderWidth,
            padding: padding,
            content: { content }
        )
    }
    
    /// Sets the border properties of the card
    func border(color: Color, width: CGFloat = 1) -> CardView {
        CardView(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            borderColor: color,
            borderWidth: width,
            padding: padding,
            content: { content }
        )
    }
    
    /// Sets the padding of the card content
    func contentPadding(_ padding: CGFloat) -> CardView {
        CardView(
            backgroundColor: backgroundColor,
            cornerRadius: cornerRadius,
            shadowRadius: shadowRadius,
            shadowColor: shadowColor,
            shadowOpacity: shadowOpacity,
            borderColor: borderColor,
            borderWidth: borderWidth,
            padding: padding,
            content: { content }
        )
    }
}

// MARK: - Preview

#Preview {
    VStack(spacing: 20) {
        CardView {
            Text("Basic Card")
                .font(.headline)
                .frame(maxWidth: .infinity)
                .padding()
        }
        
        CardView(backgroundColor: .blue.opacity(0.1), cornerRadius: 20) {
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text("Custom Card")
                    .foregroundColor(.primary)
            }
            .padding()
        }
        
        CardView(content: {
            VStack(alignment: .leading) {
                Text("Fluent API Card")
                    .font(.headline)
                Text("Using modifier functions")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        })
        .backgroundColor(.green.opacity(0.1))
        .cornerRadius(8)
        .shadow(radius: 10, color: .green, opacity: 0.2)
        .border(color: .green.opacity(0.3), width: 2)
        .contentPadding(12)
    }
    .padding()
}
