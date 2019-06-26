//
//  ProjectMapper.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class ProjectMapper {
    
    let mergeRequestMapper: MergeRequestMapper
    
    init(with mergeRequestMapper: MergeRequestMapper) {
        self.mergeRequestMapper = mergeRequestMapper
    }
    
    func mapEntityIntoObject(with project: Project, projectEntity: ProjectEntity) -> ProjectEntity {
        projectEntity.id = Int32(project.id)
        projectEntity.name = project.name
        projectEntity.projectDescription = project.description
        projectEntity.date = project.date as NSDate
        return projectEntity
    }
    
    func mapFromEntities(with entities: [ProjectEntity]) -> [Project] {
        return entities.map({self.mapProjectsfromEntities(entity: $0)})
    }
    
    private func mapProjectsfromEntities(entity: ProjectEntity) -> Project {
        let id = Int(entity.id)
        
        let mergeRequestEntities = self.mergeRequestEntities(from: entity)
        
        let mergeRequests = mergeRequestEntities.map({mergeRequestMapper.setupMergeRequest(with: $0)})
        
        let project = Project(id: id, name: entity.name, description: entity.projectDescription, date: entity.date as Date, mergeRequests: mergeRequests)
        return project
    }
    
    func mergeRequestEntities(from entity: ProjectEntity) -> [MergeRequestEntity] {
         guard let mergeRequestEntities = entity.mergeRequests?.allObjects as? [MergeRequestEntity] else { fatalError(GitLabError.Storage.Entity.Mapper.failedProjectMap.rawValue) }
        return mergeRequestEntities
    }
}
