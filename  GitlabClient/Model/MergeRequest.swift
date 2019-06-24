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
    let changes: [MergeRequestChange]
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
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.iid = try container.decode(Int.self, forKey: .iid)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.author = try container.decode(User.self, forKey: .author)
        self.assignee = try container.decode(User.self, forKey: .assignee)
        self.projectId = try container.decode(Int.self, forKey: .projectId)
        self.changes = (try? container.decode([MergeRequestChange].self, forKey: .changes)) ?? []
        
    }
    
}
