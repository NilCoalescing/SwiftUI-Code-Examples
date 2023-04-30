//
//  Example5.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 5. Text interpolation
struct Example5: View {
    var body: some View {
        // Can interpolate text with text modifiers
        Text("Hello, \(Text("world").foregroundColor(.pink))!")
            .font(.title)
    }
}

struct Example5_Previews: PreviewProvider {
    static var previews: some View {
        Example5()
    }
}
