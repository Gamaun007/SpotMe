import Foundation
import FirebaseFirestore

final class UserRepository: UserRepositoryProtocol {
    private let db: Firestore
    private let collection = "users"

    init(db: Firestore) {
        self.db = db
    }

    func getUser(id: String) async throws -> User {
        let snapshot = try await db.collection(collection).document(id).getDocument()
        return try snapshot.data(as: User.self)
    }

    func createUser(_ user: User) async throws {
        try db.collection(collection).document(user.id).setData(from: user)
    }

    func updateUser(_ user: User) async throws {
        try db.collection(collection).document(user.id).setData(from: user, merge: true)
    }
}
