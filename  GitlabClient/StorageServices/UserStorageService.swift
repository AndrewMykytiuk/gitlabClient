//
//  UserStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class UserStorageService {
    
    let storage: StorageService!
    
    init(storageService: StorageService) {
        self.storage = storageService
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
    }
    
    func createEntity() -> UserEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: "UserEntity", in: storage.managedContext) else { return UserEntity() }
        let userEntity = UserEntity(entity: entity, insertInto: storage.managedContext)
        return userEntity
    }
}
