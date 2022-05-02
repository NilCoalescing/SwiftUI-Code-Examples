import SwiftUI

struct MessageCell: View {
    let message: Message
    
    var body: some View {
        HStack {
            Text(message.text)
                .padding()
            Spacer()
        }
        .background(Color(UIColor.secondarySystemBackground))
        .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
        .padding()
    }
}
