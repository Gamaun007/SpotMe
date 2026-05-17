import Foundation
import Observation

@Observable
final class RelationshipViewModel {
    var trainees: [Relationship] = []
    var isLoading = false
    var error: Error?

    private let relationshipRepository: any RelationshipRepositoryProtocol
    private let authService: AuthService

    init(relationshipRepository: any RelationshipRepositoryProtocol, authService: AuthService) {
        self.relationshipRepository = relationshipRepository
        self.authService = authService
    }

    func loadTrainees() async {
        guard let trainerId = authService.currentUserId else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            trainees = try await relationshipRepository.getTrainees(for: trainerId)
        } catch {
            self.error = error
        }
    }
}
