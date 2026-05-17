import Foundation
import FirebaseFirestore

final class SessionRepository: SessionRepositoryProtocol {
    private let db: Firestore
    private let collection = "sessions"

    init(db: Firestore) {
        self.db = db
    }

    func getActiveSession(for traineeId: String) async throws -> Session? {
        let snapshot = try await db.collection(collection)
            .whereField("traineeId", isEqualTo: traineeId)
            .whereField("status", isEqualTo: SessionStatus.active.rawValue)
            .getDocuments()
        return try snapshot.documents.first.map { try $0.data(as: Session.self) }
    }

    func getSessionHistory(for traineeId: String) async throws -> [Session] {
        let snapshot = try await db.collection(collection)
            .whereField("traineeId", isEqualTo: traineeId)
            .whereField("status", isEqualTo: SessionStatus.completed.rawValue)
            .order(by: "startedAt", descending: true)
            .getDocuments()
        return try snapshot.documents.map { try $0.data(as: Session.self) }
    }

    func createSession(_ session: Session) async throws {
        try db.collection(collection).document(session.id).setData(from: session)
    }

    func updateSession(_ session: Session) async throws {
        try db.collection(collection).document(session.id).setData(from: session, merge: true)
    }

    func observeSession(id: String) -> AsyncStream<Session> {
        AsyncStream { continuation in
            let listener = db.collection(collection).document(id)
                .addSnapshotListener { snapshot, _ in
                    guard let session = try? snapshot?.data(as: Session.self) else { return }
                    continuation.yield(session)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }
}
