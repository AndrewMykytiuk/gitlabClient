//
//  UserStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

protocol UserStorageServiceType: class {
    func createEntity(with user: User) -> UserEntity
    func mapEntityIntoObject(with user: User, userEntity: UserEntity) -> UserEntity
}

class UserStorageService: UserStorageServiceType {
    
    let storage: StorageServiceType
    let userMapper = UserMapper()
    
    init(storageService: StorageServiceType) {
        self.storage = storageService
    }
    
    func createEntity(with user: User) -> UserEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.Entity.Creation.failedProject.rawValue) }
        let userEntity = UserEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = userMapper.mapEntityIntoObject(with: user, userEntity: userEntity)
        return filledEntity
    }
    
    func mapEntityIntoObject(with user: User, userEntity: UserEntity) -> UserEntity {
        return userMapper.mapEntityIntoObject(with: user, userEntity: userEntity)
    }
    
    func entityName() -> String {
        return "UserEntity"
    }
    
}
