//
//  MergeRequestChangesTableViewCell.swift
//  GitlabClient
//
//  Created by User on 07/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class MergeRequestChangesTableViewCell: UITableViewCell {
    
  
    @IBOutlet weak var labelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var diffTextLabel: UILabel!
    @IBOutlet weak var labelBottomConstraint: NSLayoutConstraint!
   
    private let separatorHeight: CGFloat = 1
    
    func setup(with text: String, color: UIColor) {
        self.diffTextLabel.text = text
        self.backgroundColor = color
    }

    func cellSize(with diff: String) -> CGFloat {
        var height: CGFloat = 0

        let diffTextHeight = TextHelper.getHeightForStringInLabel(with: diff, width: diffTextLabel.frame.width)

        height += ceil(diffTextHeight)

        height += self.cellOffsets()

        return height
    }

    private func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0

        sum += labelTopConstraint.constant
        sum += labelBottomConstraint.constant
        return sum + separatorHeight
    }
    
    class func identifier() -> String {
        return "MergeRequestChangesTableViewCell"
    }
    
}
