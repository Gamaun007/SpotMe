import Foundation

protocol SessionRepositoryProtocol {
    func getActiveSession(for traineeId: String) async throws -> Session?
    func getSessionHistory(for traineeId: String) async throws -> [Session]
    func createSession(_ session: Session) async throws
    func updateSession(_ session: Session) async throws
    func observeSession(id: String) -> AsyncStream<Session>
}
