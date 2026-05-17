import Foundation
import Observation

@Observable
final class AuthViewModel {
    var email = ""
    var password = ""
    var displayName = ""
    var isLoading = false
    var error: Error?

    private let authService: AuthService
    private let userRepository: any UserRepositoryProtocol

    init(authService: AuthService, userRepository: any UserRepositoryProtocol) {
        self.authService = authService
        self.userRepository = userRepository
    }

    func signIn() async {
        isLoading = true
        defer { isLoading = false }
        do {
            try await authService.signIn(email: email, password: password)
        } catch {
            self.error = error
        }
    }

    func signUp() async {
        isLoading = true
        defer { isLoading = false }
        do {
            let uid = try await authService.signUp(email: email, password: password)
            let user = User(
                id: uid,
                email: email,
                displayName: displayName,
                role: nil,
                createdAt: Date(),
                updatedAt: Date()
            )
            try await userRepository.createUser(user)
        } catch {
            self.error = error
        }
    }

    func setRole(_ role: UserRole, appState: AppState) async {
        guard let userId = authService.currentUserId else { return }
        isLoading = true
        defer { isLoading = false }
        do {
            let existing = try await userRepository.getUser(id: userId)
            let updated = User(
                id: existing.id,
                email: existing.email,
                displayName: existing.displayName,
                role: role,
                createdAt: existing.createdAt,
                updatedAt: Date()
            )
            try await userRepository.updateUser(updated)
            appState.currentUser = updated
        } catch {
            self.error = error
        }
    }

    func signOut(appState: AppState) {
        do {
            try authService.signOut()
            appState.currentUser = nil
        } catch {
            self.error = error
        }
    }
}
