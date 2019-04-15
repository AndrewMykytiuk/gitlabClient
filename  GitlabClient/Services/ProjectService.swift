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
    
    func getProjectsInfo(completion: @escaping (Result<[Project:[MergeRequest]]>) -> Void) {
        
        var dictionary: [Project:[MergeRequest]] = [:]
        
        projectsManager.getProjects { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let projects):
                for project in projects {
                    welf.mergeRequestManager.getMergeRequests(id: project.id) { (requestResult) in
                        switch requestResult {
                        case .success(let values):
                            dictionary[project] = values
                            completion(.success(dictionary))
                        case .error(let error):
                            completion(.error(error))
                        }
                    }
                }
            case .error(let error):
                completion(.error(error))
            }
        }
        
    }
    
}
