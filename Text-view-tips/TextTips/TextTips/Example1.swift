//
//  Example1.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 1. Text initializers
struct Example1: View {
    var body: some View {
        VStack(spacing: 20) {
            // From a string literal
            
            Text("Hello, World!") // Text.init(_ key: LocalizedStringKey, tableName: String? = nil, bundle: Bundle? = nil, comment: StaticString? = nil)
            
            
            // From a string variable
            
            let str = "Hello, World!"
            Text(str) // Text.init<S>(_ content: S) where S: StringProtocol
        }
        .font(.title)
    }
}

struct Example1_Previews: PreviewProvider {
    static var previews: some View {
        Example1()
    }
}
