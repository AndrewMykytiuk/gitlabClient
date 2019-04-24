//
//  MergeRequestChanges.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestChanges: Codable {
    
    let oldPath: String
    let newPath: String
    let newFile: Bool
    let renamedFile: Bool
    let deletedFile: Bool
    let diff: String
    
    private enum CodingKeys: String, CodingKey {
        
        case oldPath = "old_path"
        case newPath = "new_path"
        case newFile = "new_file"
        case renamedFile = "renamed_file"
        case deletedFile = "deleted_file"
        case diff
        
    }
    
}
