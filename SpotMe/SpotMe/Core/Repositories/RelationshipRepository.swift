import Foundation
import FirebaseFirestore

final class RelationshipRepository: RelationshipRepositoryProtocol {
    private let db: Firestore
    private let collection = "relationships"

    init(db: Firestore) {
        self.db = db
    }

    func getRelationship(for traineeId: String) async throws -> Relationship? {
        let snapshot = try await db.collection(collection)
            .whereField("traineeId", isEqualTo: traineeId)
            .whereField("status", isEqualTo: RelationshipStatus.active.rawValue)
            .getDocuments()
        return try snapshot.documents.first.map { try $0.data(as: Relationship.self) }
    }

    func getTrainees(for trainerId: String) async throws -> [Relationship] {
        let snapshot = try await db.collection(collection)
            .whereField("trainerId", isEqualTo: trainerId)
            .whereField("status", isEqualTo: RelationshipStatus.active.rawValue)
            .getDocuments()
        return try snapshot.documents.map { try $0.data(as: Relationship.self) }
    }

    func updateRelationshipStatus(id: String, status: RelationshipStatus) async throws {
        try await db.collection(collection).document(id)
            .updateData(["status": status.rawValue])
    }
}
