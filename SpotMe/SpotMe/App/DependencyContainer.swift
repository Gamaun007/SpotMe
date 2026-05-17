import Foundation
import FirebaseFirestore
import FirebaseAuth
import Observation

@Observable
final class DependencyContainer {
    let authService: AuthService
    let userRepository: any UserRepositoryProtocol
    let programRepository: any ProgramRepositoryProtocol
    let sessionRepository: any SessionRepositoryProtocol
    let relationshipRepository: any RelationshipRepositoryProtocol
    let realtimeService: RealtimeService

    init() {
        let db = Firestore.firestore()
        let auth = Auth.auth()

        authService = AuthService(auth: auth)
        realtimeService = RealtimeService(db: db)
        userRepository = UserRepository(db: db)
        programRepository = ProgramRepository(db: db)
        sessionRepository = SessionRepository(db: db)
        relationshipRepository = RelationshipRepository(db: db)
    }
}
