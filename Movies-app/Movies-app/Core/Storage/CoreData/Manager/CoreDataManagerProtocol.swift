//
//  CoreDataManagerProtocol.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import CoreData

protocol CoreDataManagerProtocol {
   var viewContext: NSManagedObjectContext { get }
   func saveContext() throws
   func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T]
   func delete(_ object: NSManagedObject)
}
