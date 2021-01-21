//
//  coreDataManager.swift
//  Obj
//
//  Created by Maxime on 21/12/2020.
//  Copyright © 2020 Maxime. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataManager {

    // MARK: - Properties

    private let coreDataStack: CoreDataStack
    private let managedObjectContext: NSManagedObjectContext

    
    var person: [Person] {
        let request: NSFetchRequest<Person> = Person.fetchRequest()
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let person = try? managedObjectContext.fetch(request) else { return [] }
        return person
    }
    
    var favorite: [FavoriteRecipe] {
        let request: NSFetchRequest<FavoriteRecipe> = FavoriteRecipe.fetchRequest()
        //request.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        guard let favorite = try? managedObjectContext.fetch(request) else { return [] }
        return favorite
    }
    
    var commitPredicate = NSPredicate?.self

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage func Entity
    
    func isRecipeRegistered(name:String) -> Bool {
        //Récuperer les recettes
        let recipe = favorite
        //Appliquer un filtre (filtrer par nom) NSpredicate
        let stringPredicate = NSPredicate(format: "label == %@", name)
        //Executer la requête, je récupére un tableau
        let recipeArray = recipe.filter() { name in stringPredicate.evaluate(with: name)}
        if recipeArray.isEmpty { return false } else { return true }
        // si il est vide, renvoi false, si il contient un element, true
        // même principe pour la suppression.
    }
    
    
    
    func createFavorite(label:String,calories:String,image:String,ingredients:String,totalTime:String,yield:String,url:String){
        let favorite = FavoriteRecipe(context: managedObjectContext)
        favorite.label = label
        favorite.calories = calories
        //favorite.image = image
       // favorite.ingredients = ingredients
        favorite.totalTime = totalTime
        favorite.yield = yield
        favorite.url = url
        coreDataStack.saveContext()
    }
    
    func deleteFavorite(){
        let removeFavorite = favorite.last!
        managedObjectContext.delete(removeFavorite)
        coreDataStack.saveContext()
    }

    func createIngredients(ingredient: String) {
        let person = Person(context: managedObjectContext)
        person.ingredients = ingredient
        coreDataStack.saveContext()
    }
    
    func deleteTasks(indexPath : IndexPath) {
        let removeCellHomeTasksIndexPath = person[indexPath.row]
        managedObjectContext.delete(removeCellHomeTasksIndexPath)
        coreDataStack.saveContext()
    }
    
    func deleteAllIgredient() {
        person.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
       
}
