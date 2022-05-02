import SwiftUI

struct MessageComposeView: View {
    let sendMessage: (String) -> ()
    @State private var text = ""
    @State private var keybaordHeight: CGFloat = 0
    
    var body: some View {
        HStack {
            TextField("Message", text: $text)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding()
            
            Button("Send") {
                self.sendMessage(text)
                self.text = ""
                UIApplication.shared.endEditing()
            }
            .padding()
        }

        .background(Color(UIColor.secondarySystemBackground))
        .padding(.bottom, keybaordHeight)
        
        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillChangeFrameNotification
            )
        ) { notification in
            guard let keyboardValue = notification
                .userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
            else { return }

            let keyboardFrame = keyboardValue.cgRectValue

            withAnimation {
                self.keybaordHeight = keyboardFrame.height
            }
        }

        .onReceive(
            NotificationCenter.default.publisher(
                for: UIResponder.keyboardWillHideNotification
            )
        ) { _ in
            self.keybaordHeight = 0
        }
    }
}
