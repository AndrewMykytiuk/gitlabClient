//
//  FileDiffsViewModel.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

struct FileDiffsViewModel {
    
    var newContent: [String]?
    var oldContent: [String]?
    var newContentRanges: [NSRange]?
    var oldContentRanges: [NSRange]?
    var state = Kind.new
    
    enum Kind {
        case new
        case modified
        case deleted
        
        init(with state: MergeRequestChanges.FileState){
            switch state {
            case .new:
                self = .new
            case .deleted:
                self = .deleted
            case .modified:
                self = .modified
            }
        }
    }
    
    init(with newContent: [String]?, oldContent: [String]?, newContentRanges: [NSRange]?, oldContentRanges: [NSRange]?) {
        self.newContent = newContent
        self.oldContent = oldContent
        self.newContentRanges = newContentRanges
        self.oldContentRanges = oldContentRanges
    }
    
}
