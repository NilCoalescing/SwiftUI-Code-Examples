import SwiftUI

struct ChatRoom: View {
    let chatId: UUID
    @State private var messages: [Message] = []
    @State var messageIdToSetVisible: UUID?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { scrollProxy in
                ScrollView {
                    VStack(spacing: 10) {
                        ForEach(messages) { message in
                            MessageCell(message: message)
                                .id(message.id)
                        }
                    }
                }
                .onChange(of: self.messageIdToSetVisible) { id in
                    guard id != nil else { return }
                    
                    withAnimation {
                        scrollProxy.scrollTo(id)
                    }
                }
            }
            
            MessageComposeView(sendMessage: appendMessage)
        }
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarItems(trailing: Button("Incoming Message") {
            self.appendMessage(
                text: RandomSentenceGenerator.generateSentence()
            )
        })
        
    }
    
    func appendMessage(text: String) {
        let newMessage = Message(text: text)
        messages.append(newMessage)
        
        // even if we had access to ScrollProxy here,
        // we could't tell it to scroll to the new item
        // the view hasn't rendered the new item at this point yet
        messageIdToSetVisible = newMessage.id
    }
}
