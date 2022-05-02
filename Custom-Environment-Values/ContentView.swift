//
// Example code for article: https://nilcoalescing.com/blog/CustomEnvironmentValuesInSwiftUI/
//

import SwiftUI

struct SizeConstants {
    static let narrowWidth: CGFloat = 450
    static let smallHeight: CGFloat = 320
}

struct ContentView: View {
    var body: some View {
        GeometryReader { geo in
            VStack(spacing: 16) {
                AppDescription()
                SubscriptionButtonsStack()
            }
            .parentSize(geo.size)
        }
    }
}

struct AppDescription: View {
    
    @Environment(\.parentSize) var parentSize
    
    var hasSmallHeight: Bool {
        if let parentSize = parentSize,
            parentSize.height <= SizeConstants.smallHeight {
            return true
        }
        return false
    }
    
    var body: some View {
        VStack(spacing: 16) {
            Text("App Title")
                .font(.title)
            Text("This is a really great app.")
                .font(.headline)
            
            if !hasSmallHeight {
                Text("""
                This app lets you do lots of amazing things.
                You should definitely consider subscribing now.
                """)
            }
        }
        .multilineTextAlignment(.center)
    }
}

struct SubscriptionButtonsStack: View {
    
    @Environment(\.parentSize) var parentSize
    
    var isNarrow: Bool {
        if let parentSize = parentSize,
            parentSize.width <= SizeConstants.narrowWidth {
            return true
        
        }
        return false
    }
    
    var body: some View {
        Group {
            if isNarrow {
                VStack(spacing: 16) {
                   SubscriptionButtons()
                }
            } else {
                HStack(spacing: 16) {
                    SubscriptionButtons()
                }
            }
        }
    }
}

struct SubscriptionButtons: View {
    
    var body: some View {
        Group {
            Button(action: {
                // action
            }) {
                Text("Subscribe for 1 month")
                .padding()
                .background(Color.accentColor)
            }
            
            Button(action: {
                // action
            }) {
                Text("Subscribe for 1 year")
                .padding()
                .background(Color.accentColor)
            }
        }
        .foregroundColor(Color.white)
    }
}
