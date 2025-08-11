//
//  CoreSpotlightExampleApp.swift
//  CoreSpotlightExample
//
//  Created by Natalia Panferova on 09/08/2025.
//

import SwiftUI
import CoreSpotlight

@main
struct CoreSpotlightExampleApp: App {
    var body: some Scene {
        WindowGroup {
            SmoothiesView()
                .task {
                    await indexAppContent()
                }
        }
    }
    
    private func indexAppContent() async {
        let items = RecipeProvider.shared.recipes.map { recipe in
            let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
            attributeSet.title = recipe.title
            attributeSet.thumbnailData = recipe.imageData
            
            return CSSearchableItem(
                uniqueIdentifier: recipe.id,
                domainIdentifier: nil,
                attributeSet: attributeSet
            )
        }
        
        let index = CSSearchableIndex(name: "SpotlightSearchExample")
        
        if
            let clientState = try? await index.fetchLastClientState(),
            let indexData = try? JSONDecoder().decode(
                SearchIndexData.self, from: clientState
            )
        {
            print("Search index exists, created on: \(indexData.date)")
        } else if
            let newData = try? JSONEncoder().encode(
                SearchIndexData(date: Date())
            )
        {
            do {
                index.beginBatch()
                try await index.indexSearchableItems(items)
                try await index.endBatch(withClientState: newData)
            } catch {
                print("Error indexing content: \(error.localizedDescription)")
            }
        }
    }
}

struct SearchIndexData: Codable {
    let date: Date
}
