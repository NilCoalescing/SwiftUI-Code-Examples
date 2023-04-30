//
//  Example4.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 4. Set a custom action for links inside Text
struct Example4: View {
    var body: some View {
        Text("Hello, world! Check out our [website](https://example.com)!")
            .environment(
                \.openURL,
                 OpenURLAction { url in
                     print("Link tapped: \(url)")
                     return .handled
                 }
            )
            .font(.title)
    }
}

struct Example4_Previews: PreviewProvider {
    static var previews: some View {
        Example4()
    }
}
