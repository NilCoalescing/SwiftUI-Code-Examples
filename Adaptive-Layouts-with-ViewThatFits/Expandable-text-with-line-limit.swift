import SwiftUI

struct ExpandableTextWithLineLimitExample: View {   
    let text = """
    Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa.
    Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim.
    """
    
    var body: some View {
        ExpandableTextWithLineLimit(text: text, initialLineLimit: 3)
            .padding()
            .multilineTextAlignment(.center)
    }
}

struct ExpandableTextWithLineLimit: View {
    let text: String
    let initialLineLimit: Int
    @State private var isExpanded = false
    @State private var showButton = false
    
    var button: Button<Text> {
        if isExpanded {
            return Button("Show less") {
                isExpanded = false
            }
        } else {
            return Button("Show more") {
                isExpanded = true
            }
        }
    }
    
    var body: some View {
        Text(text)
            .lineLimit(isExpanded ? nil : initialLineLimit)
            .background {
                ViewThatFits(in: .vertical) {
                    Text(text)
                        .hidden()
                    Color.clear
                        .onAppear {
                            showButton = true
                        }
                }
            }
        if showButton {
            button
        }
    }
}
