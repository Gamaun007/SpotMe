import Foundation

struct Session: Codable, Identifiable {
    let id: String
    let traineeId: String
    let trainerId: String
    let programId: String
    let programName: String
    var status: SessionStatus
    let startedAt: Date
    var completedAt: Date?
    var exercises: [SessionExercise]
}

enum SessionStatus: String, Codable {
    case active
    case completed
}

struct SessionExercise: Codable, Identifiable {
    let id: String
    let name: String
    let targetSets: Int
    let targetReps: Int
    let targetWeight: Double?
    var completedSets: [SetRecord]
}
