//
//  ProjectStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

protocol ProjectStorageServiceType {
    func fetchProjects(with request: NSFetchRequest<NSFetchRequestResult>) -> [ProjectEntity]
    func saveProjects(_ projects: [Project])
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    func projectsFromEntities(with entities: [ProjectEntity]) -> [Project]
    func updateProjects(_ projects: [Project])
}

class ProjectStorageService: ProjectStorageServiceType {
    
    private let storage: StorageServiceType
    let mergeRequestStorageService: MergeRequestStorageServiceType
    let projectMapper: ProjectMapper
    
    init(storageService: StorageService) {
        self.storage = storageService
        self.mergeRequestStorageService = MergeRequestStorageService(storageService: storage)
        self.projectMapper = ProjectMapper(with: mergeRequestStorageService.mergeRequestMapper)
    }
    
    func saveProjects(_ projects: [Project]) {
        let _ = self.mapIntoEntities(projects: projects)
        storage.saveContext()
    }
    
    func updateProjects(_ projects: [Project]) {
        let fetchRequest = self.fetchRequest()
        let items = self.fetchProjects(with: fetchRequest)
        var projectIds: [Int] = []
        for project in projects {
            if var element = items.first(where: {$0.id == project.id}), projects.count == items.count {
                element = projectMapper.mapEntityIntoObject(with: project, projectEntity: element)
                let mergeRequestEntities = projectMapper.mergeRequestEntities(from: element)
                
                mergeRequestStorageService.updateMergeRequestEntities(with: project.mergeRequests, mergeRequestEntities: mergeRequestEntities, projectEntity: element)
            } else {
                projectIds = items.map{(Int($0.id))}
            }
        }
        if !projectIds.isEmpty {
            self.deleteProjects(with: projectIds)
            self.saveProjects(projects)
        } else {
            self.storage.saveContext()
        }
    }
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.storage.createFetchRequest(with: self.entityName())
    }
    
    func fetchProjects(with request: NSFetchRequest<NSFetchRequestResult>) -> [ProjectEntity] {
        guard let entities = self.storage.fetchItems(with: request) as? [ProjectEntity] else { fatalError(GitLabError.Storage.Entity.Downcast.failedProjectEntities.rawValue) }
        return entities
    }
    
    func projectsFromEntities(with entities: [ProjectEntity]) -> [Project] {
       return projectMapper.mapFromEntities(with: entities)
    }
    
    func deleteProjects(with projectsIds: [Int]) {
        let fetchRequest = self.fetchRequest()
        for id in projectsIds {
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            let items = self.fetchProjects(with: fetchRequest)
            items.map{(storage.deleteItem(for: $0))}
        }
    }
    
    func createEntity(with project: Project) -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.Entity.Creation.failedProject.rawValue) }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: projectEntity)
        return filledEntity
    }
    
    private func mapIntoEntities(projects: [Project]) -> [ProjectEntity] {
        var entities: [ProjectEntity] = []
        for project in projects {
            let projectEntity = self.createEntity(with: project)
            for mergeRequest in project.mergeRequests {
                let mergeRequestEntity = mergeRequestStorageService.createEntity(with: mergeRequest)
                projectEntity.addToMergeRequests(mergeRequestEntity)
                entities.append(projectEntity)
            }
        }
        return entities
    }
    
    func entityName() -> String {
        return "ProjectEntity"
    }
}
