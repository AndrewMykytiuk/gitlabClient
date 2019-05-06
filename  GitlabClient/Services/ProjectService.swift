//
//  ProjectService.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class ProjectService {
    
    private let networkManager: NetworkManager
    private let projectsManager: ProjectsNetworkService
    private let mergeRequestManager: MergeRequestNetworkService
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.projectsManager = ProjectsNetworkService(networkManager: networkManager)
        self.mergeRequestManager = MergeRequestNetworkService(networkManager: networkManager)
    }
    
    func projectsInfo(completion: @escaping Completion<[Project]>) {
        
        projectsManager.projects { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let projects):
                welf.mergeRequests { result in
                    switch result{
                    case .success(let requests):
                        let data =  welf.setUpProjectsWithMergeRequests(projects,requests)
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
    
    private func setUpProjectsWithMergeRequests(_ projects: [Project], _ requests: [MergeRequest]) -> [Project] {
        
        var entities: [Project] = []
        
        for project in projects {
            var entity = project
            entity.mergeRequest = []
            for request in requests {
                if request.projectId == project.id {
                    entity.mergeRequest?.append(request)
                }
            }
            entities.append(entity)
        }
        return entities
    }
}
