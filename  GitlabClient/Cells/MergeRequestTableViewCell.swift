//
//  MergeRequestTableViewCell.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class MergeRequestTableViewCell: UITableViewCell {

    @IBOutlet private weak var fileNameLabel: UILabel!
    @IBOutlet private var cellOutlets: [NSLayoutConstraint]!

    func setup(with changes: MergeRequestChanges) {
        self.fileNameLabel.text = changes.newPath
        self.setupCellColor(with: changes)
    }
    
    func getCellSize(with changes: MergeRequestChanges) -> CGFloat {
        var height: CGFloat = 0
        
        let fileNameHeight = TextHelper.getHeightForStringInLabel(with: changes.newPath, width: fileNameLabel.frame.width)
        
        height += ceil(fileNameHeight)
        
        height += self.cellOffsets()
        
        return height
    }
    
    private func setupCellColor(with changes: MergeRequestChanges) {
        if changes.deletedFile {
            self.backgroundColor = UIColor(red:226/256, green:71/256, blue:72/256, alpha:1.0)
        } else if changes.newFile {
            self.backgroundColor = UIColor(red:36/256, green:112/256, blue:65/256, alpha:1.0)
        } else {
            self.backgroundColor = UIColor(red:237/256, green:94/256, blue:32/256, alpha:1.0)
        }
    }
    
    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 1

        for constraint in cellOutlets {
            sum += constraint.constant
        }
        return sum
    }
    
    class func identifier() -> String {
        return "MergeRequestTableViewCell"
    }
    
}
