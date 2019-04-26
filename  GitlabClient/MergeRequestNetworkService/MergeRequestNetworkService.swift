//
//  MergeRequestNetworkService.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol MergeRequestNetworkServiceType {
    func getMergeRequests(id: Int, completion: @escaping (Result<[MergeRequest]>) -> Void)
}

class MergeRequestNetworkService: MergeRequestNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getMergeRequests(id: Int, completion: @escaping (Result<[MergeRequest]>) -> Void) {
        
        let request = MergeRequestRequest(method: .GET, path: Constants.NetworkPath.api.rawValue + Constants.NetworkPath.mergeRequest.rawValue + "\(id)" + Constants.MergeRequestKeyValues.mergeRequestsKey.rawValue)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processData(_ data: Data, completion: @escaping (Result<[MergeRequest]>) -> Void) {
        let result: Result<[MergeRequest]> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let requests):
            completion(.success(requests))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    
}
