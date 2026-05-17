import Foundation

struct Program: Codable, Identifiable {
    let id: String
    let trainerId: String
    let name: String
    let description: String?
    var exercises: [Exercise]
    let createdAt: Date
    let updatedAt: Date
}
