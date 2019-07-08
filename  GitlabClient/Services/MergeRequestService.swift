//
//  MergeRequestService.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class MergeRequestService {
    
    private let networkManager: NetworkManager
    private let mergeRequestManager: MergeRequestNetworkService
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
        self.mergeRequestManager = MergeRequestNetworkService(networkManager: networkManager)
    }
    
    func mergeRequestChanges(mergeRequest: MergeRequest, completion: @escaping Completion<[MergeRequestChange]>) {
        
        self.mergeRequestManager.mergeRequestChanges(id: mergeRequest.projectId, iid: mergeRequest.iid) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let changes):
                completion(.success(changes))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func approveMergeRequest(mergeRequest: MergeRequest, completion: @escaping Completion<Void>) {
        
        self.mergeRequestManager.approveMergeRequest(id: mergeRequest.projectId, iid: mergeRequest.iid, completion: { (result) in
            switch result {
            case .success:
                completion(.success(Void()))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
    func disapproveMergeRequest(mergeRequest: MergeRequest, completion: @escaping Completion<Void>) {
        
        self.mergeRequestManager.disapproveMergeRequest(id: mergeRequest.projectId, iid: mergeRequest.iid, completion: { (result) in
            switch result {
            case .success(let void):
                completion(.success(void))
            case .error(let error):
                completion(.error(error))
            }
        })
    }
    
}
