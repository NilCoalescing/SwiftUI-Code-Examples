//
//  Example2.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 2. Markdown
struct Example2: View {
    var body: some View {
        VStack(spacing: 20) {
            // From a string literal
            
            Text("Hello, **world**! Check out our [website](https://example.com)!")
            
            
            // From a string variable, explicitly converted to a LocalizedStringKey
            
            let markdownStr = "Hello, **world**! Check out our [website](https://example.com)!"
            Text(LocalizedStringKey(markdownStr))
            
            
            // From an AttributedString (no localization)
            
            if let attrStr = try? AttributedString(markdown: markdownStr) {
                Text(attrStr)
            }
        }
        .font(.title)
    }
}

struct Example2_Previews: PreviewProvider {
    static var previews: some View {
        Example2()
    }
}
