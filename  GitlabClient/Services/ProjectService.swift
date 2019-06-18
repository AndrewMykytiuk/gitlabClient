//
//  ProjectService.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol ProjectServiceType: class {
    func projectsInfo(completion: @escaping Completion<[Project]>)
    func projectsFromStorage() -> [Project]
    func updateProjects(projects: [Project])
}

class ProjectService: ProjectServiceType {
    
    private let projectsNetworkService: ProjectsNetworkServiceType
    private let mergeRequestNetworkService: MergeRequestNetworkServiceType
    private let projectStorageService: ProjectStorageServiceType
    
    init(networkManager: NetworkManager, storageService: StorageService) {
        self.projectsNetworkService = ProjectsNetworkService(networkManager: networkManager)
        self.mergeRequestNetworkService = MergeRequestNetworkService(networkManager: networkManager)
        self.projectStorageService = ProjectStorageService(storageService: storageService)
    }
    
    func projectsInfo(completion: @escaping Completion<[Project]>) {
        
        projectsNetworkService.projects { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let projects):
                welf.mergeRequests { result in
                    switch result{
                    case .success(let requests):
                        let data =  welf.processedProjects(with: projects,and: requests)
                        completion(.success(data))
                    case .error(let error):
                        completion(.error(error))
                    }
                }
            case .error(let error):
                completion(.error(error))
            }
        }
        
    }
    
    private func mergeRequests(completion: @escaping Completion<[MergeRequest]>) {
        
        mergeRequestNetworkService.mergeRequests { (requestResult) in
            switch requestResult {
            case .success(let values):
                completion(.success(values))
            case .error(let error):
                completion(.error(error))
            }
        }
        
    }
    
    private func processedProjects(with projects: [Project], and requests: [MergeRequest]) -> [Project] {
        
        var entities: [Project] = []
        
        for project in projects {
            var entity = project
            entity.mergeRequests = []
            for request in requests {
                if request.projectId == project.id {
                    entity.mergeRequests.append(request)
                }
            }
            entities.append(entity)
        }
        return entities
    }
    
    func projectsFromStorage() -> [Project] {
        
        let fetchRequest = projectStorageService.fetchRequest()
        let managedObjects = projectStorageService.fetchItems(with: fetchRequest)
        guard let entities = managedObjects as? [ProjectEntity] else { fatalError(GitLabError.Storage.CoreDataEntityDowncast.failedProjectEntities.rawValue) }
        let projects = projectStorageService.fetchProjects(with: entities)
        
        return projects
    }
    
    func updateProjects(projects: [Project]) {
        projectStorageService.updateProjects(projects)
    }
    
    func saveProjects(projects: [Project]) {
        projectStorageService.saveProjects(projects)
    }
    
    func deleteProjects() {
        projectStorageService.deleteProjects()
    }
}
