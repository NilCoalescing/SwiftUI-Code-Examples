//
// Example code for article: https://nilcoalescing.comblog/MultipleButtonsInListRows
//
// Tapping exactly on the views will trigger their actions
// and tapping anywhere else on the row will do nothing.
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
                
                Select(isSelected: isSelected)
                    .onTapGesture {
                        self.isSelected.toggle()
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
