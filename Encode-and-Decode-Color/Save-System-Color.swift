// This is example code for article:
// https://nilcoalescing.com/blog/EncodeAndDecodeSwiftUIColor/
// You can use this code to save a system color to disk.

import SwiftUI

struct ContentView: View {
    @State private var selectedColor = Color.blue
    let availableColors: [Color] = [.blue, .cyan, .indigo]
    
    var colorURL: URL {
        FileManager.default.urls(
            for: .documentDirectory,
            in: .userDomainMask
        )[0]
        .appendingPathComponent("color")
    }
    
    var body: some View {
        VStack {
            Picker("Rectangle Color", selection: $selectedColor) {
                ForEach(availableColors, id: \.self) { color in
                    Text(color.description)
                }
            }
            .pickerStyle(.segmented)
            
            Rectangle()
                .fill(selectedColor)
            
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
    
    func encode(color: Color) async throws -> Data {
        if let codableColor = CodableColor(color: color) {
            return try JSONEncoder().encode(codableColor)
        } else {
            throw EncodingError.wrongColor
        }
    }
    
    func decodeColor(from data: Data) async throws -> Color {
        let codableColor = try JSONDecoder()
            .decode(CodableColor.self, from: data)
        return Color(codableColor: codableColor)
    }
    
    func loadColor() async {
        do {
            if FileManager.default.fileExists(atPath: colorURL.path) {
                let data = try Data(contentsOf: colorURL)
                let decodedColor = try await decodeColor(from: data)
                selectedColor = decodedColor
            }
        } catch {
            // add error handling code here
            print("Loading error: \(error.localizedDescription)")
        }
    }
    
    func saveColor() async {
        do {
            let data = try await encode(color: selectedColor)
            try data.write(to: colorURL)
        } catch {
            // add error handling code here
            print("Saving error: \(error.localizedDescription)")
        }
    }
}

enum EncodingError: Error {
    case wrongColor
}

extension Color {
    init(codableColor: CodableColor) {
        switch codableColor {
        case .indigo: self = .indigo
        case .cyan: self = .cyan
        case .blue: self = .blue
        }
    }
}

enum CodableColor: String, CaseIterable, Codable {
    case blue
    case cyan
    case indigo
    
    init?(color: Color) {
        switch color {
        case .blue: self = .blue
        case .cyan: self = .cyan
        case .indigo: self = .indigo
        default: return nil
        }
    }
}
