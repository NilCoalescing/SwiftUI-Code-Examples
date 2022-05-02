//
//  SplitViewDocumentAppDocument.swift
//  Shared
//
//  Created by Matthaus Woolard on 11/01/2021.
//

import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var exampleText: UTType {
        UTType(importedAs: "com.example.plain-text")
    }
}

struct Note: Codable {
    var name: String
    var content: String
    var rating: UInt? = nil
}

struct SplitViewDocumentAppDocument: FileDocument {
    var notes: [UUID: Note] = [:]

    static var readableContentTypes: [UTType] { [.exampleText] }

    init() {}
    
    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        
        self.notes = try JSONDecoder().decode([UUID: Note].self, from: data)
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = try JSONEncoder().encode(self.notes)
        return .init(regularFileWithContents: data)
    }
}


