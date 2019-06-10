//
//  MergeRequestStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

protocol MergeRequestStorageServiceType: class {
    func createEntity(with mergeRequest: MergeRequest) -> MergeRequestEntity
}

class MergeRequestStorageService: MergeRequestStorageServiceType {
    
    let storage: StorageService
    let mergeRequestMapper: MergeRequestMapper
    let userStorageService: UserStorageService
    let userMapper = UserMapper()
    
    init(storageService: StorageService) {
        self.storage = storageService
        self.userStorageService = UserStorageService(storageService: storageService)
        self.mergeRequestMapper = MergeRequestMapper(with: userMapper)
    }
    
    func createEntity(with mergeRequest: MergeRequest) -> MergeRequestEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.CoreDataEntityCreation.failedMergeRequest.rawValue) }
        let mergeRequestEntity = MergeRequestEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = mergeRequestMapper.mapEntityIntoObject(with: mergeRequest,
                                                                  mergeRequestEntity: mergeRequestEntity)
        
        let assigneeUserEntity = userStorageService.createEntity(with: mergeRequest.assignee)
        let authorUserEntity = userStorageService.createEntity(with: mergeRequest.author)
        
        filledEntity.author = authorUserEntity
        filledEntity.assignee = assigneeUserEntity
        
        return filledEntity
    }
    
    func entityName() -> String {
        return "MergeRequestEntity"
    }
}
