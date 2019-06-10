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

protocol StorageServiceDelegate: class {
    func saveContext() 
    func fetchItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]
    func deleteItems(with deleteRequest: NSBatchDeleteRequest)
}

protocol StorageServiceType: class {
    func createFetchRequest(with name: String) -> NSFetchRequest<NSFetchRequestResult>
    func createDeleteRequest(with name: String) -> NSBatchDeleteRequest
}

class StorageService: StorageServiceType, StorageServiceDelegate {
    
    private let modelName = "CoreDataModel"
    
    func createFetchRequest(with name: String) -> NSFetchRequest<NSFetchRequestResult> {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: name)
        request.entity = NSEntityDescription.entity(forEntityName: name, in: self.childContext)
        request.returnsObjectsAsFaults = false
        request.includesPropertyValues = false
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
                fatalError("\(GitLabError.CoreDataStack.persistantContainerLoadFailed.rawValue)\(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var childContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
    }()
    
    func saveContext () {
        let context = self.childContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("\(GitLabError.CoreDataStack.saveFailed.rawValue)\(nserror.userInfo)")
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
            fatalError("\(GitLabError.CoreDataStack.fetchFailed.rawValue)\(nserror.userInfo)")
        }
        return objects
    }
    
    func deleteItems(with deleteRequest: NSBatchDeleteRequest) {
        
        do {
            try childContext.execute(deleteRequest)
            try childContext.save()
        } catch {
            let nserror = error as NSError
            fatalError("\(GitLabError.CoreDataStack.deleteFailed.rawValue)\(nserror.userInfo)")
        }
    }
    
}
