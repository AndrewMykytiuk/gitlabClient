//
//  ProjectStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class ProjectStorageService {
    
    let storage: StorageService!
    let projectMapper: ProjectMapper!
    let mergeRequestMapper: MergeRequestMapper!
    let userMapper: UserMapper!
    
    init(storageService: StorageService) {
        self.storage = storageService
        self.userMapper = UserMapper()
        self.mergeRequestMapper = MergeRequestMapper(with: self.userMapper)
        self.projectMapper = ProjectMapper(with: self.mergeRequestMapper)
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectEntity")
    }
    
    func saveProjects() {
        storage.saveContext()
    }
    
    func createEntity() -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: "ProjectEntity", in: storage.managedContext) else { return ProjectEntity() }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.managedContext)
        return projectEntity
    }
    
    func mapIntoEntities(projects: [Project]) {
        let mergeRequestStorageService = MergeRequestStorageService(storageService: storage)
        let userStorageService = UserStorageService(storageService: storage)
        var projectEntities: [ProjectEntity] = []
        for project in projects {
            let projectEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: self.createEntity())
            var mergeRequestEntities: [MergeRequestEntity] = []
            for mergeRequest in project.mergeRequest {
                let mergeRequestEntity = mergeRequestMapper.mapEntityIntoObject(with: mergeRequest, mergeRequestEntity: mergeRequestStorageService.createEntity())
                let assigneeUserEntity = userMapper.mapEntityIntoObject(with: mergeRequest.assignee, userEntity: userStorageService.createEntity())
                let authorUserEntity = userMapper.mapEntityIntoObject(with: mergeRequest.author, userEntity: userStorageService.createEntity())
                
                
                //mergeRequestEntity.assignee = assigneeUserEntity
                
                //mergeRequestEntity.author = authorUserEntity
                mergeRequestEntity.managedObjectContext?.performAndWait {
                    mergeRequestEntity.addToToUser(authorUserEntity)
                    mergeRequestEntity.addToToUser(assigneeUserEntity)
                    mergeRequestEntities.append(mergeRequestEntity)
                }
                projectEntity.managedObjectContext?.performAndWait {
                projectEntity.addToToMergeRequest(mergeRequestEntity)
                }
            }
            
            //projectEntity.mergeRequests = mergeRequestEntities as? NSObject
            projectEntities.append(projectEntity)
            
        }
        //StorageService.sharedManager.saveContext()
    }
}
