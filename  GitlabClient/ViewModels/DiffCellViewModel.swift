//
//  DiffCellViewModel.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

struct DiffCellViewModel {
    
    let cellColor: UIColor
    let hasHeader: Bool
    let hasFooter: Bool
    let string: String
    
    init(cellColor: UIColor, hasHeader: Bool, hasFooter: Bool, string: String) {
        self.cellColor = cellColor
        self.hasHeader = hasHeader
        self.hasFooter = hasFooter
        self.string = string
    }
    
}
