//
//  Project.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct Project: Codable {
    
    let id: Int
    let name: String
    let description: String
    let date: Date
    var mergeRequest: [MergeRequest]!
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case description
        case date = "last_activity_at"
        case mergeRequest
        
    }
    
}
