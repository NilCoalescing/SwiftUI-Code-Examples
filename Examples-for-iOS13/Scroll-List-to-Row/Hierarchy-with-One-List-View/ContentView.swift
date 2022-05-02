//
//  Code for article https://nilcoalescing.com/blog/ScrollListToRowInSwiftUI/
//

import SwiftUI

struct ContentView: View {
    @State var items = [
        "Item 1", "Item 2", "Item 3", "Item 4", "Item 5",
        "Item 6", "Item 7", "Item 8", "Item 9", "Item 10",
        "Item 11", "Item 12", "Item 13", "Item 14", "Item 15",
        "Item 16", "Item 17", "Item 18", "Item 19", "Item 20"
    ]
    
    @State var indexPathToSetVisible: IndexPath?
    
    var body: some View {
        NavigationView {
            List {
                ForEach(0..<self.items.count, id: \.self) { index in
                    Text(self.items[index])
                }
            }
            .overlay(
                ScrollManagerView(indexPathToSetVisible: $indexPathToSetVisible)
                    .allowsHitTesting(false).frame(width: 0, height: 0)
            )
            .navigationBarTitle("Items")
            .navigationBarItems(
                leading:
                    Button("Scroll to top") {
                        self.indexPathToSetVisible = IndexPath(row: 0, section: 0)
                    },
                trailing:
                    Button("Add") {
                        self.items.append("Item \(self.items.count + 1)")
                        
                        // scroll to the newly added item
                        self.indexPathToSetVisible = IndexPath(row: self.items.count - 1, section: 0)
                }
            )
            .onAppear {
                // scroll to a particular item on app launch
                self.indexPathToSetVisible = IndexPath(row: 18, section: 0)
            }
        }
    }
}
