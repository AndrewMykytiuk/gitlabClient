//
//  DiffItem.swift
//  GitlabClient
//
//  Created by User on 12/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

struct DiffItem {
    
    let isNew: Bool
    let nonInARowOrder: Bool
    let string: String
    
    enum Kind {
        case new
        case deleted
    }
    
    init(nonInARowOrder: Bool, string: String, isNew: Bool) {
        self.nonInARowOrder = nonInARowOrder
        self.string = string
        self.isNew = isNew
    }
    
}
