//
//  MergeRequestChanges.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestChange: Codable {
    
    let oldPath: String
    let newPath: String
    let state: FileState
    let diff: String
    
    private enum CodingKeys: String, CodingKey {
        
        case oldPath = "old_path"
        case newPath = "new_path"
        case newFile = "new_file"
        case deletedFile = "deleted_file"
        case diff
        
    }
    
    enum FileState {
        case new
        case modified
        case deleted
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.oldPath = try container.decode(String.self, forKey: .oldPath)
        self.newPath = try container.decode(String.self, forKey: .newPath)
        self.diff = try container.decode(String.self, forKey: .diff)
        
        
        let deletedFile = try container.decode(Bool.self, forKey: .deletedFile)
        let newFile = try container.decode(Bool.self, forKey: .newFile)
        
        if newFile {
            state = .new
        } else if deletedFile {
            state = .deleted
        } else {
            state = .modified
        }
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(oldPath, forKey: .oldPath)
        try container.encode(newPath, forKey: .newPath)
        try container.encode(diff, forKey: .diff)
        
        
        switch state {
        case .new:
            let newFile = true
            try container.encode(newFile, forKey: .newFile)
        case .deleted:
            let deletedFile = true
            try container.encode(deletedFile, forKey: .deletedFile)
        case .modified:
            let modifiedFile = false
            try container.encode(modifiedFile, forKey: .newFile)
        }
    }
    
}
