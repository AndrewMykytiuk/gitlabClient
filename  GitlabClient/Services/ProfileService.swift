//
//  ProfileService.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class ProfileService {
    
    private let networkManager: NetworkManager
    private let profileManager: ProfileNetworkService
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.profileManager = ProfileNetworkService(networkManager: networkManager)
    }
    
    func getUser(completion: @escaping (Result<UserModel>) -> Void) {
        
        profileManager.getUser { [weak self] (result) in
            switch result {
            case .success(let model):
                completion(.success(model))
            case .error(let error):
                completion(.error(error))
            }
        }
        
    }
    
}
