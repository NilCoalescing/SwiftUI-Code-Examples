//
// Example code for article: https://nilcoalescing.com/blog/iOSKeyboardShortcutsInSwiftUI/
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var cityProvider: CityProvider
    
    var body: some View {
        NavigationView {
            List {
                ForEach(cityProvider.addedCities) { city in
                    Button(action: {
                        self.cityProvider.selectedCity = city
                    }) {
                        Text(city.name)
                    }
                    .listRowBackground(
                        city == self.cityProvider.selectedCity
                            ? Color(UIColor.secondarySystemBackground)
                            : Color(UIColor.systemBackground)
                    )
                }
                .onDelete(perform: delete)
            }
            .navigationBarTitle("Cities")
            .navigationBarItems(trailing:
                Button(action: cityProvider.addCity) {
                    Image(systemName: "plus")
                        .resizable()
                        .frame(width: 20, height: 20)
                }
                .disabled(cityProvider.cities.count == cityProvider.addedCities.count)
            )
            
            if cityProvider.selectedCity != nil {
                CityDetailView(city: cityProvider.selectedCity!)
            }
        }
    }
    
    func delete(at offsets: IndexSet) {
        if let indexToDelete = offsets.first {
            cityProvider.deleteCity(cityProvider.addedCities[indexToDelete])
        }
    }
}

struct CityDetailView: View {
    let city: City
    
    var body: some View {
        VStack {
            Text(city.description)
            Spacer()
        }
        .padding()
        .navigationBarTitle(city.name)
    }
}
