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
    
    func getProjectsInfo(completion: @escaping (Result<[Project]>) -> Void) {

        projectsManager.getProjects { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let projects):
                welf.getMergeRequestsOfProjects(projects) { result in
                    switch result{
                    case .success(let data):
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
    
    private func getMergeRequestsOfProjects(_ projects: [Project], completion: @escaping (Result<[Project]>) -> Void) {
        
        var data: [Project] = []
        
        for entity in projects {
            var project = entity
            self.mergeRequestManager.getMergeRequests(id: project.id) { (requestResult) in
                switch requestResult {
                case .success(let values):
                    project.mergeRequest = values
                    data.append(project)
                    if let lastProject = projects.last, lastProject.id == project.id {
                        completion(.success(data))
                    }
                case .error(let error):
                    completion(.error(error))
                }
            }
        }
       
    }
}
