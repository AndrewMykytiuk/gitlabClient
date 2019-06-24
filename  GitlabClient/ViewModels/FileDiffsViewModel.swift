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
    var nonInARowStrings: [String]?
    var state = Kind.new
    
    enum Kind {
        case new
        case modified
        case deleted
    }
    
    init(with newContent: [String]?, oldContent: [String]?, nonInARowStrings: [String]?) {
        self.newContent = newContent
        self.oldContent = oldContent
        self.nonInARowStrings = nonInARowStrings
    }
    
}
