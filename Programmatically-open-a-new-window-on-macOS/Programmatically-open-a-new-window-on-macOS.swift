import SwiftUI

@main
struct OpenWindowApp: App {
    @StateObject private var dataStore = DataStore()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(dataStore)
        }
        WindowGroup("Note", for: Note.ID.self) { $noteId in
            NoteView(noteId: noteId)
                .environmentObject(dataStore)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject var dataStore: DataStore
    @State private var selectedNote: UUID?
        
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        NavigationSplitView {
            List(dataStore.notes, selection: $selectedNote) { note in
                NavigationLink(note.name, value: note.id)
                    .contextMenu {
                        Button("Open Note in New Window") {
                            openWindow(value: note.id)
                        }
                    }
            }
            .navigationTitle("Notes")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        let newNote = Note(name: "Note \(dataStore.notes.count + 1)")
                        dataStore.notes.append(newNote)
                        selectedNote = newNote.id
                    } label: {
                        Label("New Note", systemImage: "plus")
                    }
                }
            }
        } detail: {
            NoteView(noteId: selectedNote)
        }
    }
}

struct NoteView: View {
    @EnvironmentObject var dataStore: DataStore
    let noteId: UUID?
    
    var body: some View {
        if let noteId {
            if let index = dataStore.notes.firstIndex(
                where: { $0.id == noteId }
            ) {
                TextEditor(text: $dataStore.notes[index].text)
                    .navigationTitle(dataStore.notes[index].name)
            } else {
                // If we ended up here, it means that the note detail window was state restored by SwiftUI, but we didn't implement data persistence, so we can't show the note.
                Text("Couldn't find the presented note, because data persistence is not implemented in this sample project")
            }
        } else {
            Text("Nothing selected")
        }
    }
}

class DataStore: ObservableObject {
    @Published var notes: [Note] = []
}

struct Note: Identifiable {
    var id = UUID()
    var text: String = ""
    var name: String
}
