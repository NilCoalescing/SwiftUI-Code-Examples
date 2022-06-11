import SwiftUI

struct AvoidTruncatedTextExample: View {
    var body: some View {
        VStack(spacing: 20) {
            SettingsButton()
                .border(.blue, width: 2)
            SettingsButton()
                .frame(width: 100)
                .border(.blue, width: 2)
            SettingsButton()
                .frame(width: 50)
                .border(.blue, width: 2)
        }
        .font(.system(size: 18))
    }
}

struct SettingsButton: View {
    var body: some View {
        ViewThatFits {
            Text("Open Settings")
                .fixedSize(horizontal: true, vertical: false)
            Text("Settings")
                .fixedSize(horizontal: true, vertical: false)
            Image(systemName: "gearshape")
        }
        .lineLimit(1)
    }
}
