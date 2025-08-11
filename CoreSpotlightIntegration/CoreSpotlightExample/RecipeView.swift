//
//  RecipeView.swift
//  CoreSpotlightExample
//
//  Created by Natalia Panferova on 11/08/2025.
//

import SwiftUI
import CoreSpotlight

struct RecipeView: View {
    let recipe: Recipe
    
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Image(recipe.id)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.capsule)
                    .frame(width: 100)
                
                Text(recipe.title)
                    .font(.largeTitle)
                
                VStack(spacing: 12) {
                    ForEach(recipe.ingredients, id: \.self) { ingredient in
                        Text(ingredient)
                    }
                }
                .font(.headline)

            }
            .multilineTextAlignment(.center)
            .padding()
        }
        .onAppear {
            let attributeSet = CSSearchableItemAttributeSet(contentType: .content)
            attributeSet.title = recipe.title
            attributeSet.thumbnailData = recipe.imageData
            attributeSet.lastUsedDate = Date()
            
            let item = CSSearchableItem(
                uniqueIdentifier: recipe.id,
                domainIdentifier: nil,
                attributeSet: attributeSet
            )
            
            item.isUpdate = true
            let index = CSSearchableIndex(name: "SpotlightSearchExample")
            index.indexSearchableItems([item])
        }
    }
}
