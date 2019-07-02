//
//  StorageService.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData
import UIKit

protocol StorageServiceType: class {
    func createFetchRequest(with name: String) -> NSFetchRequest<NSFetchRequestResult>
    func createDeleteRequest(with name: String) -> NSBatchDeleteRequest
    func fetchItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]
    func deleteItem(for object: NSManagedObject) 
    func saveContext()
    var childContext: NSManagedObjectContext { get }
}

class StorageService: StorageServiceType {
    
    private let modelName = "CoreDataModel"
    
    func createFetchRequest(with name: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.entity = NSEntityDescription.entity(forEntityName: name, in: self.childContext)
        request.returnsObjectsAsFaults = false
        request.includesPropertyValues = false
        request.shouldRefreshRefetchedObjects = true
        return request
    }
    
    func createDeleteRequest(with name: String) -> NSBatchDeleteRequest {
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        return deleteRequest
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: modelName)
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("\(GitLabError.Storage.Stack.persistantContainerLoadFailed.rawValue)\(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var childContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func saveContext() {
        let context = self.childContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(GitLabError.Storage.Stack.saveFailed.rawValue)\(nserror.userInfo)")
            }
        }
    }
    
    func fetchItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject] {
        var objects: [NSManagedObject] = []
        
        do {
            guard let results = try self.childContext.fetch(request) as? [NSManagedObject] else { return objects }
            objects = results
        } catch {
            let nserror = error as NSError
            fatalError("\(GitLabError.Storage.Stack.fetchFailed.rawValue)\(nserror.userInfo)")
        }
        return objects
    }
    
    func deleteItem(for object: NSManagedObject) {
        
        do {
            try childContext.delete(object)
            try childContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("\(GitLabError.Storage.Stack.deleteFailed.rawValue)\(nserror.userInfo)")
        }
    }
    
}
