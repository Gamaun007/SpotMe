import SwiftUI

struct SignUpView: View {
    @Bindable var viewModel: AuthViewModel
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: Spacing.md) {
            InputField(placeholder: "Display Name", text: $viewModel.displayName)
                .autocorrectionDisabled()

            InputField(placeholder: "Email", text: $viewModel.email)
                .keyboardType(.emailAddress)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()

            InputField(placeholder: "Password (min 8 characters)", text: $viewModel.password, isSecure: true)

            PrimaryButton("Create Account", isLoading: viewModel.isLoading) {
                await viewModel.signUp()
            }
        }
        .padding(Spacing.screenPadding)
        .navigationTitle("Create Account")
        .errorAlert(error: $viewModel.error)
    }
}
