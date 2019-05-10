//
//  MergeRequestChangesViewModel.swift
//  GitlabClient
//
//  Created by User on 03/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

struct MergeRequestChangesViewModel {
    
    let newPath: String
    var backgroundColor: UIColor
    
    init(with text: String, color: UIColor) {
        self.newPath = text
        self.backgroundColor = color
    }
    
}
