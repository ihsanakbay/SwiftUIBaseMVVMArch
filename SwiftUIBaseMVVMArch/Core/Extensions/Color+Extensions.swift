//
//  Color+Extensions.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import SwiftUI

extension Color {
    /// Initializes a color from a hex string.
    /// - Parameter hex: A hex string, with or without the leading '#'.
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }

        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
    
    /// Returns the hex string representation of the color.
    /// - Returns: A hex string representation of the color.
    func toHex() -> String? {
        let uic = UIColor(self)
        guard let components = uic.cgColor.components, components.count >= 3 else {
            return nil
        }
        let r = Float(components[0])
        let g = Float(components[1])
        let b = Float(components[2])
        var a = Float(1.0)
        
        if components.count >= 4 {
            a = Float(components[3])
        }
        
        if a != Float(1.0) {
            return String(format: "%02lX%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255), lroundf(a * 255))
        } else {
            return String(format: "%02lX%02lX%02lX", lroundf(r * 255), lroundf(g * 255), lroundf(b * 255))
        }
    }
    
    // MARK: - Common Colors
    
    /// Primary brand color
    static let primaryColor = Color.blue
    
    /// Secondary brand color
    static let secondaryColor = Color.green
    
    /// Accent color for highlights
    static let accentColor = Color.orange
    
    /// Background color for light mode
    static let backgroundColor = Color(UIColor.systemBackground)
    
    /// Text primary color
    static let textPrimary = Color(UIColor.label)
    
    /// Text secondary color
    static let textSecondary = Color(UIColor.secondaryLabel)
    
    /// Error color
    static let errorColor = Color.red
    
    /// Success color
    static let successColor = Color.green
    
    /// Warning color
    static let warningColor = Color.yellow
    
    /// Info color
    static let infoColor = Color.blue
}
