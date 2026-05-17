import Foundation

struct InviteCode: Codable, Identifiable {
    var id: String { code }
    let code: String
    let trainerId: String
    let createdAt: Date
    let expiresAt: Date
    let used: Bool
    let usedBy: String?
}
