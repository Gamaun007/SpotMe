import Foundation
import Observation

@Observable
final class MonitoringViewModel {
    var liveSession: Session?
    var isLoading = false
    var error: Error?

    private let sessionRepository: any SessionRepositoryProtocol
    private var observationTask: Task<Void, Never>?

    init(sessionRepository: any SessionRepositoryProtocol) {
        self.sessionRepository = sessionRepository
    }

    func startMonitoring(sessionId: String) {
        observationTask?.cancel()
        observationTask = Task {
            for await session in sessionRepository.observeSession(id: sessionId) {
                liveSession = session
            }
        }
    }

    func stopMonitoring() {
        observationTask?.cancel()
        observationTask = nil
    }

    func logSet(_ set: SetRecord, exerciseId: String) async {
        guard var session = liveSession else { return }
        guard let index = session.exercises.firstIndex(where: { $0.id == exerciseId }) else { return }
        session.exercises[index].completedSets.append(set)
        do {
            try await sessionRepository.updateSession(session)
        } catch {
            self.error = error
        }
    }
}
