//
//  DiffsDecorator.swift
//  GitlabClient
//
//  Created by User on 05/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class DiffsDecorator {
    
    let changes: MergeRequestChanges
    
    init(with changes: MergeRequestChanges) {
        self.changes = changes
    }
    
    func changesFileState() -> MergeRequestChanges.FileState {
        return changes.state
    }
    
    func changesString() -> String {
        return changes.diff
    }
}
