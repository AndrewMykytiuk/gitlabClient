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
    
    func mapEntityIntoObject(with user: User, userEntity: UserEntity) -> UserEntity {
        userEntity.avatarUrl = user.avatarUrl.absoluteString
        userEntity.id = Int32(user.id)
        userEntity.name = user.name
        userEntity.username = user.username
        return userEntity
    }
    
    func setupUser(with userEntity: UserEntity) -> User {
        let id = Int(userEntity.id)
        guard let url = URL(string: userEntity.avatarUrl) else { fatalError(GitLabError.Storage.EntityMapper.failedUserMap.rawValue) }
        let user = User(id: id, name: userEntity.name, username: userEntity.username, email: nil, publicEmail: nil, skype: nil, linkedin: nil, twitter: nil, websiteUrl: nil, location: nil, organization: nil, bio: nil, privateProfile: nil, avatarUrl: url)
        return user
    }
    
}
