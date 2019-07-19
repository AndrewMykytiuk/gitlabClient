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
    func fetchProjectsEntities(with request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping ([ProjectEntity]) -> Void)
    func saveProjects(_ projects: [Project])
    func projectsFromStorage(completion: @escaping ([Project]) -> Void)
    func updateProjects(_ projects: [Project])
}

class ProjectStorageService: ProjectStorageServiceType {
    
    private let storage: StorageServiceType
    let mergeRequestStorageService: MergeRequestStorageServiceType
    let projectMapper: ProjectMapper
    
    init(storageService: StorageService) {
        self.storage = storageService
        self.mergeRequestStorageService = MergeRequestStorageService(storageService: storageService)
        self.projectMapper = ProjectMapper(with: mergeRequestStorageService.mergeRequestMapper)
    }
    
    func saveProjects(_ projects: [Project]) {
        let _ = self.mapIntoEntities(projects: projects)
        storage.saveContext()
    }
    
    func updateProjects(_ projects: [Project]) {
        let fetchRequest = self.projectFetchRequest()
        self.fetchProjectsEntities(with: fetchRequest, completion: { [weak self] entities in
            guard let welf = self else { return }
            var updatedProjectIds: [Int] = []
            for project in projects {
                if var element = entities.first(where: {$0.id == project.id}) {
                    element = welf.projectMapper.mapEntityIntoObject(with: project, projectEntity: element)
                    let mergeRequestEntities = welf.projectMapper.mergeRequestEntities(from: element)
                    updatedProjectIds.append(project.id)
                    welf.mergeRequestStorageService.updateMergeRequestEntities(with: project.mergeRequests, mergeRequestEntities: mergeRequestEntities, projectEntity: element)
                }
            }
            
            let filteredStorageIds = entities.map({Int($0.id)}).filter({!updatedProjectIds.contains($0)})
            let filteredNetworkIds = projects.map({$0.id}).filter({!updatedProjectIds.contains($0)})
            
            let filteredToAddProjects = projects.map({$0}).filter({filteredNetworkIds.contains($0.id)})
            
            welf.deleteProjects(with: filteredStorageIds)
            welf.addProjects(filteredToAddProjects)
            welf.storage.saveContext()
        })
        
    }
    
    private func projectFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.storage.createFetchRequest(with: self.entityName())
    }
    
    func fetchProjectsEntities(with request: NSFetchRequest<NSFetchRequestResult>, completion: @escaping ([ProjectEntity]) -> Void) {
        DispatchQueue.global().async {
            guard let entities = self.storage.fetchItems(with: request) as? [ProjectEntity] else { fatalError(GitLabError.Storage.Entity.Downcast.failedProjectEntities.rawValue) }
            completion(entities)
        }
    }
    
    private func projectsFromEntities(with entities: [ProjectEntity]) -> [Project] {
        return projectMapper.mapFromEntities(with: entities)
    }
    
    private func deleteProjects(with projectsIds: [Int]) {
        let fetchRequest = self.projectFetchRequest()
        for id in projectsIds {
            fetchRequest.predicate = NSPredicate(format: "id == %d", id)
            self.fetchProjectsEntities(with: fetchRequest, completion: { [weak self] entities in
                guard let welf = self else { return }
                entities.map{(welf.storage.deleteItem(for: $0))}
            })
            
        }
    }
    
    func projectsFromStorage(completion: @escaping ([Project]) -> Void) {
        let fetchRequest = self.projectFetchRequest()
        self.fetchProjectsEntities(with: fetchRequest, completion: { entities in
            let projects = self.projectsFromEntities(with: entities)
            completion(projects)
        })
    }
    
    private func createEntity(with project: Project) -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.Entity.Creation.failedProject.rawValue) }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: projectEntity)
        return filledEntity
    }
    
    private func addProjects(_ projects: [Project]) {
        let _ = self.mapIntoEntities(projects: projects)
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
