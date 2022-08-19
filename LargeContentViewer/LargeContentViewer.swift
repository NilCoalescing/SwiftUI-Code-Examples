import SwiftUI
import MapKit

let userLocation = CLLocationCoordinate2D(
    latitude: -43.53099,
    longitude: 172.63656
)

let mapSpan = MKCoordinateSpan(
    latitudeDelta: 0.5,
    longitudeDelta: 0.5
)

struct ContentView: View {
    var body: some View {
        TabView {
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            WeatherView()
                .tabItem {
                    Label("Weather", systemImage: "sun.max")
                }
        }
    }
}

struct MapView: View {
    @State private var region = MKCoordinateRegion(
        center: userLocation, span: mapSpan
    )
    
    @State private var showWeatherOverlay = false
    
    @Environment(\.accessibilityLargeContentViewerEnabled)
    var largeContentViewerEnabled
    
    var body: some View {
        Map(coordinateRegion: $region)
            .edgesIgnoringSafeArea(.top)
            .overlay(alignment: .topTrailing) {
                LocationButton(mapRegion: $region)
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .accessibilityShowsLargeContentViewer {
                        Label("Recenter", systemImage: "location")
                    }
            }
            .overlay(alignment: .bottomTrailing) {
                WeatherButtonLabel()
                    .dynamicTypeSize(...DynamicTypeSize.xxxLarge)
                    .accessibilityShowsLargeContentViewer()
                    .onLongPressGesture(
                        minimumDuration: largeContentViewerEnabled ? 2 : 0.5
                    ) {
                        showWeatherOverlay = true
                    }
                    .padding()
            }
            .overlay {
                if showWeatherOverlay {
                    WeatherOverlay(isShowing: $showWeatherOverlay)
                }
            }
    }
}

struct WeatherOverlay: View {
    @Binding var isShowing: Bool
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Material.thin)
                .edgesIgnoringSafeArea(.top)
                .onTapGesture {
                    isShowing = false
                }
            
            VStack {
                Text("Christchurch")
                Text("13 °C")
                Image(systemName: "sun.max")
            }
            .font(.title)
            .padding()
            .background(.thickMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10, style: .continuous
                )
            )
        }
    }
}

struct WeatherButtonLabel: View {
    var body: some View {
        Text("13 °C")
            .font(.title)
            .buttonBackground()
    }
}

struct LocationButton: View {
    @Binding var mapRegion: MKCoordinateRegion
    
    var body: some View {
        Button {
            mapRegion = MKCoordinateRegion(
                center: userLocation, span: mapSpan
            )
        } label: {
            Label("Recenter", systemImage: "location")
                .labelStyle(.iconOnly)
                .buttonBackground()
        }
        .imageScale(.large)
        .foregroundColor(.primary)
        .padding()
    }
}

struct WeatherView: View {
    var body: some View {
        VStack(spacing: 20) {
            VStack {
                Text("Christchurch")
                Text("13 °C")
            }
            .font(.title)
        
            VStack(spacing: 14) {
                Text("Mostly Sunny")
                Text("Chance of rain: 40%")
            }
        }
        .multilineTextAlignment(.center)
    }
}

extension View {
    func buttonBackground() -> some View {
        self
            .padding(10)
            .background(.thickMaterial)
            .clipShape(
                RoundedRectangle(
                    cornerRadius: 10, style: .continuous
                )
            )
    }
}
