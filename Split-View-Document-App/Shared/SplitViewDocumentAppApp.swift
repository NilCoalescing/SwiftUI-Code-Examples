//
//  SplitViewDocumentAppApp.swift
//  Shared
//
//  Created by Matthaus Woolard on 11/01/2021.
//

import SwiftUI

@main
struct SplitViewDocumentAppApp: App {
    var body: some Scene {
        DocumentGroup(newDocument: SplitViewDocumentAppDocument()) { file in
            ContentView(document: file.$document)
        }
    }
}
