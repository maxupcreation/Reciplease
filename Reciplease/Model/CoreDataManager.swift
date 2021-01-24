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
    
    //    func returnCoreDataFavorite(name:String) -> Array<Any> {
    //        let recipe = favorite
    //        let stringPredicate = NSPredicate(format: "label == %@", name)
    //        let recipeArray = recipe.filter() { name in stringPredicate.evaluate(with: name)}
    //        return recipeArray
    //    }
    
    func IfRecipeRegisteredThenDeleteFavorite(name:String){
        
        let stringPredicate = NSPredicate(format: "label == %@", name)
        //        var recipeArray = recipe.filter() { name in stringPredicate.evaluate(with: name)}
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "FavoriteRecipe")
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        // Perform the delete operation asynchronously:
        fetchRequest.predicate = stringPredicate
        coreDataStack.mainContext.perform { [self] in
            
            do {
                // Try executing the batch request:
                try coreDataStack.mainContext.execute(batchDeleteRequest)
                if coreDataStack.mainContext.hasChanges {
                    // Reflect the changes if anything changed:
                    coreDataStack.saveContext()
                }
            }
            catch let error {
                // Handle the error here
                print(error)
            }
        }
    }
    
    func createFavorite(label:String,calories:String,image:UIImage,ingredients:[String],totalTime:String,yield:String,url:String){
        let favorite = FavoriteRecipe(context: managedObjectContext)
        favorite.label = label
        favorite.calories = calories
        favorite.image = image.pngData()
        favorite.ingredients = ingredients
        favorite.totalTime = totalTime
        favorite.yield = yield
        favorite.url = url
        
        let image = image.pngData()
        favorite.image = image
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
