import Foundation

struct Relationship: Codable, Identifiable {
    let id: String
    let trainerId: String
    let traineeId: String
    let status: RelationshipStatus
    let createdAt: Date
    let updatedAt: Date?
}

enum RelationshipStatus: String, Codable {
    case active
    case inactive
}
