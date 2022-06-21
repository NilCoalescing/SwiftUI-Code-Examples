import SwiftUI
import OrderedCollections
import Foundation


struct ContentView: View {
    @State
    var data: [PenguinsDataPoint] = []
    
    @State
    var error: Error? = nil
    
    var body: some View {
        PenguinChart(
            dataset: self.data
        )
        .task(priority: .background) {
            do {
                self.data = try await PenguinsDataPoint.load()
            } catch {
                self.error = error
            }
        }
    }
}
