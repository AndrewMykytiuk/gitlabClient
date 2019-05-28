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
    func saveContext(storageService: StorageService)
}

class StorageService {
    
//    static let sharedManager = StorageService()
    
    init() {
        
    }
    
//    lazy var applicationDocumentsDirectory: NSURL = {
//        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
//        return urls[urls.count-1] as NSURL
//    }()
//
//    func entityForName(_ entityName: String) -> NSEntityDescription {
//        return NSEntityDescription.entity(forEntityName: entityName, in: StorageService.sharedManager.managedContext)!
//    }
//
//    lazy var managedObjectModel: NSManagedObjectModel = {
//        let modelURL = Bundle.main.url(forResource: "GitlabClient", withExtension: "momd")!
//        return NSManagedObjectModel(contentsOf: modelURL)!
//    }()
//
//    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
//        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
//        let url = self.applicationDocumentsDirectory.appendingPathComponent("SingleViewCoreData.sqlite")
//        var failureReason = "There was an error creating or loading the application's saved data."
//        do {
//            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
//        } catch {
//            var dict = [String: AnyObject]()
//            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject
//            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject
//            dict[NSUnderlyingErrorKey] = error as NSError
//            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
//            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
//            abort()
//        }
//        return coordinator
//    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "CoreDataModel")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    lazy var managedContext: NSManagedObjectContext = {
        return self.persistentContainer.viewContext
        }()
    
    func saveContext () {
        let context = self.managedContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchContext(with request:NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject] {
        let result: [NSManagedObject] = []
        request.returnsObjectsAsFaults = false
        do {
            var result = try self.managedContext.fetch(request)
            result = result as! [NSManagedObject]
        } catch {
            print("Failed")
        }
        return result
    }
}
