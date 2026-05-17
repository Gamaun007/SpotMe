import SwiftUI

struct InputField: View {
    let placeholder: String
    @Binding var text: String
    var isSecure = false

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
        }
        .padding(Spacing.md)
        .frame(minHeight: 44)
        .background(Color.spotSecondaryBackground)
        .clipShape(RoundedRectangle(cornerRadius: CornerRadius.medium))
    }
}
