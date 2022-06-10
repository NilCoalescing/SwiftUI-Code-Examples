import SwiftUI
import OrderedCollections

struct ContentView: View {
    @State
    var data: OrderedDictionary<String, [BabyNamesDataPoint]> = [:]
    
    @State
    var error: Error? = nil
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            if let error = error {
                Text("error: \(error.localizedDescription)")
            } else if data.isEmpty {
                ProgressView().progressViewStyle(.circular).accessibilityLabel("Downloading data")
            } else {
                RidgeBabyChart(groupedData: data).accessibilityHidden(false)
            }
        }
        .task(priority: .background) {
            do {
                
                let data = try await BabyNamesDataPoint.load()

                let groupedData = Dictionary(grouping: data) { item in
                    item.name
                }


                let sorted = groupedData.sorted { a, b in
                    a.value.yearOfMaxProportion < b.value.yearOfMaxProportion
                }

                self.data = OrderedDictionary(
                    uniqueKeysWithValues: sorted
                )
                
//                let sortedDictValues = dataDict.mapValues { babies in
//                    babies.sorted { a, b in
//                        a.year < b.year
//                    }
//                }
                            
                
            } catch {
                self.error = error
            }
        }
    }
}

extension Array where Element == BabyNamesDataPoint {
    var yearOfMaxProportion: Date {
        guard let first = self.first else {
            fatalError("There must be at least one data point!!")
        }
        var year = first.year
        var proportion = first.proportion
        for element in self {
            if element.proportion > proportion {
                year = element.year
                proportion = element.proportion
            }
        }
        return year
    }
}
