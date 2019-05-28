//
//  MergeRequestEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension MergeRequestEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MergeRequestEntity> {
        return NSFetchRequest<MergeRequestEntity>(entityName: "MergeRequestEntity")
    }

    @NSManaged public var projectId: Int32
    @NSManaged public var iid: Int32
    @NSManaged public var title: String?
    @NSManaged public var mergeRequestDescription: String?
    @NSManaged public var author: NSObject?
    @NSManaged public var assignee: NSObject?
    @NSManaged public var toProject: ProjectEntity?
    @NSManaged public var toUser: NSSet?

}

// MARK: Generated accessors for toUser
extension MergeRequestEntity {

    @objc(addToUserObject:)
    @NSManaged public func addToToUser(_ value: UserEntity)

    @objc(removeToUserObject:)
    @NSManaged public func removeFromToUser(_ value: UserEntity)

    @objc(addToUser:)
    @NSManaged public func addToToUser(_ values: NSSet)

    @objc(removeToUser:)
    @NSManaged public func removeFromToUser(_ values: NSSet)

}
