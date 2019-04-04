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
        
        guard let text = viewModel.description else { return }
        
        guard let attribute = checkForUrl(text: text) else {
            self.descriptionLabel.text = text
            return
        }
         self.descriptionLabel.attributedText = attribute
    }
    
    func checkForUrl(text: String) -> NSMutableAttributedString? {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        switch DecoderHelper.urlsInString(with: text) {
        case .success(let urls):
            if urls.count > 0 {
                let attribute = NSMutableAttributedString.init(string: text, attributes: attributes as [NSAttributedString.Key : Any])
                for url in urls {
                    let range = (text as NSString).range(of: url)
                    attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.blue, range: range)
                }
                 return attribute
            } else {
                return nil
            }
        case .error:
            return nil
        }
    }
    
    func verticalOffsets() -> CGFloat {
        return descriptionLabelTopConstraint.constant + descriptionLabelBottomConstraint.constant
    }
    
    func getLabelsSize(with viewModel: ProfileItemViewModel) -> ProfileCellSize {
        if titleLabel != nil {
        self.titleLabel.text = viewModel.title
        guard let text = viewModel.description else { return  ProfileCellSize(titleHeight: 0, descriptionHeight: 0, titleWidth: 0, descriptionWidth: 0) }
            
            if let attribute = checkForUrl(text: text) {
                self.descriptionLabel.attributedText = attribute
                self.descriptionLabel.sizeToFit()
            } else {
                self.descriptionLabel.text = text
            }
            
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
