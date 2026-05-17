import Foundation
import FirebaseFirestore

final class RealtimeService {
    private let db: Firestore

    init(db: Firestore) {
        self.db = db
    }

    func observeDocument<T: Decodable>(
        collection: String,
        id: String
    ) -> AsyncStream<T> {
        AsyncStream { continuation in
            let listener = db.collection(collection).document(id)
                .addSnapshotListener { snapshot, _ in
                    guard let value = try? snapshot?.data(as: T.self) else { return }
                    continuation.yield(value)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }

    func observeQuery<T: Decodable>(
        collection: String,
        query: (CollectionReference) -> Query
    ) -> AsyncStream<[T]> {
        AsyncStream { continuation in
            let listener = query(db.collection(collection))
                .addSnapshotListener { snapshot, _ in
                    guard let docs = snapshot?.documents else { return }
                    let values = docs.compactMap { try? $0.data(as: T.self) }
                    continuation.yield(values)
                }
            continuation.onTermination = { _ in listener.remove() }
        }
    }
}
