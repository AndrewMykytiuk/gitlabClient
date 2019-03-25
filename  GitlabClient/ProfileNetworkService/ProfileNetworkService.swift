//
//  ProfileNetworkService.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol ProfileNetworkServiceType {
    func getUser(with token: String, completion: @escaping (Result<User>) -> Void)
}

class ProfileNetworkService: ProfileNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getUser(with token: String, completion: @escaping (Result<User>) -> Void) {
        
        let request = ProfileRequest(method: .GET, path: Constants.NetworkPath.profile.rawValue, token: token)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processData(_ data: Data, completion: @escaping (Result<User>) -> Void) {
        let dictionary = self.modelFromData(data)
        switch dictionary {
        case .success(let user):
            completion(.success(user))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    private func modelFromData(_ data: Data) -> Result<User> {
//        let decoder = JSONDecoder()
//        if let userData = try? decoder.decode(User.self, from: data) {
//            return .success(userData)
//        } else {
//            return .error(ParsingError.emptyResult(String(data: data, encoding: String.Encoding.utf8)))
//        }
        
        do {
            let decoder = JSONDecoder()
            let userData = try decoder.decode(User.self, from: data)
            return .success(userData)
        } catch DecodingError.dataCorrupted(let context) {
            return .error(DecodingError.dataCorrupted(context))
        } catch DecodingError.keyNotFound(let key, let context) {
            return .error(DecodingError.keyNotFound(key,context))
        } catch DecodingError.typeMismatch(let type, let context) {
            return .error(DecodingError.typeMismatch(type,context))
        } catch DecodingError.valueNotFound(let value, let context) {
            return .error(DecodingError.valueNotFound(value,context))
        } catch let error {
            return .error(error)
        }
    }
}
