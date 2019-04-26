//
//  MergeRequest.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequest: Codable {
    
    let iid: Int
    let title: String
    let description: String
    let author: User
    let assignee: User
    let changes: [MergeRequestChanges]?
    let projectId: Int
    
    private enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case author
        case assignee
        case iid
        case changes
        case projectId = "project_id"
        
    }
    
}
