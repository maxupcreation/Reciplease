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

    // MARK: - Initializer

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
        self.managedObjectContext = coreDataStack.mainContext
    }

    // MARK: - Manage func Entity

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
