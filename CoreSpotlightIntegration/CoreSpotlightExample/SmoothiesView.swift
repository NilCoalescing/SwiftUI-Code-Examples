//
//  SmoothiesView.swift
//  CoreSpotlightExample
//
//  Created by Natalia Panferova on 11/08/2025.
//

import SwiftUI
import CoreSpotlight

struct SmoothiesView: View {
    @State private var navigationPath: [Recipe] = []
    
    private let recipes = RecipeProvider.shared.recipes
    
    @State private var searchText = ""
    @State private var filteredRecipes: [Recipe] = []
    @State private var queryItems: [CSUserQuery.Item] = []
    
    var recipesToDisplay: [Recipe] {
        searchText.isEmpty ? recipes : filteredRecipes
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            List(recipesToDisplay) { recipe in
                NavigationLink(value: recipe) {
                    RecipeRow(recipe: recipe)
                }
            }
            .navigationTitle("Smoothies")
            .navigationDestination(for: Recipe.self) { recipe in
                RecipeView(recipe: recipe)
            }
        }
        .onContinueUserActivity(
            CSSearchableItemActionType
        ) { activity in
            if let uniqueIdentifier = activity.userInfo?[
                CSSearchableItemActivityIdentifier
            ] as? String {
                navigateToRecipe(withID: uniqueIdentifier)
            }
        }
        
        .searchable(text: $searchText)
        .onAppear {
            CSUserQuery.prepare()
        }
        .task(id: searchText) {
            guard !searchText.isEmpty else { return }
            try? await Task.sleep(for: .seconds(0.3))
            
            let context = CSUserQueryContext()
            context.enableRankedResults = true
            
            let query = CSUserQuery(
                userQueryString: searchText,
                userQueryContext: context
            )
            
            queryItems = []
            
            do {
                for try await element in query.responses {
                    switch(element) {
                    case .item(let item):
                        queryItems.append(item)
                    case .suggestion(let suggestion):
                        let str = suggestion.suggestion.localizedAttributedSuggestion
                        print("Got a suggestion: \(str)")
                    @unknown default: break
                    }
                }
            } catch {
                // handle possible errors
            }
            
            queryItems.sort { first, second in
                first.item.compare(byRank: second.item) == .orderedAscending
            }
            
            filteredRecipes = queryItems.compactMap { item in
                recipes.first(
                    where: { $0.id == item.item.uniqueIdentifier }
                )
            }
        }
        .onChange(of: navigationPath) { oldValue, newValue in
            guard
                !searchText.isEmpty,
                let selection = newValue.first,
                let item = queryItems.first(
                    where: {
                        $0.item.uniqueIdentifier == selection.id
                    }
                )
            else { return }
            
            let query = CSUserQuery(
                userQueryString: searchText,
                userQueryContext: nil
            )
            
            query.userEngaged(
                item, visibleItems: queryItems,
                interaction: .select
            )
        }
    }
    
    private func navigateToRecipe(withID id: String) {
        if let recipe = recipes.first(where: { $0.id == id }) {
            var transaction = Transaction(animation: .none)
            transaction.disablesAnimations = true
            withTransaction(transaction) {
                navigationPath = [recipe]
            }
        }
    }
}
