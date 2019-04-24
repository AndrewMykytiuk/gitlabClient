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
    @IBOutlet private weak var nameOfChangesLabel: UILabel!
    @IBOutlet private weak var changesDescriptionLabel: UILabel!
    
    @IBOutlet var cellOutlets: [NSLayoutConstraint]!
    

    func setup(with changes: MergeRequestChanges) {
        
        self.fileNameLabel.text = changes.newPath
        self.nameOfChangesLabel.text = changes.deletedFile.description
        self.changesDescriptionLabel.text = changes.diff
        
    }
    
    func getCellSize(with changes: MergeRequestChanges) -> CGFloat {
        var height: CGFloat = 0
        
        let fileNameHeight = TextHelper.getHeightForStringInLabel(with: changes.newPath, width: fileNameLabel.frame.width)
        let nameOfChangesHeight = TextHelper.getHeightForStringInLabel(with: changes.deletedFile.description, width: nameOfChangesLabel.frame.width)
        let changesDescriptionHeight = TextHelper.getHeightForStringInLabel(with: changes.diff, width: changesDescriptionLabel.frame.width)
    
        height = ceil(fileNameHeight) + ceil(nameOfChangesHeight) + ceil(changesDescriptionHeight)
        height += self.cellOffsets()
        
        return height
    }
    
    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0

        for constraint in cellOutlets {
            sum += constraint.constant
        }
        return sum
    }
    
    class func identifier() -> String {
        return "MergeRequestTableViewCell"
    }
    
}
