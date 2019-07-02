//
//  MergeRequestEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by Andrey Mikityuk on 6/4/19.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension MergeRequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MergeRequestEntity> {
        return NSFetchRequest<MergeRequestEntity>(entityName: "MergeRequestEntity")
    }

    @NSManaged public var iid: Int32
    @NSManaged public var mergeRequestDescription: String
    @NSManaged public var projectId: Int32
    @NSManaged public var title: String
    @NSManaged public var project: ProjectEntity?
    @NSManaged public var assignee: UserEntity?
    @NSManaged public var author: UserEntity?

}
