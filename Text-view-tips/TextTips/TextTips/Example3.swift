//
//  Example3.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 3. Change color of links inside Text
struct Example3: View {
    var body: some View {
        Text("Hello, world! Check out our [website](https://example.com)!")
            .tint(.pink)
            .font(.title)
    }
}

struct Example3_Previews: PreviewProvider {
    static var previews: some View {
        Example3()
    }
}
