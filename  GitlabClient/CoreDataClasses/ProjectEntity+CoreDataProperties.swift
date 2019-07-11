//
//  ProjectEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by User on 10/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension ProjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }

    @NSManaged public var date: NSDate
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var projectDescription: String
    @NSManaged public var mergeRequests: NSSet?

}

// MARK: Generated accessors for mergeRequests
extension ProjectEntity {

    @objc(addMergeRequestsObject:)
    @NSManaged public func addToMergeRequests(_ value: MergeRequestEntity)

    @objc(removeMergeRequestsObject:)
    @NSManaged public func removeFromMergeRequests(_ value: MergeRequestEntity)

    @objc(addMergeRequests:)
    @NSManaged public func addToMergeRequests(_ values: NSSet)

    @objc(removeMergeRequests:)
    @NSManaged public func removeFromMergeRequests(_ values: NSSet)

}
