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
    
    let mergeRequestMapper: MergeRequestMapper!
    
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

    func mapFromEntities(with objects: [NSManagedObject]) {  // -> [T:Codable]

        for data in objects {
            if let ggg = data as? ProjectEntity {
                if let set = ggg.toMergeRequest?.allObjects as? [MergeRequestEntity] { // Troubles with data: <fault>
                    for elem in set {
                        elem.description
                    }
                }
            }
        }
    }
}
