//
//  SearchReindexing.swift
//  SearchReindexing
//
//  Created by Natalia Panferova on 11/08/2025.
//

import CoreSpotlight

class SearchReindexing: CSIndexExtensionRequestHandler {
    
    private func searchableItems(for recipes: [Recipe]) -> [CSSearchableItem] {
        recipes.map { recipe in
            let attributeSet = CSSearchableItemAttributeSet(
                contentType: .content
            )
            attributeSet.title = recipe.title
            attributeSet.thumbnailData = recipe.imageData
            
            return CSSearchableItem(
                uniqueIdentifier: recipe.id,
                domainIdentifier: nil,
                attributeSet: attributeSet
            )
        }
    }

    override func searchableIndex(
        _ searchableIndex: CSSearchableIndex,
        reindexAllSearchableItemsWithAcknowledgementHandler acknowledgementHandler: @escaping () -> Void
    ) {
        let items = searchableItems(for: RecipeProvider.shared.recipes)
        
        searchableIndex.indexSearchableItems(items) { error in
            // handle possible errors
            acknowledgementHandler()
        }
    }

    override func searchableIndex(
        _ searchableIndex: CSSearchableIndex,
        reindexSearchableItemsWithIdentifiers identifiers: [String],
        acknowledgementHandler: @escaping () -> Void
    ) {
        let items = searchableItems(
            for: RecipeProvider.shared.recipes
                .filter { identifiers.contains($0.id) }
        )
        
        searchableIndex.indexSearchableItems(items) { error in
            // handle possible errors
            acknowledgementHandler()
        }
    }

    override func data(
        for searchableIndex: CSSearchableIndex,
        itemIdentifier: String, typeIdentifier: String
    ) throws -> Data {
        return Data()
    }

    override func fileURL(
        for searchableIndex: CSSearchableIndex,
        itemIdentifier: String, typeIdentifier: String,
        inPlace: Bool
    ) throws -> URL {
        return URL(fileURLWithPath: "")
    }
    
    override func searchableIndexDidThrottle(_ searchableIndex: CSSearchableIndex) {
    }

    override func searchableIndexDidFinishThrottle(_ searchableIndex: CSSearchableIndex) {
    }
}
