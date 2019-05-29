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
    var mergeRequest: [MergeRequest]
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case description
        case date = "last_activity_at"
        case mergeRequest
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        self.id = try container.decode(Int.self, forKey: .id)
        self.name = try container.decode(String.self, forKey: .name)
        self.description = try container.decode(String.self, forKey: .description)
        self.date = try container.decode(Date.self, forKey: .date)
        self.mergeRequest = (try? container.decode([MergeRequest].self, forKey: .mergeRequest)) ?? []
        
    }
    
    init(id: Int, name: String, description: String, date: Date, mergeRequest: [MergeRequest]) {
        
        self.id = id
        self.name = name
        self.description = description
        self.date = date
        self.mergeRequest = mergeRequest
        
    }
    
}
