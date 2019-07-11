//
//  MergeRequestNetworkService.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol MergeRequestNetworkServiceType {
    func mergeRequests(completion: @escaping Completion<[MergeRequest]>)
}

class MergeRequestNetworkService: MergeRequestNetworkServiceType {
    
    private let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func mergeRequests(completion: @escaping Completion<[MergeRequest]>) {
        
         let request = MergeRequestsRequest(method: .GET, path: Constants.Network.Path.api.rawValue + Constants.Network.MergeRequest.mergeRequestsKey.rawValue)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processMRData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    func mergeRequestChanges(id: Int, iid: Int, completion: @escaping Completion<[MergeRequestChange]>) {
        
        let pathComponents = [Constants.Network.Path.projects.rawValue, "\(id)", Constants.Network.MergeRequest.mergeRequestsKey.rawValue, "\(iid)", Constants.Network.MergeRequest.changesKey.rawValue]
        
        let request = MergeRequestDetailsRequest(method: .GET, pathComponents: pathComponents)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processMRChangesData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    func approveMergeRequest(id: Int, iid: Int, completion: @escaping Completion<MergeRequestApprove>) {
        let request = MergeRequestApproveRequest(method: .POST, projectId: id, iid: iid, isApprove: true)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processMRApproveData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    func disapproveMergeRequest(id: Int, iid: Int, completion: @escaping Completion<MergeRequestApprove>) {
        let request = MergeRequestApproveRequest(method: .POST, projectId: id, iid: iid, isApprove: false)
        
        networkManager.sendRequest(request) { [weak self] (data) in
            switch data {
            case .success(let data):
                self?.processMRApproveData(data, completion: completion)
            case .error(let error):
                return completion(.error(error))
            }
        }
    }
    
    private func processMRData(_ data: Data, completion: @escaping Completion<[MergeRequest]>) {
        let result: Result<[MergeRequest]> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let requests):
            completion(.success(requests))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    private func processMRChangesData(_ data: Data, completion: @escaping Completion<[MergeRequestChange]>) {
        let result: Result<MergeRequest> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let request):
            completion(.success(request.changes))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    private func processMRApproveData(_ data: Data, completion: @escaping Completion<MergeRequestApprove>) {
        let result: Result<MergeRequestApprove> = DecoderHelper.modelFromData(data)
        switch result {
        case .success(let approvedData):
            completion(.success(approvedData))
        case .error(let error):
            completion(.error(error))
        }
        
    }
    
    
}
