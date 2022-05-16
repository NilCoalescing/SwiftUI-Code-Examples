// This is example code for article:
// https://nilcoalescing.com/blog/EncodeAndDecodeSwiftUIColor/
// You can use this code to save a color that
// will be read on Apple platforms or
// other platforms, such as the web.

import SwiftUI

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
        guard let cgColor = color.cgColor else {
            throw CodingError.wrongColor
        }
        return try JSONEncoder()
            .encode(CodableColor(cgColor: cgColor))
    }
    
    func decodeColor(from data: Data) async throws -> Color {
        let codableColor = try JSONDecoder().decode(CodableColor.self, from: data)
        return Color(cgColor: codableColor.cgColor)
    }
}

struct CodableColor: Codable {
    let cgColor: CGColor
    
    enum CodingKeys: String, CodingKey {
        case colorSpace
        case components
    }
    
    init(cgColor: CGColor) {
        self.cgColor = cgColor
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let colorSpace = try container.decode(String.self, forKey: .colorSpace)
        let components = try container.decode([CGFloat].self, forKey: .components)
        
        guard
            let cgColorSpace = CGColorSpace(name: colorSpace as CFString),
            let cgColor = CGColor(
                colorSpace: cgColorSpace, components: components
            )
        else {
            throw CodingError.wrongData
        }
        
        self.cgColor = cgColor
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard
            let colorSpace = cgColor.colorSpace?.name,
            let components = cgColor.components
        else {
            throw CodingError.wrongData
        }
              
        try container.encode(colorSpace as String, forKey: .colorSpace)
        try container.encode(components, forKey: .components)
    }
}

enum CodingError: Error {
    case wrongColor
    case wrongData
}
