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
    private let keychainItem: KeychainItem
    private let profileManager: ProfileNetworkService
    
    init(networkManager: NetworkManager, keychainItem: KeychainItem) {
        self.networkManager = networkManager
        self.keychainItem = keychainItem
        self.profileManager = ProfileNetworkService(networkManager: networkManager)
    }
    
    func getUser(completion: @escaping (Result<User>) -> Void) {
        
        switch keychainItem.readToken() {
        case .success(let token):
            profileManager.getUser(with: token) { [weak self] (result) in
                switch result {
                case .success(let model):
                    completion(.success(model))
                case .error(let error):
                    completion(.error(error))
                }
            }
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
}
