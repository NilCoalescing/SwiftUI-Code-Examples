//
// Example code for article: https://nilcoalescing.com/blog/MultipleButtonsInListRows
//
// Tapping exactly on the Expand view will only toggle the expansion,
// but tapping anywhere else on the row will trigger the Select view.
//

import SwiftUI

struct ContentView: View {
    @State var isExpanded = false
    @State var isSelected = false
    
    var body: some View {
        List {
            HStack(spacing: 20) {
                Expand(isExpanded: isExpanded)
                    .onTapGesture {
                        self.isExpanded.toggle()
                }
                
                Button(action: {
                    self.isSelected.toggle()
                }) {
                    Select(isSelected: isSelected)
                }
            }
        }
    }
}

struct Expand: View {
    let isExpanded: Bool
    
    var body: some View {
        Text(isExpanded ? "Collapse" : "Expand")
    }
}

struct Select: View {
    let isSelected: Bool
    
    var body: some View {
        Text(isSelected ? "Unselect" : "Select")
    }
}
