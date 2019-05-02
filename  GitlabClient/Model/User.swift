//
//  User.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct User: Codable {
    
    let id: Int
    let name: String
    let username: String
    let email: String?
    let publicEmail: String?
    let skype: String?
    let linkedin: String?
    let twitter: String?
    let websiteUrl: String?
    let location: String?
    let organization: String?
    let bio: String?
    let privateProfile: Bool?
    let avatarUrl: URL
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case username
        case email
        case publicEmail = "public_email"
        case skype
        case linkedin
        case twitter
        case websiteUrl = "website_url"
        case location
        case organization
        case bio
        case privateProfile = "private_profile"
        case avatarUrl = "avatar_url"
        
    }
    
}
