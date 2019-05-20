//
//  ProfileTableViewCell.swift
//  GitlabClient
//
//  Created by User on 26/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var descriptionLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var descriptionLabelBottomConstraint: NSLayoutConstraint!
    
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    
    private var ranges: [NSRange] = []
    private var gesture: UITapGestureRecognizer?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        gesture = UITapGestureRecognizer(target: self, action: #selector(tapLabel))
    }
    
    func setup(with viewModel: ProfileItemViewModel) {
        
        self.titleLabel.text = viewModel.title
        
        guard let text = viewModel.description else { return }
        
        guard let attribute = checkForUrl(text: text, storeRange: false) else {
            self.descriptionLabel.text = text
            return
        }
        
        self.descriptionLabel.attributedText = attribute
        self.descriptionLabel.isUserInteractionEnabled = true
        
        if let gesture = gesture {
            gesture.numberOfTapsRequired = 1
            self.descriptionLabel.addGestureRecognizer(gesture)
        }
    }
    
    func checkForUrl(text: String, storeRange: Bool) -> NSMutableAttributedString? {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        switch TextHelper.urlsInString(with: text) {
        case .success(let urls):
            if urls.count > 0 {
                let attribute = NSMutableAttributedString(string: text, attributes: attributes as [NSAttributedString.Key : Any])
                for url in urls {
                    let range = (text as NSString).range(of: url)
                    if storeRange {
                        ranges.append(range)
                    }
                    attribute.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range)
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
        guard let text = viewModel.description else { return  ProfileCellSize(titleHeight: titleLabel.frame.height, descriptionHeight: 0, titleWidth: titleLabel.frame.width, descriptionWidth: 0) }
            
            if let attribute = checkForUrl(text: text, storeRange: false) {
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
    
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        guard let text = self.descriptionLabel.text else { return }
        
        let attribute = self.checkForUrl(text: text, storeRange: true)
        for range in ranges {
            if gesture.didTapAttributedTextInLabel(self.descriptionLabel, inRange: range) {
                let string = (String)(Array(text)[range.location...(range.location + range.length - 1)])
                guard let url = URL(string: string) else { return }
                guard let tempAttribute = attribute else { return }
                tempAttribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.purple, range: range)
                self.descriptionLabel.attributedText = attribute
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
         ranges.removeAll()
    }
}
