//
//  Example7.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 7. Monospaced digits
struct Example7: View {
    var body: some View {
        let eventDate = Date(timeIntervalSinceNow: 646)
        
        // Force numeric characters take the same width independent of the digits
        // and prevent the UI from jittering
        
        Text("\(eventDate, style: .relative) left until the event")
            .monospacedDigit()
            .font(.title)
            .padding()
    }
}

struct Example7_Previews: PreviewProvider {
    static var previews: some View {
        Example7()
    }
}
