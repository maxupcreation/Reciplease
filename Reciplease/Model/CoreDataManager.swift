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
    
    func createFavorite(label:String,calories:String,image:String,ingredients:String,totalTime:String,yield:String,url:String,starIcone:String){
        let favorite = FavoriteRecipe(context: managedObjectContext)
        favorite.label = label
        favorite.calories = calories
        favorite.image = image
        favorite.ingredients = ingredients
        favorite.totalTime = totalTime
        favorite.yield = yield
        favorite.url = url
        favorite.starIcone = starIcone
        coreDataStack.saveContext()
    }
    
    func deleteFavorite(indexPath : Int){
        let removeFavorite = favorite[indexPath]
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
    
    func deleteAllTasks() {
        person.forEach { managedObjectContext.delete($0) }
        coreDataStack.saveContext()
    }
       
}
