//
// Example code for article: https://nilcoalescing.com/blog/ScrollTextFieldIntoVisibleRange/
//
// A custom view modifier to easily add a border to a view.
//

import SwiftUI

struct RoundedGrayBorder: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(RoundedRectangle(cornerRadius: 10))
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Color.secondary, lineWidth: 1)
        )
    }
}

extension View {
    func roundedGrayBorder() -> some View {
        self.modifier(RoundedGrayBorder())
    }
}
