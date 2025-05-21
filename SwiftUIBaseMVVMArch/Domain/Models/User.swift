//
//  User.swift
//  SwiftUIBaseMVVMArch
//
//  Created by İhsan Akbay on 21.05.2025.
//

import Foundation

/// A model representing a user in the application
struct User: Identifiable, Codable, Equatable {
    let id: Int
    let name: String
    let email: String
    let avatarURL: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case email
        case avatarURL = "avatar_url"
    }
    
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.id == rhs.id
    }
}
