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
        
        loginManager.getToken(with: code) { [weak self] (result) in
            switch result {
            case .success(let token):
                self?.saveToken(token, completion: { [weak self] (errorResult) in
                    if let error = errorResult {
                        completion(.error(error))
                    } else {
                        completion(.success(token))
                    }
                })
                
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    private func saveToken(_ token: String, completion: @escaping(Error?) -> Void) {
        switch keychainItem.saveToken(token) {
        case .success:
            completion (nil)
        case .error(let error):
            completion (error)
        }
    }
    
    func logout() -> Result<Void> {
        
        switch keychainItem.readToken() { 
        case .success(let token):
            let removeError = self.removeToken(token)
            if let error = removeError {
                return .error(error)
            } else {
                return .success(Void())
            }
        case .error(let error):
            return .error(error)
        }
        
    }
    
    private func removeToken(_ token: String) -> Error? {
        switch keychainItem.removeToken(token) {
        case .success:
             return nil
        case .error(let error):
            return error
        }
    }
    
}


