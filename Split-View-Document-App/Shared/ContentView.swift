//
//  ContentView.swift
//  Shared
//
//  Created by Matthaus Woolard on 11/01/2021.
//

import SwiftUI

struct ContentView: View {
    @Binding var document: SplitViewDocumentAppDocument

    var body: some View {
        #if canImport(UIKit)
            NavigationView {
                Sidebar(notes: $document.notes)
                Label("Please Select a Note", systemImage: "exclamationmark.triangle")
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
            .navigationBarHidden(true)
            .modifier(DismissModifier())
        #else
            NavigationView {
                Sidebar(notes: $document.notes)
                Label("Please Select a Note", systemImage: "exclamationmark.triangle")
            }.navigationViewStyle(DoubleColumnNavigationViewStyle())
        #endif
    }
}

