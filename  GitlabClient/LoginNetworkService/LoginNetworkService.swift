//
//  LoginNetworkService.swift
//  GitlabClient
//
//  Created by User on 15/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol LoginNetworkServiceType {
    func getToken(with code: String, completion: @escaping (Result<String>) -> Void)
}

class LoginNetworkService: LoginNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getToken(with code: String, completion: @escaping (Result<String>) -> Void) {
        
        let request = LoginRequest(method: .POST, path: AuthHelper.URLKind.token.rawValue, code: code)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processData(_ data: Data, completion: @escaping (Result<String>) -> Void) {
        let dictionary = self.codeFromData(data)
        switch dictionary {
        case .success(let token):
            completion(.success(token))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    private func codeFromData(_ data: Data) -> Result<String> {
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any], let code = json?[Constants.Network.Authorize.Keys.accessTokenKey.rawValue] as? String {
            return .success(code)
        } else {
            return .error(ParsingError.emptyResult(String(data: data, encoding: String.Encoding.utf8)))
        }
        
    }
}
