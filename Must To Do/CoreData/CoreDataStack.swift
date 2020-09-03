//
//  CoreDataStack.swift
//  Must To Do
//
//  Created by Rian Anjasmara on 11/04/20.
//  Copyright © 2020 Rian Anjasmara. All rights reserved.
//

import Foundation
import CoreData

class CoreDataStack {
    var container: NSPersistentContainer{
        let container = NSPersistentContainer(name: "MustToDo")
        container.loadPersistentStores { (description, error) in
            guard error == nil else{
                print("Error: \(error!) ")
                return
            }
        }
        return container
    }
    var managedContext: NSManagedObjectContext {
        return container.viewContext
    }
}
