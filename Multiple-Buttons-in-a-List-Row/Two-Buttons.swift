//
// Example code for article: https://nilcoalescing.com/blog/MultipleButtonsInListRows
//
// Tapping anywhere on the row will trigger both buttons.
//

import SwiftUI

struct ContentView: View {
    @State var isExpanded = false
    @State var isSelected = false
    
    var body: some View {
        List {
            HStack(spacing: 20) { 
                Button(action: {
                    self.isExpanded.toggle()
                }) {
                    Expand(isExpanded: isExpanded)
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
