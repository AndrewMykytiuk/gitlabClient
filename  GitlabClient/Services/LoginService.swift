//
//  LoginService.swift
//  GitlabClient
//
//  Created by User on 20/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class LoginService {
    
    private let networkManager: NetworkManager
    private let keychainItem: KeychainItem
    private let loginManager:LoginNetworkService
    
    init(networkManager: NetworkManager, keychainItem: KeychainItem) {
        self.networkManager = networkManager
        self.keychainItem = keychainItem
        self.loginManager = LoginNetworkService(networkManager: networkManager)
    }
    
    func login(with code: String, completion: @escaping (Result<String>) -> Void) {
        
        loginManager.getToken(with: code) { (result) in
            switch result {
            case .success(let token):
                self.saveToken(token, completion: { (saveResult) in
                    switch saveResult {
                    case .success(_):
                        completion(.success(token))
                    case .error(let error):
                        completion(.error(error))
                    }
                })
                
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    private func saveToken(_ token: String, completion: @escaping(Result<Void>) -> Void) {
        switch keychainItem.saveToken(token) {
        case .success:
            completion (.success(Void()))
        case .error(let error):
            completion (.error(error))
        }
    }
    
}


