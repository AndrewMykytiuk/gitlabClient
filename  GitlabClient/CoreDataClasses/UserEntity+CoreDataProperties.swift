//
//  UserEntity+CoreDataProperties.swift
//  GitlabClient
//
//  Created by User on 24/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//
//

import Foundation
import CoreData


extension UserEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserEntity> {
        return NSFetchRequest<UserEntity>(entityName: "UserEntity")
    }

    @NSManaged public var id: Int32
    @NSManaged public var name: String?
    @NSManaged public var username: String?
    @NSManaged public var state: String?
    @NSManaged public var avatarUrl: String?
    @NSManaged public var webUrl: String?
    @NSManaged public var toMergeRequest: MergeRequestEntity?

}
