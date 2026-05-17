import Foundation

struct Exercise: Codable, Identifiable {
    let id: String
    let name: String
    let targetSets: Int
    let targetReps: Int
    let targetWeight: Double?
    let order: Int
}
