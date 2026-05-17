import Foundation
import Observation

@Observable
final class AppState {
    var currentUser: User?
    var isLoadingAuth = true

    var isAuthenticated: Bool { currentUser != nil }
    var isTrainer: Bool { currentUser?.role == .trainer }
    var needsRoleSelection: Bool { currentUser != nil && currentUser?.role == nil }
}
