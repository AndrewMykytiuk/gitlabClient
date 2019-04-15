//
//  Project.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct Project: Codable, Hashable {
    
    let id: Int
    let name: String
    let description: String
    
    
    private enum CodingKeys: String, CodingKey {
        
        case id
        case name
        case description
        
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
    }
    
}
