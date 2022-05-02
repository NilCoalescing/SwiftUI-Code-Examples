import SwiftUI

struct ContentView: View {
    @State
    var text: String = "Example"
    
    @State
    var value: Bool = false
    
    var body: some View {
        UndoProvider(self.$value) { value in
            Toggle(isOn: value) {
                Text("Subscribe")
            }
        }
    }
}
