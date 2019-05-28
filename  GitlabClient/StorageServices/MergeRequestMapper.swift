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
    
    func mapEntityIntoObject(with mergeRequest: MergeRequest, objects: [NSManagedObject]) -> [NSManagedObject] {
        let mergeRequestEntity = MergeRequestEntity()
        mergeRequestEntity.iid = Int32(mergeRequest.iid)
        mergeRequestEntity.projectId = Int32(mergeRequest.projectId)
        mergeRequestEntity.mergeRequestDescription = mergeRequest.description
        mergeRequestEntity.title = mergeRequest.title
        return []
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
    
    private func setupMergeRequest(with mergeRequestEntity: MergeRequestEntity) -> MergeRequest? {
        let iid = Int(mergeRequestEntity.iid)
        guard let name = mergeRequestEntity.name, let username = mergeRequestEntity.username, let avatarUrl = mergeRequestEntity.avatarUrl, let url = URL(string: avatarUrl) else { return nil }
        let mergeRequest = User(
        return user
    }
    
}
