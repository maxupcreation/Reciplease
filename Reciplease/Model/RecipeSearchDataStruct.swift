// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import UIKit

// MARK: - Welcome
struct RecipeSearchDataStruct: Decodable {
    let q: String
    let from, to: Int
    let more: Bool
    let count: Int
    let hits: [Hit]
}

// MARK: - Hit
struct Hit: Decodable {
    let recipe: Recipe
    let bookmarked, bought: Bool
}

// MARK: - Recipe
struct Recipe: Decodable {
    
    //Titre de la recette
    let label: String
    
    //URL de l'image
    let image: String
    
    //URL de la recette originale
    let url: String
    
    //Portions
    let yield: Int
    
    //liste d'ingrédient
    let ingredients: [Ingredient]
    
    //temps de préparation
    let totalTime: Int?
    
    // MARK: - Ingredient
    struct Ingredient: Decodable {
        let text: String
        let weight: Double
        let image: String?
    }
}
