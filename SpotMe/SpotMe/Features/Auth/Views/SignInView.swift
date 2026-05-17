import SwiftUI

struct SignInView: View {
    @Environment(DependencyContainer.self) private var container
    @State private var viewModel: AuthViewModel?

    var body: some View {
        NavigationStack {
            VStack(spacing: Spacing.xl) {
                Spacer()

                Text("SpotMe")
                    .font(Typography.largeTitle)

                if let viewModel {
                    VStack(spacing: Spacing.md) {
                        InputField(placeholder: "Email", text: Bindable(viewModel).email)
                            .keyboardType(.emailAddress)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()

                        InputField(placeholder: "Password", text: Bindable(viewModel).password, isSecure: true)
                    }

                    PrimaryButton("Sign In", isLoading: viewModel.isLoading) {
                        await viewModel.signIn()
                    }

                    NavigationLink("Create account") {
                        SignUpView(viewModel: viewModel)
                    }
                    .foregroundStyle(Color.spotPrimary)
                    .errorAlert(error: Bindable(viewModel).error)
                }

                Spacer()
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
}
