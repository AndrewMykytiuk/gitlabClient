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
    
    func mergeRequestChanges(id: Int, iid: Int, completion: @escaping Completion<[MergeRequestChange]>) {
        
        self.mergeRequestManager.mergeRequestChanges(id: id, iid: iid) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case .success(let changes):
                completion(.success(changes))
            case .error(let error):
                completion(.error(error))
            }
        }
    }
    
    func starMergeRequest(id: Int, completion: @escaping Completion<Void>) {
        
        self.mergeRequestManager.starMergeRequest(id: id, completion: { (result) in
            switch result {
            case .success:
                completion(.success(Void()))
            case .error(let error):
                if error._code == 304 {
                    completion(.success(Void()))
                }
                completion(.error(error))
            }
        })
    }
    
    func unstarMergeRequest(id: Int, completion: @escaping Completion<Void>) {
        
        self.mergeRequestManager.unstarMergeRequest(id: id, completion: { (result) in
            switch result {
            case .success(let void):
                completion(.success(void))
            case .error(let error):
                if error._code == 304 {
                    completion(.success(Void()))
                }
                completion(.error(error))
            }
        })
    }
    
}
