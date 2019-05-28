//
//  ProjectEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension ProjectEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProjectEntity> {
        return NSFetchRequest<ProjectEntity>(entityName: "ProjectEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var projectDescription: String?
    @NSManaged public var date: NSDate?
    @NSManaged public var mergeRequests: NSObject?
    @NSManaged public var toMergeRequest: NSSet?

}

// MARK: Generated accessors for toMergeRequest
extension ProjectEntity {

    @objc(addToMergeRequestObject:)
    @NSManaged public func addToToMergeRequest(_ value: MergeRequestEntity)

    @objc(removeToMergeRequestObject:)
    @NSManaged public func removeFromToMergeRequest(_ value: MergeRequestEntity)

    @objc(addToMergeRequest:)
    @NSManaged public func addToToMergeRequest(_ values: NSSet)

    @objc(removeToMergeRequest:)
    @NSManaged public func removeFromToMergeRequest(_ values: NSSet)

}
