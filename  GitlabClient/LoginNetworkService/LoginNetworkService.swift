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

class LoginNetworkService {
    
    var networkManager = NetworkManager()
    var helper = Helper()
    
    func getToken(with code: String, completion: @escaping (Result<String>) -> Void) {
        
        let request = LoginRequest(method: .POST, path: Helper.URLKind.token.rawValue, code: code)
        
        networkManager.sendRequest(request) { (data) in
            switch data {
            case .success(let data):
                self.processData(data, completion: completion)
                case .error(let error):
                    return completion(.error(error))
            }
        }
    }
    
    func processData(_ data: Data, completion: @escaping (Result<String>) -> Void) {
            let dictionary = self.helper.dictionaryFromData(data)
            switch dictionary {
            case .success(let dict):
                if let temp = dict["access_token"] as? String {
                    return completion(.success(temp))
                } else {
                    return completion(.error(NSError(domain: "JSON parsing goes wrong", code: 401, userInfo: [:])))
                }
            case .error(let error):
                completion(.error(error))
        }
        
    }
}
