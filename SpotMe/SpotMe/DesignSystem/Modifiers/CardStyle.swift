import SwiftUI

struct CardStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(Spacing.lg)
            .background(Color.spotSecondaryBackground)
            .clipShape(RoundedRectangle(cornerRadius: CornerRadius.large))
    }
}

extension View {
    func cardStyle() -> some View {
        modifier(CardStyle())
    }
}
