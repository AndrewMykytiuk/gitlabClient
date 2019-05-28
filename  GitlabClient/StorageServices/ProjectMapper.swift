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
    
    func mapEntityIntoObject(with project: Project, objects: [NSManagedObject]) -> [NSManagedObject] {
        let projectEntity = ProjectEntity()
        projectEntity.id = Int32(project.id)
        projectEntity.name = project.name
        projectEntity.projectDescription = project.description
        projectEntity.date = project.date as NSDate
        return []
    }
 
    
//    func mapIntoEntities(projects: [Project]) {
//
//        let projectEntities: NSSet = []
//
//        for project in projects {
//            let projectEntity = setUpProjectEtity(with: project)
//            var mergeRequestEntities: NSSet = []
//            var mergeRequestEntitiesArray: [MergeRequestEntity] = []
//            for mergeRequest in project.mergeRequest {
//                let mergeRequestEntity = setUpMergeRequestEtity(with: mergeRequest)
//                let assigneeUserEntity = setUpUserEtity(with: mergeRequest.assignee)
//                let authorUserEntity = setUpUserEtity(with: mergeRequest.author)
//
//                mergeRequestEntity.addToToUser(assigneeUserEntity)
//                mergeRequestEntity.assignee = assigneeUserEntity
//                mergeRequestEntity.addToToUser(authorUserEntity)
//                mergeRequestEntity.author = authorUserEntity
//
//                projectEntity.addToToMergeRequest(mergeRequestEntity)
//
//            }
//
//            projectEntity.mergeRequests = mergeRequestEntities
//            projectEntities.adding(projectEntity)
//        }
//        //StorageService.sharedManager.saveContext()
//    }
//
//    func mapFromEntities(with objects: [NSManagedObject]) {  // -> [T:Codable]
//
//        for data in objects {
//            print(data.value(forKey: "mergeRequests"))
//            if let ggg = data as? ProjectEntity {
//                if let set = ggg.toMergeRequest?.allObjects as? [MergeRequestEntity] {
//                    for elem in set {
//                        elem.description
//                    }
//                }
//            }
//        }
//    }
//    
}
