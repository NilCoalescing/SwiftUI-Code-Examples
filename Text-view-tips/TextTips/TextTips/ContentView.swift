//
//  ContentView.swift
//  TextTips
//
//  Created by Natalia Panferova on 10/04/23.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // 1. Text initializers
                    
                    // From a string literal
                    Text("Hello, World!") // Text.init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil)
                    
                    // From a string variable
                    let str = "Hello, World!"
                    Text(str) // Text.init<S>(_ content: S) where S: StringProtocol
                    
                    
                    // 2. Markdown
                    
                    // From a string literal
                    Text("Hello, **world**! Check out our [website](https://example.com).")
                    
                    // From a string variable, explicitly converted to a LocalizedStringKey
                    let markdownStr = "Hello, **world**! Check out our [website](https://example.com)."
                    Text(LocalizedStringKey(markdownStr))
                    
                    // From an AttributedString (no localization)
                    if let attrStr = try? AttributedString(markdown: markdownStr) {
                        Text(attrStr)
                    }
                    
                    
                    // 3. Change color of links inside Text
                    Text("Hello, **world**! Check out our [website](https://example.com).")
                        .tint(.pink)
                    
                    
                    // 4. Set a custom action for links inside Text
                    Text("Hello, **world**! Check out our [website](https://example.com).")
                        .environment(
                            \.openURL,
                             OpenURLAction { url in
                                 print("Link tapped: \(url)")
                                 return .handled
                             }
                        )
                    
                    
                    // 5. Text interpolation
                    
                    // Can interpolate text with text modifiers
                    Text("Hello, \(Text("world").foregroundColor(.pink))!")
                    
                    
                    // 6. Dynamic dates
                    
                    let eventDate = Date(timeIntervalSinceNow: 146)
                    // Date updates automatically in the UI
                    Text("\(eventDate, style: .relative) left until the event")
                    
                    
                    // 7. Monospaced digits
                    
                    // Force numeric characters take the same width independent of the digits
                    // and prevent the UI from jittering
                    Text("\(eventDate, style: .relative) left until the event")
                        .monospacedDigit()
                }
                .padding()
            }
            .navigationTitle("Text tips")
        }

    }
}
