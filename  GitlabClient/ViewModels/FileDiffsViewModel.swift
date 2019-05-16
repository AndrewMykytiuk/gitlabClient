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
    
    let newContent: [String]?
    let oldContent: [String]?
    let newContentRanges: [NSRange]?
    let oldContentRanges: [NSRange]?
    
    enum Kind {
        case new
        case modified
        case deleted
    }
    
    init(with newContent: [String]?, oldContent: [String]?, newContentRanges: [NSRange]?, oldContentRanges: [NSRange]?) {
        self.newContent = newContent
        self.oldContent = oldContent
        self.newContentRanges = newContentRanges
        self.oldContentRanges = oldContentRanges
    }
    
}
