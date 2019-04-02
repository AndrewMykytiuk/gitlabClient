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
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.projectsManager = ProjectsNetworkService(networkManager: networkManager)
    }
    
    func getProjects(completion: @escaping (Result<Project>) -> Void) {
        
        projectsManager.getProjects { (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .error(let error):
                completion(.error(error))
            }
        }
        
    }
    
}
