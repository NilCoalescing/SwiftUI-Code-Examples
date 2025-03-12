//
// This is example code for article: https://nilcoalescing.com/blog/SaveCustomCodableTypesInAppStorageOrSceneStorage/
//

import SwiftUI

struct Recipe: Identifiable {
    let id: UUID
    let name: String
    let instructions: String
}

typealias PinnedRecipes = [UUID]

extension PinnedRecipes: @retroactive RawRepresentable {
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder()
                .decode(PinnedRecipes.self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}

struct ContentView: View {
    @AppStorage("pinnedRecipes") var pinnedRecipes = PinnedRecipes()
    
    let recipes = [
        Recipe(
            id: UUID(uuidString: "F4BD08ED-56FD-4343-BD66-78B2A2932CC8")!,
            name: "Chocolate Cake", instructions: "Make a chocolate cake."
        ),
        Recipe(
            id: UUID(uuidString: "5B326712-968E-4032-87A0-F44060A411F7")!,
            name: "Banana Smoothie", instructions: "Make a banana smoothie."
        ),
        Recipe(
            id: UUID(uuidString: "856A059C-22D1-4BCC-BF93-F9C5D98EA5AE")!,
            name: "Pizza", instructions: "Make a pizza."
        ),
        Recipe(
            id: UUID(uuidString: "6149F636-80B3-44E9-9F4B-77E6B4586720")!,
            name: "Apple Crumble", instructions: "Make an Apple Crumble."
        ),
        Recipe(
            id: UUID(uuidString: "232B6A49-59C8-4CC9-A990-AA8E49E668FF")!,
            name: "Scones", instructions: "Make scones."
        ),
        Recipe(
            id: UUID(uuidString: "6545164C-D9A3-445F-BBC6-B4F92073531A")!,
            name: "Potato Gratin", instructions: "Make potato gratin."
        ),
        Recipe(
            id: UUID(uuidString: "970AAF64-F895-4038-B604-2F4BD0FFA6B8")!,
            name: "Sandwiches", instructions: "Make sandwiches."
        )
    ]
    
    var body: some View {
        NavigationView {
            List {
                Section(header: Text("Pinned Recipes")) {
                    ForEach(pinnedRecipes, id: \.self) { id in
                        if let recipe = recipes.first(where: {$0.id == id}) {
                            PinnedRecipeRow(recipe: recipe, pinnedRecipes: $pinnedRecipes)
                        }
                    }
                    
                    if pinnedRecipes.count == 0 {
                        Text("No pinned recipes yet.")
                            .animation(nil)
                            .foregroundColor(.secondary)
                    }
                }
                
                Section(header: Text("My Recipes")) {
                    ForEach(recipes.filter({ !pinnedRecipes.contains($0.id) })) { recipe in
                        RecipeRow(recipe: recipe, pinnedRecipes: $pinnedRecipes)
                    }
                }
            }
            .navigationTitle("Recipes")
        }
    }
}

struct PinnedRecipeRow: View {
    let recipe: Recipe
    @Binding var pinnedRecipes: [UUID]
    
    var body: some View {
        NavigationLink(destination: Text(recipe.instructions)) {
            HStack {
                Text(recipe.name)
                Spacer()
                
                Image(systemName: "pin.fill")
                    .padding()
                    .onTapGesture {
                        withAnimation {
                            if let indexToRemove = pinnedRecipes.firstIndex(of: recipe.id) {
                                pinnedRecipes.remove(at: indexToRemove)
                            }
                        }
                    }
            }
        }
    }
}

struct RecipeRow: View {
    let recipe: Recipe
    @Binding var pinnedRecipes: [UUID]
    
    var body: some View {
        NavigationLink(destination: Text(recipe.instructions)) {
            HStack {
                Text(recipe.name)
                Spacer()
                
                if pinnedRecipes.count < 3 {
                    Image(systemName: "pin")
                        .padding()
                        .onTapGesture {
                            withAnimation {
                                pinnedRecipes.append(recipe.id)
                            }
                        }
                }
            }
        }
    }
}
