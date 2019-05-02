//
//  ProjectsNetworkService.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol ProjectsNetworkServiceType {
    func getProjects(completion: @escaping (Result<[Project]>) -> Void)
}

class ProjectsNetworkService: ProjectsNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getProjects(completion: @escaping (Result<[Project]>) -> Void) {
        
        let request = ProjectRequest(method: .GET, path: Constants.Network.Path.api.rawValue + Constants.Network.Path.projects.rawValue)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processData(_ data: Data, completion: @escaping (Result<[Project]>) -> Void) {
        let result: Result<[Project]> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let projects):
            if projects.count > 0 {
            completion(.success(projects))
            }
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    
}

