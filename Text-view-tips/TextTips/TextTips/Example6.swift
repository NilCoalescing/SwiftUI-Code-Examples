//
//  Example6.swift
//  TextTips
//
//  Created by Natalia Panferova on 25/04/23.
//

import SwiftUI

// 6. Dynamic dates
struct Example6: View {
    var body: some View {
        let eventDate = Date(timeIntervalSinceNow: 646)
        
        // Date updates automatically in the UI
        Text("\(eventDate, style: .relative) left until the event")
            .font(.title)
            .padding()
    }
}

struct Example6_Previews: PreviewProvider {
    static var previews: some View {
        Example6()
    }
}
