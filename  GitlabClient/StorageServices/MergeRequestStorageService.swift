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
    func updateMergeRequestEntities(with mergeRequests: [MergeRequest], mergeRequestEntities: [MergeRequestEntity], projectEntity: ProjectEntity)
    var mergeRequestMapper: MergeRequestMapper { get }
}

class MergeRequestStorageService: MergeRequestStorageServiceType {
    
    let storage: StorageServiceType
    let mergeRequestMapper: MergeRequestMapper
    let userStorageService: UserStorageServiceType
    let userMapper = UserMapper()
    
    init(storageService: StorageServiceType) {
        self.storage = storageService
        self.userStorageService = UserStorageService(storageService: storageService)
        self.mergeRequestMapper = MergeRequestMapper(with: userMapper)
    }
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.storage.createFetchRequest(with: self.entityName())
    }
    
    func fetchMergeRequests(with request: NSFetchRequest<NSFetchRequestResult>) -> [MergeRequestEntity] {
        guard let entities = self.storage.fetchItems(with: request) as? [MergeRequestEntity] else { fatalError(GitLabError.Storage.Entity.Downcast.failedMergeRequestEntities.rawValue) }
        return entities
    }
    
    func createEntity(with mergeRequest: MergeRequest) -> MergeRequestEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.Entity.Creation.failedMergeRequest.rawValue) }
        let mergeRequestEntity = MergeRequestEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = mergeRequestMapper.mapEntityIntoObject(with: mergeRequest,
                                                                  mergeRequestEntity: mergeRequestEntity)
        
        let assigneeUserEntity = userStorageService.createEntity(with: mergeRequest.assignee)
        let authorUserEntity = userStorageService.createEntity(with: mergeRequest.author)
        
        filledEntity.author = authorUserEntity
        filledEntity.assignee = assigneeUserEntity
        
        return filledEntity
    }
    
    func updateMergeRequestEntities(with mergeRequests: [MergeRequest], mergeRequestEntities: [MergeRequestEntity], projectEntity: ProjectEntity) {
        let entitiesFromNetwork = self.mapIntoEntities(mergeRequests: mergeRequests)
        
        let updatedIids = self.updatedMergeRequestIids(with: mergeRequests, mergeRequestEntities: mergeRequestEntities)
        
        let filteredStorageIids = mergeRequestEntities.map({Int($0.iid)}).filter({!updatedIids.contains($0)})
        let filteredNetworkIids = mergeRequests.map({$0.iid}).filter({!updatedIids.contains($0)})
        
        self.deleteMergeRequests(with: filteredStorageIids, mergeRequestEntities: mergeRequestEntities, projectEntity: projectEntity)
        self.addMergeRequests(with: filteredNetworkIids, mergeRequestEntities: entitiesFromNetwork, projectEntity: projectEntity)
    }
    
    private func mapIntoEntities(mergeRequests: [MergeRequest]) -> [MergeRequestEntity] {
        var entities: [MergeRequestEntity] = []
        for mergeRequest in mergeRequests {
            let mergeRequestEntity = self.createEntity(with: mergeRequest)
            entities.append(mergeRequestEntity)
        }
        return entities
    }
    
    private func updatedMergeRequestIids(with mergeRequests: [MergeRequest], mergeRequestEntities: [MergeRequestEntity]) -> [Int] {
        var sameIids: [Int] = []
        
        for mergeRequest in mergeRequests {
            if var mergeRequestEntity = mergeRequestEntities.first(where: {$0.iid == mergeRequest.iid}), mergeRequestEntities.count == mergeRequests.count  {
                sameIids.append(mergeRequest.iid)
                mergeRequestEntity = mergeRequestMapper.mapEntityIntoObject(with: mergeRequest, mergeRequestEntity: mergeRequestEntity)
                
                var (assigneeEntity, authorEntity) = mergeRequestMapper.mapUserEntities(from: mergeRequestEntity)
                assigneeEntity = userStorageService.mapEntityIntoObject(with: mergeRequest.assignee, userEntity: assigneeEntity)
                authorEntity = userStorageService.mapEntityIntoObject(with: mergeRequest.author, userEntity: authorEntity)
            }
        }
        storage.saveContext()
        return sameIids
    }
    
    private func deleteMergeRequests(with iids: [Int], mergeRequestEntities: [MergeRequestEntity], projectEntity: ProjectEntity) {
        for iid in iids {
            if let removedMergeRequest = mergeRequestEntities.first(where: {iid == (Int($0.iid))}) {
                projectEntity.removeFromMergeRequests(removedMergeRequest)
            }
        }
        storage.saveContext()
    }
    
    private func addMergeRequests(with iids: [Int], mergeRequestEntities: [MergeRequestEntity], projectEntity: ProjectEntity) {
        for iid in iids {
            if let addedMergeRequest = mergeRequestEntities.first(where: {iid == (Int($0.iid))}) {
                projectEntity.addToMergeRequests(addedMergeRequest)
            }
        }
        storage.saveContext()
    }

    func entityName() -> String {
        return "MergeRequestEntity"
    }
}
