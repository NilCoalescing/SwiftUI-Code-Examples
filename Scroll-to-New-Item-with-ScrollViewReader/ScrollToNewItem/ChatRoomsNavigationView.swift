import SwiftUI

struct ChatRoomsNavigationView: View {
    let chats = [Chat(name: "WWDC20"), Chat(name: "SwiftUI"), Chat(name: "SwiftLang")]
    
    var body: some View {
        NavigationView {
            List(chats) { chat in
                NavigationLink(destination: ChatRoom(chatId: chat.id)) {
                    Text(chat.name)
                }
            }
            .navigationTitle("Chats")
            
            Text("Nothing Selected")
                .foregroundColor(.secondary)
        }
    }
}
