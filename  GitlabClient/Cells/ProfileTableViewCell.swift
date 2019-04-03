//
//  ProfileTableViewCell.swift
//  GitlabClient
//
//  Created by User on 26/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var descriptionLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    func setup(with viewModel: ProfileItemViewModel) {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
    }
    
    func verticalOffsets() -> CGFloat {
        return descriptionLabelTopConstraint.constant + descriptionLabelBottomConstraint.constant
    }
    
    func getLabelsSize(with viewModel: ProfileItemViewModel) -> ProfileCellSize {
        if titleLabel != nil {
        self.titleLabel.text = viewModel.title
        self.descriptionLabel.text = viewModel.description
            
        let size = ProfileCellSize(titleHeight: titleLabel.frame.height, descriptionHeight: descriptionLabel.frame.height, titleWidth: titleLabel.frame.width, descriptionWidth: descriptionLabel.frame.width)
            
        return size
        } else {
            return ProfileCellSize(titleHeight: 0, descriptionHeight: 0, titleWidth: 0, descriptionWidth: 0)
        }
    }
    
    class func identifier() -> String {
        return "ProfileTableViewCell"
    }

}
