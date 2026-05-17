import Foundation
import Observation

@Observable
final class ProgramViewModel {
    var programs: [Program] = []
    var isLoading = false
    var error: Error?

    private let programRepository: any ProgramRepositoryProtocol
    private let authService: AuthService

    init(programRepository: any ProgramRepositoryProtocol, authService: AuthService) {
        self.programRepository = programRepository
        self.authService = authService
    }

    func loadPrograms() async {
        guard let trainerId = authService.currentUserId else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            programs = try await programRepository.getPrograms(for: trainerId)
        } catch {
            self.error = error
        }
    }

    func deleteProgram(id: String) async {
        do {
            try await programRepository.deleteProgram(id: id)
            programs.removeAll { $0.id == id }
        } catch {
            self.error = error
        }
    }
}
