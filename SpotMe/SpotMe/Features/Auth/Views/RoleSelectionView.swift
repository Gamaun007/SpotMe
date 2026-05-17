import SwiftUI

struct RoleSelectionView: View {
    @Environment(AppState.self) private var appState
    @Environment(DependencyContainer.self) private var container
    @State private var viewModel: AuthViewModel?

    var body: some View {
        VStack(spacing: Spacing.xl) {
            Text("I am a...")
                .font(Typography.title)

            if let viewModel {
                RoleOptionCard(title: "Trainer", subtitle: "I create programs and coach others", icon: "figure.strengthtraining.traditional") {
                    await viewModel.setRole(.trainer, appState: appState)
                }
                RoleOptionCard(title: "Trainee", subtitle: "I follow programs assigned by my trainer", icon: "figure.run") {
                    await viewModel.setRole(.trainee, appState: appState)
                }
            }
        }
        .padding(Spacing.screenPadding)
        .onAppear {
            if viewModel == nil {
                viewModel = AuthViewModel(
                    authService: container.authService,
                    userRepository: container.userRepository
                )
            }
        }
    }
}

private struct RoleOptionCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let action: () async -> Void

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            HStack(spacing: Spacing.lg) {
                Image(systemName: icon)
                    .font(.system(size: 36))
                    .frame(width: 56)

                VStack(alignment: .leading, spacing: Spacing.xs) {
                    Text(title).font(Typography.headline)
                    Text(subtitle).font(Typography.caption).foregroundStyle(Color.spotSecondaryText)
                }
                Spacer()
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .cardStyle()
        }
        .buttonStyle(.plain)
    }
}
