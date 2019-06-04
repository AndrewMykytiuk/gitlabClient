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
    
    let storage: StorageService
    let mergeRequestStorageService: MergeRequestStorageService
    let projectMapper: ProjectMapper
    
    init(storageService: StorageService) {
        self.storage = storageService
        self.mergeRequestStorageService = MergeRequestStorageService(storageService: storage)
        self.projectMapper = ProjectMapper(with: mergeRequestStorageService.mergeRequestMapper)
    }
    
    func saveProjects() {
        storage.saveContext()
    }
    
    func deleteProjects() {
        let request = storage.createDeleteRequest(with: entityName())
        storage.deleteItems(with: request)
    }
    
    func createEntity(with project: Project) -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(FatalError.CoreDataEntityCreation.failedProject.rawValue) }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: projectEntity)
        return filledEntity
    }
    
    func mapIntoEntities(projects: [Project]) {
        for project in projects {
            let projectEntity = self.createEntity(with: project)
            for mergeRequest in project.mergeRequests {
                let mergeRequestEntity = mergeRequestStorageService.createEntity(with: mergeRequest)
                projectEntity.addToMergeRequests(mergeRequestEntity)
            }
        }
    }
    
    func entityName() -> String {
        return "ProjectEntity"
    }
}
