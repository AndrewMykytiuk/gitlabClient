//
//  UserMapper.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class UserMapper {
    
    func mapEntityIntoObject(with users: [User], objects: [NSManagedObject]) -> [NSManagedObject] {
        let userEntity = UserEntity()
        var userEntiities: [UserEntity] = []
        for user in users {
            userEntity.avatarUrl = user.avatarUrl.absoluteString
            userEntity.id = Int32(user.id)
            userEntity.name = user.name
            userEntity.username = user.username
            userEntity.webUrl = user.websiteUrl
            userEntiities.append(userEntity)
        }
        return userEntiities
    }
    
    func mapObjectIntoEntity(with objects: [NSManagedObject]) -> [User] {
        var users: [User] = []
        for object in objects {
            guard let userEntity = object as? UserEntity else { return users }
            guard let user = setupUser(with: userEntity) else { return users }
            users.append(user)
        }
        return users
    }
    
    private func setupUser(with userEntity: UserEntity) -> User? {
        let id = Int(userEntity.id)
        guard let name = userEntity.name, let username = userEntity.username, let avatarUrl = userEntity.avatarUrl, let url = URL(string: avatarUrl) else { return nil }
        let user = User(id: id, name: name, username: username, email: nil, publicEmail: nil, skype: nil, linkedin: nil, twitter: nil, websiteUrl: userEntity.webUrl, location: nil, organization: nil, bio: nil, privateProfile: nil, avatarUrl: url)
        return user
    }
    
}
