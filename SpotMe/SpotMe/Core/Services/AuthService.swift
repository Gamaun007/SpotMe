import Foundation
import FirebaseAuth
import Observation

@Observable
final class AuthService {
    private let auth: Auth
    private var authStateListener: AuthStateDidChangeListenerHandle?

    private(set) var firebaseUser: FirebaseAuth.User?
    var isAuthenticated: Bool { firebaseUser != nil }
    var currentUserId: String? { auth.currentUser?.uid }

    init(auth: Auth) {
        self.auth = auth
        authStateListener = auth.addStateDidChangeListener { [weak self] _, user in
            self?.firebaseUser = user
        }
    }

    func signIn(email: String, password: String) async throws {
        try await auth.signIn(withEmail: email, password: password)
    }

    func signUp(email: String, password: String) async throws -> String {
        let result = try await auth.createUser(withEmail: email, password: password)
        return result.user.uid
    }

    func signOut() throws {
        try auth.signOut()
    }
}
