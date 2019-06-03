//
//  MergeRequestMapper.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class MergeRequestMapper {
    
    let userMapper: UserMapper!
    
    init(with userMapper: UserMapper) {
        self.userMapper = userMapper
    }
    
    
    
    func mapEntityIntoObject(with mergeRequest: MergeRequest, mergeRequestEntity: MergeRequestEntity) -> MergeRequestEntity {
        mergeRequestEntity.iid = Int32(mergeRequest.iid)
        mergeRequestEntity.projectId = Int32(mergeRequest.projectId)
        mergeRequestEntity.mergeRequestDescription = mergeRequest.description
        mergeRequestEntity.title = mergeRequest.title
        return mergeRequestEntity
    }
    
    func mapObjectIntoEntity(with objects: [NSManagedObject]) -> [MergeRequest] {
        var mergeRequests: [MergeRequest] = []
        for object in objects {
            guard let mergeRequestEntity = object as? MergeRequestEntity else { return mergeRequests }
            //guard let user = setupMergeRequest(with: mergeRequestEntity) else { return mergeRequests }
            //mergeRequests.append(user)
        }
        return mergeRequests
    }
    
//    private func setupMergeRequest(with mergeRequestEntity: MergeRequestEntity) -> MergeRequest? {
//        let iid = Int(mergeRequestEntity.iid)
//        let projectId = Int(mergeRequestEntity.projectId)
//        guard let title = mergeRequestEntity.title, let description = mergeRequestEntity.mergeRequestDescription, mergeRequestEntity.a else { return nil }
//
//        let mergeRequest = MergeRequest(iid: iid, title: title, description: description, projectId: projectId, assignee: <#T##User#>, author: <#T##User#>)
//        return user
//    }
    
}
