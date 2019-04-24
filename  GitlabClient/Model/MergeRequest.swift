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
    
//    init(from decoder: Decoder) throws {
//        let values = try decoder.container(keyedBy: CodingKeys.self)
//        changes = try values.decode([MergeRequestChanges]?.self, forKey: .changes)
//        iid = try values.decode(Int.self, forKey: .iid)
//        title = try values.decode(String.self, forKey: .title)
//        description = try values.decode(String.self, forKey: .description)
//        projectId = try values.decode(Int.self, forKey: .projectId)
//        author = try values.decode(User.self, forKey: .author)
//        assignee = try values.decode(User.self, forKey: .assignee)
//        
//    }
    
}
