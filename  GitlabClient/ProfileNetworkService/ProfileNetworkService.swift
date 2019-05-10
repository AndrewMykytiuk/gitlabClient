//
//  ProfileNetworkService.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol ProfileNetworkServiceType {
    func user(completion: @escaping Completion<User>)
}

class ProfileNetworkService: ProfileNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func user(completion: @escaping Completion<User>) {
        
        let request = ProfileRequest(method: .GET, path: Constants.Network.Path.api.rawValue + Constants.Network.Path.profile.rawValue)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processData(_ data: Data, completion: @escaping Completion<User>) {
        
        let result: Result<User> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let user):
            completion(.success(user))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
}
