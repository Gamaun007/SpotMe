import SwiftUI

struct PrimaryButton: View {
    let title: String
    var isLoading = false
    let action: () async -> Void

    init(_ title: String, isLoading: Bool = false, action: @escaping () async -> Void) {
        self.title = title
        self.isLoading = isLoading
        self.action = action
    }

    var body: some View {
        Button {
            Task { await action() }
        } label: {
            ZStack {
                if isLoading {
                    ProgressView().tint(.white)
                } else {
                    Text(title).fontWeight(.semibold)
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
        }
        .buttonStyle(.borderedProminent)
        .disabled(isLoading)
    }
}
