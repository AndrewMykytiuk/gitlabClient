//
//  MergeRequestStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class MergeRequestStorageService {
    
    let storage: StorageService!
    
    init(storageService: StorageService) {
        self.storage = storageService
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "MergeRequestEntity")
    }
    
    func createEntity() -> MergeRequestEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: "MergeRequestEntity", in: storage.managedContext) else { return MergeRequestEntity() }
        let mergeRequestEntity = MergeRequestEntity(entity: entity, insertInto: storage.managedContext)
        return mergeRequestEntity
    }
}
