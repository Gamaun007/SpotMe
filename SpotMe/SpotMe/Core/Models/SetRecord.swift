import Foundation

struct SetRecord: Codable, Identifiable {
    let id: String
    let reps: Int
    let weight: Double
    let completedAt: Date
    let loggedBy: LoggedBy
}

enum LoggedBy: String, Codable {
    case trainee
    case trainer
}
