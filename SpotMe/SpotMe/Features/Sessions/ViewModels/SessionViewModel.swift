import Foundation
import Observation

@Observable
final class SessionViewModel {
    var activeSession: Session?
    var sessionHistory: [Session] = []
    var isLoading = false
    var error: Error?

    private let sessionRepository: any SessionRepositoryProtocol
    private let authService: AuthService
    private var observationTask: Task<Void, Never>?

    init(sessionRepository: any SessionRepositoryProtocol, authService: AuthService) {
        self.sessionRepository = sessionRepository
        self.authService = authService
    }

    func loadActiveSession() async {
        guard let traineeId = authService.currentUserId else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            activeSession = try await sessionRepository.getActiveSession(for: traineeId)
        } catch {
            self.error = error
        }
    }

    func loadHistory() async {
        guard let traineeId = authService.currentUserId else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            sessionHistory = try await sessionRepository.getSessionHistory(for: traineeId)
        } catch {
            self.error = error
        }
    }

    func observeSession(id: String) {
        observationTask?.cancel()
        observationTask = Task {
            for await session in sessionRepository.observeSession(id: id) {
                activeSession = session
            }
        }
    }

    func stopObserving() {
        observationTask?.cancel()
        observationTask = nil
    }
}
