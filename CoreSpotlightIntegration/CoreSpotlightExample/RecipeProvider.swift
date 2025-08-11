//
//  RecipeProvider.swift
//  CoreSpotlightExample
//
//  Created by Natalia Panferova on 09/08/2025.
//

import SwiftUI

struct Recipe: Identifiable, Hashable {
    var id: String
    var title: String
    var ingredients: [String]
    
    var imageData: Data? {
        UIImage(named: id)?
            .jpegData(compressionQuality: 1)
    }
}

class RecipeProvider {
    static let shared = RecipeProvider()
    
    let recipes: [Recipe] = [
        Recipe(
            id: "berry-harvest",
            title: "Berry Harvest",
            ingredients: [
                "1 cup strawberries",
                "1/2 cup blueberries",
                "1/2 cup raspberries",
                "1 cup almond milk",
                "1 tablespoon honey"
            ]
        ),
        Recipe(
            id: "banana-milk-shake",
            title: "Banana Milk Shake",
            ingredients: [
                "1 banana",
                "1 cup milk",
                "1 teaspoon vanilla extract",
                "1 tablespoon honey",
                "1/2 cup ice"
            ]
        ),
        Recipe(
            id: "tropical-milk-splash",
            title: "Tropical Milk Splash",
            ingredients: [
                "1 cup pineapple chunks",
                "1 cup mango chunks",
                "1 banana",
                "1 cup milk"
            ]
        ),
        Recipe(
            id: "wild-berry-meadow",
            title: "Wild Berry Meadow",
            ingredients: [
                "1 cup strawberries",
                "1/2 cup blueberries",
                "1/2 cup Greek yogurt",
                "1/2 cup oat milk"
            ]
        ),
        Recipe(
            id: "chocolate-almond-milk",
            title: "Chocolate Almond Milk",
            ingredients: [
                "1 banana",
                "1 tablespoon cocoa powder",
                "1 cup almond milk"
            ]
        ),
        Recipe(
            id: "green-harvest",
            title: "Green Harvest",
            ingredients: [
                "1 apple, chopped",
                "1 cup spinach",
                "1/2 avocado",
                "1 cup coconut water"
            ]
        ),
        Recipe(
            id: "summer-berry-blend",
            title: "Summer Berry Blend",
            ingredients: [
                "1 cup strawberries",
                "1/2 cup blueberries",
                "1/2 cup raspberries",
                "1 cup oat milk"
            ]
        ),
        Recipe(
            id: "spiced-maple-milk",
            title: "Spiced Maple Milk",
            ingredients: [
                "1 cup milk",
                "1/2 teaspoon cinnamon",
                "1 banana",
                "1 tablespoon maple syrup"
            ]
        ),
        Recipe(
            id: "citrus-grove",
            title: "Citrus Grove",
            ingredients: [
                "1 cup orange juice",
                "1/2 cup pineapple chunks",
                "1/2 inch ginger, peeled"
            ]
        ),
        Recipe(
            id: "avocado-matcha",
            title: "Avocado Matcha",
            ingredients: [
                "1/2 avocado",
                "1 teaspoon matcha powder",
                "1 cup almond milk"
            ]
        )
    ]
}
