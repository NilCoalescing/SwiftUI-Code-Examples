//
//  NoteEditView.swift
//  SplitViewDocumentApp
//
//  Created by Matthaus Woolard on 18/01/2021.
//

import SwiftUI

struct NoteEditView: View {
    @Binding
    var note: Note
    
    var body: some View {
        Form {
            TextField("Title", text: $note.name)
            TextEditor(text: $note.content)
        }
    }
}
