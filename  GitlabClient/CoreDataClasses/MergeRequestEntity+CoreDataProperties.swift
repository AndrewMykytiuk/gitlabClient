//
//  MergeRequestEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by User on 10/04/2019.
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
    @NSManaged public var approvedBy: NSSet?

}

// MARK: Generated accessors for approvedBy
extension MergeRequestEntity {

    @objc(addApprovedByObject:)
    @NSManaged public func addToApprovedBy(_ value: UserEntity)

    @objc(removeApprovedByObject:)
    @NSManaged public func removeFromApprovedBy(_ value: UserEntity)

    @objc(addApprovedBy:)
    @NSManaged public func addToApprovedBy(_ values: NSSet)

    @objc(removeApprovedBy:)
    @NSManaged public func removeFromApprovedBy(_ values: NSSet)

}
