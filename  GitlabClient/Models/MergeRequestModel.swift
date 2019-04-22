//
//  MergeRequestModel.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestModel: Codable {
    
    let iid: Int
    let title: String
    let description: String
    let author: UserModel
    let assignee: UserModel
    
    private enum CodingKeys: String, CodingKey {
        
        case title
        case description
        case author
        case assignee
        case iid
        
    }
    
}
