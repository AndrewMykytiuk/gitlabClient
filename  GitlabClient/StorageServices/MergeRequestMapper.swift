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
    
    let userMapper: UserMapper
    
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
    
    func setupMergeRequest(with mergeRequestEntity: MergeRequestEntity) -> MergeRequest {
        let iid = Int(mergeRequestEntity.iid)
        let projectId = Int(mergeRequestEntity.projectId)
        
        let (assigneeEntity, authorEntity) = self.mapUserEntities(from: mergeRequestEntity)
        
        let assignee = userMapper.setupUser(with: assigneeEntity)
        let author = userMapper.setupUser(with: authorEntity)
        
        let mergeRequest = MergeRequest(iid: iid, title: mergeRequestEntity.title, description: mergeRequestEntity.mergeRequestDescription, projectId: projectId, assignee: assignee, author: author)
        return mergeRequest
    }
    
    func mapUserEntities(from mergeRequestEntity: MergeRequestEntity) -> (assigneeEntity: UserEntity, authorEntity: UserEntity){
        guard let assigneeEntity = mergeRequestEntity.assignee, let authorEntity = mergeRequestEntity.author else { fatalError(GitLabError.Storage.Entity.Mapper.failedUserFromMergeRequestMap.rawValue) }
        return (assigneeEntity, authorEntity)
    }
    
    func userEntities(from entity: MergeRequestEntity) -> [UserEntity] {
        let approvedBy = entity.approvedBy?.allObjects as? [UserEntity] ?? []
        return approvedBy
    }
}
