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
    let email: String
    let publicEmail: String?
    let skype: String?
    let linkedin: String?
    let twitter: String?
    let websiteUrl: String?
    let location: String?
    let organization: String?
    let bio: String?
    let privateProfile: String?
    
    
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
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        username = try container.decode(String.self, forKey: .username)
        email = try container.decode(String.self, forKey: .email)
        publicEmail = try container.decode(String?.self, forKey: .publicEmail)
        skype = try container.decode(String?.self, forKey: .skype)
        linkedin = try container.decode(String?.self, forKey: .linkedin)
        twitter = try container.decode(String?.self, forKey: .twitter)
        websiteUrl = try container.decode(String?.self, forKey: .websiteUrl)
        location = try container.decode(String?.self, forKey: .location)
        organization = try container.decode(String?.self, forKey: .organization)
        bio = try container.decode(String?.self, forKey: .bio)
        privateProfile = try container.decode(String?.self, forKey: .privateProfile)
    }
    
}
