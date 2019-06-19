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
    func fetchItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject]
    func saveProjects(_ projects: [Project])
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult>
    func projectsFromEntities(with entities: [ProjectEntity]) -> [Project]
    func deleteProjects()
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
        self.mapIntoEntities(projects: projects)
        storage.saveContext()
    }
    
    func updateProjects(_ projects: [Project]) {
        let fetchRequest = self.fetchRequest()
        guard var items = self.fetchItems(with: fetchRequest) as? [ProjectEntity] else { fatalError(GitLabError.Storage.CoreDataEntityDowncast.failedProjectEntities.rawValue) }
        
        let projectsFromStorage = self.projectsFromEntities(with: items)
        
        if projectsFromStorage.isEmpty {
            mapIntoEntities(projects: projects)
        }
        
        for project in projects {
            if let row = projectsFromStorage.firstIndex(where: {$0.id == project.id}) {
                items[row] = projectMapper.mapEntityIntoObject(with: project, projectEntity: items[row])
            }
        }
        self.storage.saveContext()
    }
    
    func fetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return self.storage.createFetchRequest(with: self.entityName())
    }
    
    func fetchItems(with request: NSFetchRequest<NSFetchRequestResult>) -> [NSManagedObject] {
        return self.storage.fetchItems(with: request)
    }
    
    func projectsFromEntities(with entities: [ProjectEntity]) -> [Project] {
       return projectMapper.mapFromEntities(with: entities)
    }
    
    func deleteProjects() {
        let request = storage.createDeleteRequest(with: entityName())
        storage.deleteItems(with: request)
    }
    
    func createEntity(with project: Project) -> ProjectEntity {
        guard let entity = NSEntityDescription.entity(forEntityName: entityName(), in: storage.childContext) else { fatalError(GitLabError.Storage.CoreDataEntityCreation.failedProject.rawValue) }
        let projectEntity = ProjectEntity(entity: entity, insertInto: storage.childContext)
        let filledEntity = projectMapper.mapEntityIntoObject(with: project, projectEntity: projectEntity)
        return filledEntity
    }
    
    private func mapIntoEntities(projects: [Project]) {
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
