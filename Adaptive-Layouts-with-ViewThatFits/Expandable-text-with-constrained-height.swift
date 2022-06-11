import SwiftUI

struct ExpandableTextExample: View {    
    let text = """
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.
    Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
    """
    
    var body: some View {
        ExpandableText(text: text, initialHeight: 100)
            .padding()
            .multilineTextAlignment(.center)
    }
}

struct ExpandableText: View {
    let text: String
    let initialHeight: Double
    @State private var isExpanded = false
    
    var body: some View {
        if isExpanded {
            Text(text)
            Button("Show less") {
                isExpanded = false
            }
        } else {
            ViewThatFits {
                Text(text)
                    .fixedSize(horizontal: false, vertical: true)
                VStack {
                    Text(text)
                    Button("Show more") {
                        isExpanded = true
                    }
                }
            }
            .frame(height: initialHeight)
        }
    }
}
