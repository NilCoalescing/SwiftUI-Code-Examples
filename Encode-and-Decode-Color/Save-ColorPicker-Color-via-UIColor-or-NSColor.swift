// This is example code for article:
// https://nilcoalescing.com/blog/EncodeAndDecodeSwiftUIColor/
// You can use this code to save a color that
// will be read on Apple platforms.

import SwiftUI

#if os(iOS)
typealias PlatformColor = UIColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(uiColor: platformColor)
    }
}
#elseif os(macOS)
typealias PlatformColor = NSColor
extension Color {
    init(platformColor: PlatformColor) {
        self.init(nsColor: platformColor)
    }
}
#endif

struct ContentView: View {
    @State private var color = Color(.sRGB, red: 0, green: 0, blue: 1, opacity: 1)
    
    var colorURL: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent("color")
    }
    
    var body: some View {
        VStack {
            ColorPicker("Rectangle Color", selection: $color)
            Rectangle()
                .fill(color)
            Button("Save") {
                Task {
                    await saveColor()
                }
            }
        }
        .padding()
        .task {
            await loadColor()
        }
    }
    
    func saveColor() async {
        do {
            let data = try await encodeColor()
            try data.write(to: colorURL)
        } catch {
            // add error handling code here
            print("Saving error: \(error.localizedDescription)")
        }
    }
    
    func loadColor() async {
        do {
            if FileManager.default.fileExists(atPath: colorURL.path) {
                let data = try Data(contentsOf: colorURL)
                let decodedColor = try await decodeColor(from: data)
                color = decodedColor
            }
        } catch {
            // add error handling code here
            print("Loading error: \(error.localizedDescription)")
        }
    }
    
    func encodeColor() async throws -> Data {
        let platformColor = PlatformColor(color)
        return try NSKeyedArchiver.archivedData(
            withRootObject: platformColor,
            requiringSecureCoding: true
        )
    }
    
    func decodeColor(from data: Data) async throws -> Color {
        guard let platformColor = try NSKeyedUnarchiver
                .unarchiveTopLevelObjectWithData(data) as? PlatformColor
            else {
                throw DecodingError.wrongType
            }
        return Color(platformColor: platformColor)
    }
}

enum DecodingError: Error {
    case wrongType
}
