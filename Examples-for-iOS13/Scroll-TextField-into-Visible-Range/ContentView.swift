//
// Example code for article: https://nilcoalescing.com/blog/ScrollTextFieldIntoVisibleRange/
//

import SwiftUI

struct ContentView: View {
    @State var textStrings = Array(repeating: "", count: 10)
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0...textStrings.count - 1, id: \.self) { index in
                    TextFieldWithKeyboardObserver(
                        text: self.$textStrings[index],
                        placeholder: "TextField number \(index + 1)"
                    )
                        .padding()
                        .roundedGrayBorder()
                }
            }
            .navigationBarTitle("Text Fields")
        }
    }
}
