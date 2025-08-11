//
//  RecipeRow.swift
//  CoreSpotlightExample
//
//  Created by Natalia Panferova on 11/08/2025.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    
    var body: some View {
        HStack {
            Image(recipe.id)
                .resizable()
                .scaledToFit()
                .frame(width: 60)
                .clipShape(.ellipse)
            
            Text(recipe.title)
                .font(.headline)
        }
    }
}
