//
//  ProfileTableViewCell.swift
//  GitlabClient
//
//  Created by User on 26/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    static let identifier = "ProfileTableViewCell"
    static let cellOffset: CGFloat = 8

}
