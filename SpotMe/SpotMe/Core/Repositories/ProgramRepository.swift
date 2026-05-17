import Foundation
import FirebaseFirestore

final class ProgramRepository: ProgramRepositoryProtocol {
    private let db: Firestore
    private let collection = "programs"

    init(db: Firestore) {
        self.db = db
    }

    func getPrograms(for trainerId: String) async throws -> [Program] {
        let snapshot = try await db.collection(collection)
            .whereField("trainerId", isEqualTo: trainerId)
            .getDocuments()
        return try snapshot.documents.map { try $0.data(as: Program.self) }
    }

    func getProgram(id: String) async throws -> Program {
        let snapshot = try await db.collection(collection).document(id).getDocument()
        return try snapshot.data(as: Program.self)
    }

    func createProgram(_ program: Program) async throws {
        try db.collection(collection).document(program.id).setData(from: program)
    }

    func updateProgram(_ program: Program) async throws {
        try db.collection(collection).document(program.id).setData(from: program, merge: true)
    }

    func deleteProgram(id: String) async throws {
        try await db.collection(collection).document(id).delete()
    }
}
