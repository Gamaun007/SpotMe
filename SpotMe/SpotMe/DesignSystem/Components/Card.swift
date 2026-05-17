import SwiftUI

struct Card<Content: View>: View {
    let content: () -> Content

    init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    var body: some View {
        content()
            .padding(Spacing.lg)
            .background(Color.spotSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    }
}
