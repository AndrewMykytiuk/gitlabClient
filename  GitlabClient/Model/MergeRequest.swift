//
//  MergeRequest.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequest: Codable {
    
    let title: String
    let description: String
    let authorName: String
    let assigneeName: String
    
    private enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case author
        case assignee
        
    }
    
    private enum AuthorCodingKeys: String, CodingKey {
        case authorName = "name"
    }
    
    private enum AssigneeCodingKeys: String, CodingKey {
        case assigneeName = "name"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        title = try container.decode(String.self, forKey: .title)
        description = try container.decode(String.self, forKey: .description)
        
        let authorContainer = try container.nestedContainer(keyedBy: AuthorCodingKeys.self, forKey: .author)
        let assigneeContainer = try container.nestedContainer(keyedBy: AssigneeCodingKeys.self, forKey: .assignee)
        self.authorName = try authorContainer.decode(String.self, forKey: .authorName)
        self.assigneeName = try assigneeContainer.decode(String.self, forKey: .assigneeName)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(title, forKey: .title)
        try container.encode(description, forKey: .description)
        
        var authorContainer = encoder.container(keyedBy: AuthorCodingKeys.self)
        var assigneeContainer = encoder.container(keyedBy: AssigneeCodingKeys.self)
        try authorContainer.encode(authorName, forKey: .authorName)
        try assigneeContainer.encode(assigneeName, forKey: .assigneeName)
    }
    
}
