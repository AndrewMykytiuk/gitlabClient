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
    func fetchProjectsEntities(with request: NSFetchRequest<NSFetchRequestResult>) -> [ProjectEntity]
    func saveProjects(_ projects: [Project])
    func projectFetchRequest() -> NSFetchRequest<NSFetchRequestResult>
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
        let fetchRequest = self.projectFetchRequest()
        let entities = self.fetchProjectsEntities(with: fetchRequest)
        var updatedProjectIds: [Int] = []
        for project in projects {
            //Compare projects as entities from Storage and Network
            if var element = entities.first(where: {$0.id == project.id}), projects.count == entities.count {
                element = projectMapper.mapEntityIntoObject(with: project, projectEntity: element)
                let mergeRequestEntities = projectMapper.mergeRequestEntities(from: element)
                updatedProjectIds.append(project.id)
                mergeRequestStorageService.updateMergeRequestEntities(with: project.mergeRequests, mergeRequestEntities: mergeRequestEntities, projectEntity: element)
            }
        }
        
        let filteredStorageIds = entities.map({Int($0.id)}).filter({!updatedProjectIds.contains($0)})
        let filteredNetworkIds = projects.map({$0.id}).filter({!updatedProjectIds.contains($0)})
        
        self.deleteProjects(with: filteredStorageIds)
        self.addProjects(with: filteredNetworkIds, projectEntities: projects)
        self.storage.saveContext()
        
    }
    
    func projectFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.storage.createFetchRequest(with: self.entityName())
    }
    
    func fetchProjectsEntities(with request: NSFetchRequest<NSFetchRequestResult>) -> [ProjectEntity] {
        guard let entities = self.storage.fetchItems(with: request) as? [ProjectEntity] else { fatalError(GitLabError.Storage.Entity.Downcast.failedProjectEntities.rawValue) }
        return entities
    }
    
    func projectsFromEntities(with entities: [ProjectEntity]) -> [Project] {
       return projectMapper.mapFromEntities(with: entities)
    }
    
    func deleteProjects(with projectsIds: [Int]) {
        let fetchRequest = self.projectFetchRequest()
        for id in projectsIds {
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            let entities = self.fetchProjectsEntities(with: fetchRequest)
            entities.map{(storage.deleteItem(for: $0))}
        }
    }
    
    func createEntity(with project: Project) -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.Entity.Creation.failedProject.rawValue) }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: projectEntity)
        return filledEntity
    }
    
    private func addProjects(with ids: [Int], projectEntities: [Project]) {
        var addedProjects: [Project] = []
        for id in ids {
            if let addedProject = projectEntities.first(where: {id == (Int($0.id))}) {
               addedProjects.append(addedProject)
            }
        }
        let _ = self.mapIntoEntities(projects: addedProjects)
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
