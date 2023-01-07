import SwiftUI

@main
struct CustomizableToolbarOnIPadApp: App {
    @StateObject var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
        }
    }
}

struct ContentView: View {
    @StateObject private var sceneState = SceneState()
    @EnvironmentObject var appState: AppState
    
    var body: some View {
        NavigationSplitView {
            NoteList()
        } detail: {
            ZStack {
                if let selection = sceneState.selectedNoteId {
                    NoteView(
                        text: $appState.notes[selection].text
                    )
                    .navigationTitle("Note \(appState.notes[selection].id + 1)")
                    .navigationBarTitleDisplayMode(.inline)
                } else {
                    Text("Nothing selected")
                }
            }
            .padding()
        }
        .environmentObject(sceneState)
    }
}

struct NoteList: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var sceneState: SceneState
    
    var body: some View {
        List(
            appState.notes,
            selection: $sceneState.selectedNoteId
        ) { note in
            NavigationLink(value: note.id) {
                Text("Note \(note.id + 1)")
            }
        }
        .toolbar {
            ToolbarItem(placement: .bottomBar) {
                HStack {
                    Button {
                        let newNote = Note(text: "", id: appState.notes.count)
                        appState.notes.append(newNote)
                        sceneState.selectedNoteId = newNote.id
                    } label: {
                        Label("New Note", systemImage: "plus")
                            .labelStyle(.titleAndIcon)
                    }
                }
            }
        }
    }
}

struct NoteView: View {
    @Binding var text: String
    
    var body: some View {
        TextEditor(text: $text)
            .toolbar(id: "note") {
                ToolbarItem(id: "favorite", placement: .secondaryAction) {
                    FavoriteButton()
                }
                ToolbarItem(id: "tag", placement: .secondaryAction) {
                    TagButton()
                }
                ToolbarItem(id: "image", placement: .secondaryAction) {
                    ControlGroup {
                        AddPhotoButton()
                        AddDocumentScanButton()
                    }
                }
                ToolbarItem(
                    id: "Find", placement: .secondaryAction,
                    showsByDefault: false
                ) {
                    FindButton()
                }
            }
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    ShareButton()
                }
            }
            .toolbarRole(.editor)
    }
}

struct ShareButton: View {
    @EnvironmentObject var sceneState: SceneState
    @EnvironmentObject var appState: AppState

    var text: String {
        if let selection = sceneState.selectedNoteId {
            return appState.notes[selection].text
        }
        return ""
    }

    var body: some View {
        ShareLink("Share", item: text)
    }
}

struct FindButton: View {
    var body: some View {
        Button {
            // show find and replace UI
        } label: {
            Label("Find and replace", systemImage: "magnifyingglass")
        }
    }
}

struct FavoriteButton: View {
    var body: some View {
        Button {
            // add selected note to favorites
        } label: {
            Label("Favorite", systemImage: "star")
        }
    }
}

struct TagButton: View {
    var body: some View {
        Button {
            // add a tag for selected note
        } label: {
            Label("Add Tag", systemImage: "number")
        }
    }
}

struct AddPhotoButton: View {
    var body: some View {
        Button {
            // present photos picker UI
        } label: {
            Label("Choose Photo", systemImage: "photo.on.rectangle")
        }
    }
}

struct AddDocumentScanButton: View {
    var body: some View {
        Button {
            // present document scanner UI
        } label: {
            Label("Scan Document", systemImage: "doc.viewfinder")
        }
    }
}

class SceneState: ObservableObject {
    @Published var selectedNoteId: Int?
}

class AppState: ObservableObject {
    @Published var notes: [Note] = []
}

struct Note: Identifiable {
    var text: String
    var id: Int
    var tags: [String] = []
}
