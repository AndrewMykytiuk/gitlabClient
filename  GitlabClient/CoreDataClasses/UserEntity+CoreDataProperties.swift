//
//  UserEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by Andrew Mykytuik on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var avatarUrl: String
    @NSManaged public var id: Int32
    @NSManaged public var name: String
    @NSManaged public var username: String
    @NSManaged public var status: String?
    @NSManaged public var email: String?
    @NSManaged public var linkedin: String?
    @NSManaged public var location: String?
    @NSManaged public var twitter: String?
    @NSManaged public var website: String?
    @NSManaged public var approvedMergeRequest: MergeRequestEntity?
    @NSManaged public var mergeRequest: MergeRequestEntity?

}
