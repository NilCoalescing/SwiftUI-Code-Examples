//
// Example code for article: https://nilcoalescing.com/blog/UsingSceneStorageForStateRestorationInSwiftUIApps/
//

import SwiftUI

struct ContentView: View {
    @SceneStorage("selectedTab") var selectedTab: Tab = .car
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CarTrips()
                .tabItem {
                    Image(systemName: "car")
                    Text("Car Trips")
                }.tag(Tab.car)
            TramTrips()
                .tabItem {
                    Image(systemName: "tram.fill")
                    Text("Tram Trips")
                }.tag(Tab.tram)
            AirplaneTrips()
                .tabItem {
                    Image(systemName: "airplane")
                    Text("Airplane Trips")
                }.tag(Tab.airplaine)
        }
    }

    // Has to be RawRepresentable to be saved into SceneStorage
    enum Tab: String {
        case car
        case tram
        case airplaine
    }
}

struct CarTrips: View {
    var body: some View {
        NavigationView {
            List {
                Text("Dunedin 03.04.2020")
                Text("Nelson 20.04.2020")
                Text("Christchurch 7.05.2020")
            }
            .navigationTitle("Car Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
}

struct TramTrips: View {
    var body: some View {
        NavigationView {
            List {
                Text("Quake City Museum 09.04.2020")
                Text("Christchurch Cathedral  23.04.2020")
            }
            .navigationTitle("Tram Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

struct AirplaneTrips: View {
    @SceneStorage("selectedAirplaneSubview") var selectedAirplaneSubview: Subview = .domestic
    
    let subviews = Subview.allCases
    
    var body: some View {
        NavigationView {
            List {
                switch selectedAirplaneSubview {
                case Subview.domestic:
                    Text("Auckland 14.04.2020")
                    Text("Wellington 10.05.2020")
                case Subview.international:
                    Text("Sydney 17.04.2020")
                    Text("Singapore 12.05.2020")
                }
            }
            .navigationBarItems(
                trailing:
                        Picker("Airplane Trips", selection: $selectedAirplaneSubview) {
                            ForEach(self.subviews, id: \.self) { subview in
                                Text(subview.rawValue.capitalized)
                            }
                        }
                        .labelsHidden()
                        .pickerStyle(SegmentedPickerStyle())
                        .frame(width: 250)

            )
            .navigationTitle("Airplane Trips")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    enum Subview: String, CaseIterable {
        case domestic
        case international
    }
}
