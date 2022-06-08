import SwiftUI

struct ContentView: View {
    @State
    var data: [BabyNamesDataPoint] = []
    
    @State
    var error: Error? = nil
    
    var body: some View {
        VStack {
            if let error = error {
                Text("error: \(error.localizedDescription)")
            } else if data.isEmpty {
                ProgressView().progressViewStyle(.circular)
            } else {
                SimpleBabyChart(data: data)
            }
        }
        .task(priority: .background) {
            do {
                self.data = try await BabyNamesDataPoint.load()
            } catch {
                self.error = error
            }
        }.frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
