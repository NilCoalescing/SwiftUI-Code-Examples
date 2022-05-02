//
//  NoteLink.swift
//  SplitViewDocumentApp
//
//  Created by Matthaus Woolard on 18/01/2021.
//

import SwiftUI

struct NoteLink: View {
    
    @Binding
    var note: Note
    
    var body: some View {
        NavigationLink(
            destination: NoteEditView(note: $note),
            label: {
                if note.name.count > 0 {
                    Label(note.name, systemImage: "note.text")
                } else {
                    Label("Un-named note", systemImage: "note").foregroundColor(.gray)
                }
            }
        )
    }
}
