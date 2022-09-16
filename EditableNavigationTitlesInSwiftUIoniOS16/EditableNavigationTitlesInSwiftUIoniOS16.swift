import SwiftUI

@main
struct SampleNotesApp: App {
    @StateObject private var notesProvider = NotesProvider()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesProvider)
        }
    }
}

struct ContentView: View {
    @EnvironmentObject private var notesProvider: NotesProvider
    @StateObject private var navigationState = NavigationState()
    
    private var selectedNote: Note? {
        guard let selection = navigationState.selectedNoteId else {
            return nil
        }
        return notesProvider.notes.first { $0.id == selection }
    }
    
    var body: some View {
        NavigationSplitView {
            NoteList()
        } detail: {
            ZStack {
                if let note = selectedNote {
                    NoteView(note: note)
                } else {
                    Text("Nothing selected")
                }
            }
        }
        .environmentObject(navigationState)
    }
}

struct NoteList: View {
    @EnvironmentObject private var notesProvider: NotesProvider
    @EnvironmentObject private var navigationState: NavigationState
    
    var body: some View {
        List(
            notesProvider.notes,
            selection: $navigationState.selectedNoteId
        ) { note in
            NoteListRow(note: note)
        }
        .navigationTitle("Notes")
        .toolbar {
            Button {
                notesProvider.notes.append(Note(title: "New note"))
            } label: {
                Label("New note", systemImage: "plus")
            }
        }
    }
}

struct NoteListRow: View {
    @ObservedObject var note: Note
    
    var body: some View {
        NavigationLink(value: note.id) {
            HStack {
                Text(note.title)
                Spacer()
            }
        }
    }
}

struct NoteView: View {
    @ObservedObject var note: Note
    
    var body: some View {
        TextEditor(text: $note.text)
            .padding()
            .navigationTitle($note.title)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarRole(.editor)
    }
}

class NavigationState: ObservableObject {
    @Published var selectedNoteId: UUID?
}

class NotesProvider: ObservableObject {
    @Published var notes = [
        Note(title: "Note 1"),
        Note(title: "Note 2"),
        Note(title: "Note 3")
    ]
}

class Note: Identifiable, ObservableObject {
    @Published var title: String
    
    var id: UUID = UUID()
    
    init(title: String) {
        self.title = title
    }
    
    @Published var text: String = """
    Lorem ipsum dolor sit amet, consectetur adipiscing elit, \
    sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.\
    Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris \
    nisi ut aliquip ex ea commodo consequat. \
    Duis aute irure dolor in reprehenderit in voluptate velit esse cillum \
    dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat \
    non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.
    """
}
