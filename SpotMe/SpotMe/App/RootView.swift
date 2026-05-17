import SwiftUI

struct RootView: View {
    @Environment(AppState.self) private var appState

    var body: some View {
        Group {
            if appState.isLoadingAuth {
                ProgressView()
            } else if !appState.isAuthenticated {
                SignInView()
            } else if appState.needsRoleSelection {
                RoleSelectionView()
            } else if appState.isTrainer {
                TrainerHomeView()
            } else {
                TraineeHomeView()
            }
        }
    }
}
