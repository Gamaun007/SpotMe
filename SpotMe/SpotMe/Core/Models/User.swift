import Foundation

struct User: Codable, Identifiable {
    let id: String
    let email: String
    let displayName: String
    let role: UserRole?
    let createdAt: Date
    let updatedAt: Date
}

enum UserRole: String, Codable {
    case trainer
    case trainee
}
