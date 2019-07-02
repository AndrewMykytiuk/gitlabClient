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
    @IBOutlet weak var topLabelConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomLabelConstraint: NSLayoutConstraint!
    
    private let separatorHeight: CGFloat = 1

    func setup(with model: MergeRequestChangesViewModel) {
        self.fileNameLabel.text = model.newPath
        self.backgroundColor = model.backgroundColor
    }
    
    func cellSize(with changes: MergeRequestChange) -> CGFloat {
        var height: CGFloat = 0
        
        let fileNameHeight = TextHelper.getHeightForStringInLabel(with: changes.newPath, width: fileNameLabel.frame.width)
        
        height += ceil(fileNameHeight)
        
        height += self.cellOffsets()
        
        return height
    }
    
    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0

        sum += topLabelConstraint.constant
        sum += bottomLabelConstraint.constant
        return sum + separatorHeight
    }
    
    class func identifier() -> String {
        return "MergeRequestTableViewCell"
    }
    
}
