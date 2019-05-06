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
    @IBOutlet private var cellTopAndBottomConstraints: [NSLayoutConstraint]!
    
    private let separatorHeight: CGFloat = 1

    func setup(with model: MergeRequestChangesViewModel) {
        self.fileNameLabel.text = model.newPath
        self.backgroundColor = model.backgroundColor
    }
    
    func cellSize(with changes: MergeRequestChanges) -> CGFloat {
        var height: CGFloat = 0
        
        let fileNameHeight = TextHelper.getHeightForStringInLabel(with: changes.newPath, width: fileNameLabel.frame.width)
        
        height += ceil(fileNameHeight)
        
        height += self.cellOffsets()
        
        return height
    }
    
    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0

        for constraint in cellTopAndBottomConstraints {
            sum += constraint.constant
        }
        return sum + separatorHeight
    }
    
    class func identifier() -> String {
        return "MergeRequestTableViewCell"
    }
    
}
