//
//  Sidebar.swift
//  SplitViewDocumentApp
//
//  Created by Matthaus Woolard on 18/01/2021.
//

import SwiftUI

struct Sidebar: View {
    @Binding
    var notes: [UUID: Note]
    
    var body: some View {
        List(Array(notes.keys)) { id in
            if let note = notes[id] {
                NoteLink(note: Binding {
                    notes[id] ?? note
                } set: { newValue in
                    notes[id] = newValue
                })
            }
        }
        .listStyle(SidebarListStyle()
        ).toolbar {
            #if canImport(UIKit)
            ToolbarItem(placement: .cancellationAction) {
                DismissDocumentButton()
            }
            #endif
            
            ToolbarItem(placement: ToolbarItemPlacement.primaryAction) {
                Button {
                    notes[UUID()] = Note(name: "", content: "")
                } label: {
                    Label("New Note", systemImage: "plus")
                }
            }
        }.navigationTitle("Notes")
    }
}


extension UUID: Identifiable {
    public var id: Self {
        self
    }
}
