//
//  MergeRequestApprove.swift
//  GitlabClient
//
//  Created by User on 09/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestApprove: Codable {
    
    let id: Int
    let iid: Int
    let projectId: Int
    let title: String
    let description: String
    let approvedBy: [User]
    
    private enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case iid
        case id
        case approvedBy = "approved_by"
        case projectId = "project_id"
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.id = try container.decode(Int.self, forKey: .id)
        self.iid = try container.decode(Int.self, forKey: .iid)
        self.title = try container.decode(String.self, forKey: .title)
        self.description = try container.decode(String.self, forKey: .description)
        self.projectId = try container.decode(Int.self, forKey: .projectId)
        self.approvedBy = (try? container.decode([User].self, forKey: .approvedBy)) ?? []
        
    }
    
}
