//
//  ProjectService.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class ProjectService {
    
    private let projectsManager: ProjectsNetworkService
    private let mergeRequestManager: MergeRequestNetworkService
    private let projectStorageManager: ProjectStorageService
    
    init(networkManager: NetworkManager, storageService: StorageService) {
        self.projectsManager = ProjectsNetworkService(networkManager: networkManager)
        self.mergeRequestManager = MergeRequestNetworkService(networkManager: networkManager)
        self.projectStorageManager = ProjectStorageService(storageService: storageService)
    }
    
    func projectsInfo(completion: @escaping Completion<[Project]>) {
        
        projectsManager.projects { [weak self] (result) in
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
        
        self.mergeRequestManager.mergeRequests { (requestResult) in
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
            entity.mergeRequest = []
            for request in requests {
                if request.projectId == project.id {
                    entity.mergeRequest.append(request)
                }
            }
            entities.append(entity)
        }
        return entities
    }
    
    func projectsFromDatabase() -> [Project] {
        
        let fetchRequest = projectStorageManager.createFetchRequest()
        let managedObjects = projectStorageManager.storage?.fetchContext(with: fetchRequest) ?? []
        projectStorageManager.projectMapper.mapFromEntities(with: managedObjects)
        
        return []
    }
    
    func saveProjectsToDB(projects: [Project]) {
        projectStorageManager.mapIntoEntities(projects: projects)
        projectStorageManager.saveProjects()
    }
}
