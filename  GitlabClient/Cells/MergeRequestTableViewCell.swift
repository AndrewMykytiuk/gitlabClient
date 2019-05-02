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
    
    private let separatorHeight: CGFloat = 1

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
        var isFileDeletedFalse = false
        
        changes.deletedFile ? self.backgroundColor = Constants.Colors.mainRed.value : isFileDeletedFalse.toggle()
        
        if isFileDeletedFalse {
            self.backgroundColor = changes.newFile ? Constants.Colors.mainGreen.value : Constants.Colors.mainOrange.value
        }
    }
    
    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0

        for constraint in cellOutlets {
            sum += constraint.constant
        }
        return sum + separatorHeight
    }
    
    class func identifier() -> String {
        return "MergeRequestTableViewCell"
    }
    
}
