//
//  MergeRequestAuthor.swift
//  GitlabClient
//
//  Created by User on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestAuthor: Codable {
    
    let name: String
    let avatarUrl: String
    
    private enum CodingKeys: String, CodingKey {
        
        case name
        case avatarUrl = "avatar_url"
        
    }
    
}
