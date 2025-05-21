//
//  String+Extensions.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

extension String {
    /// Checks if the string is a valid email address.
    var isValidEmail: Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    /// Checks if the string is empty or contains only whitespace.
    var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    /// Capitalizes the first letter of the string.
    var capitalizedFirstLetter: String {
        return prefix(1).capitalized + dropFirst()
    }
    
    /// Returns a new string with the camel case representation of the string.
    var camelCased: String {
        guard !isEmpty else { return "" }
        let parts = self.components(separatedBy: CharacterSet.alphanumerics.inverted)
        let first = parts.first?.lowercased() ?? ""
        let rest = parts.dropFirst().map { $0.capitalizedFirstLetter }
        return ([first] + rest).joined()
    }
    
    /// Returns a new string with the snake case representation of the string.
    var snakeCased: String {
        let pattern = "([a-z0-9])([A-Z])"
        let regex = try? NSRegularExpression(pattern: pattern, options: [])
        let range = NSRange(location: 0, length: self.count)
        let snakeCase = regex?.stringByReplacingMatches(in: self, options: [], range: range, withTemplate: "$1_$2").lowercased()
        return snakeCase?.replacingOccurrences(of: "-", with: "_").replacingOccurrences(of: " ", with: "_") ?? self.lowercased()
    }
    
    /// Truncates the string to the specified length and adds an ellipsis if it exceeds the length.
    /// - Parameter length: The maximum length of the string.
    /// - Returns: A truncated string with an ellipsis if necessary.
    func truncated(toLength length: Int) -> String {
        if self.count > length {
            return self.prefix(length) + "..."
        }
        return self
    }
    
    /// Converts a string to a URL.
    /// - Returns: A URL if the string is a valid URL, otherwise nil.
    func toURL() -> URL? {
        return URL(string: self)
    }
    
    /// Converts a JSON string to a dictionary.
    /// - Returns: A dictionary if the string is valid JSON, otherwise nil.
    func toDictionary() -> [String: Any]? {
        guard let data = self.data(using: .utf8) else { return nil }
        do {
            return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
        } catch {
            AppLogger.error("Failed to convert string to dictionary: \(error.localizedDescription)", category: .data)
            return nil
        }
    }
}
