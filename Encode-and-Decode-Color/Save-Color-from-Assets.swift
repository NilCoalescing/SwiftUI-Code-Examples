// This is example code for article:
// https://nilcoalescing.com/blog/EncodeAndDecodeSwiftUIColor/
// You can use this code to save a named Color from Assets.
//
// This code assumes that you have color sets named 
// "myBlue", "myRed" and "myGreen" in your asset catalog.

import SwiftUI

struct ContentView2: View {
    @State private var selectedColor = "myBlue"

    // Color names from Assets
    let availableColors = [
        "myBlue",
        "myRed",
        "myGreen"
    ]
    
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
                    Text(color)
                }
            }
            .pickerStyle(.segmented)
            
            Rectangle()
                .fill(Color(selectedColor))
            
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
    
    func encode(colorName: String) async throws -> Data {
        try JSONEncoder().encode(colorName)
    }
    
    func decodeColorName(from data: Data) async throws -> String {
        try JSONDecoder().decode(String.self, from: data)
    }
    
    func loadColor() async {
        do {
            if FileManager.default.fileExists(atPath: colorURL.path) {
                let data = try Data(contentsOf: colorURL)
                let decodedColor = try await decodeColorName(from: data)
                selectedColor = decodedColor
            }
        } catch {
            // add error handling code here
            print("Loading error: \(error.localizedDescription)")
        }
    }
    
    func saveColor() async {
        do {
            let data = try await encode(colorName: selectedColor)
            try data.write(to: colorURL)
        } catch {
            // add error handling code here
            print("Saving error: \(error.localizedDescription)")
        }
    }
}
