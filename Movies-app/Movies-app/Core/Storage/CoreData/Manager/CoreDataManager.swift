//
//  CoreDataManager.swift
//  Movies-app
//
//  Created by Oleh on 30.11.2024.
//

import CoreData
import OSLog

final class CoreDataManager: CoreDataManagerProtocol {
    
    private let container: NSPersistentContainer
    private let persistentContainerName = "AppDataModel"
    private let logger = Logger(subsystem: "CoreDataManager", category: "Storage")
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }

    init() {
        container = NSPersistentContainer(name: persistentContainerName)
        
        container.loadPersistentStores { description, error in
            if let error {
                self.logger.error("Core Data failed to load: \(error.localizedDescription)")
                #if DEBUG
                self.logger.debug("Persistent store description: \(description)")
                self.logger.debug("Detailed error: \(error)")
                #endif
            } else {
                self.logger.info("Core Data loaded successfully")
            }
        }
        
        setupViewContext()
    }
    
    // MARK: - Private Methods
    private func setupViewContext() {
        viewContext.automaticallyMergesChangesFromParent = true
        viewContext.mergePolicy = NSMergeByPropertyStoreTrumpMergePolicy
    }
    
    // MARK: - Public Methods
    func saveContext() throws {
        guard viewContext.hasChanges else { return }
        try viewContext.save()
    }
    
    func fetch<T: NSManagedObject>(_ request: NSFetchRequest<T>) throws -> [T] {
        try viewContext.fetch(request)
    }
    
    func delete(_ object: NSManagedObject) {
        viewContext.delete(object)
    }
}
