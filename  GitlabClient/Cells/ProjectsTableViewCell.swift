//
//  NewsTableViewCell.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

protocol ProjectsTableViewCellDelegate: class {
    func moreTapped(cell: ProjectsTableViewCell)
}

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet private var cellNSLayoutConstraints: [NSLayoutConstraint]!
    @IBOutlet private weak var bottomCellNSLayoutConstraint: NSLayoutConstraint!
    @IBOutlet private weak var showMoreButton: UIButton!
    
    @IBOutlet private weak var mergesLabel: UILabel!
    @IBOutlet private weak var mergesLabelDescription: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var assignToLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var assignToNameLabel: UILabel!

    weak var delegate: ProjectsTableViewCellDelegate?
    
    private enum cellStaticTitles: String {
        case authorTitle = "author:"
        case assignTitle = "assign to:"
        case lessButtonTitle = "Show less..."
        case moreButtonTitle = "Show more..."
    }
    
    private enum constraintsForCell: CGFloat {
        case numberOfLines = 2
        case buttonNeeded = 23
        case noButtonNeeded = 8
    }
    
    func setup(with request: MergeRequest, isExpanded: Bool) {
        let localStrings = getAuthorAndAssignTitles()
        
        self.mergesLabel.text = request.title
        self.authorLabel.text = localStrings.author
        self.assignToLabel.text = localStrings.assign
        self.authorNameLabel.text = request.author.name
        self.assignToNameLabel.text = request.assignee.name
        
        let mergeRequestDescriptionHeight = TextHelper.getHeightForStringInLabel(with: request.description, width: mergesLabelDescription.frame.width)
        if mergeRequestDescriptionHeight > mergesLabelDescription.font.lineHeight * constraintsForCell.numberOfLines.rawValue {
            setupForButton(isNeeded: true, isExpanded: isExpanded)
        } else {
            setupForButton(isNeeded: false, isExpanded: isExpanded)
        }
        
        self.mergesLabelDescription.text = request.description
    }
    
    private func setupForButton(isNeeded: Bool, isExpanded: Bool) {
        if isNeeded {
            self.showMoreButton.isHidden = false
            setUpBottomConstraint(isButtonNeeded: isNeeded)
            self.mergesLabelDescription.numberOfLines = isExpanded ? 0 : Int(constraintsForCell.numberOfLines.rawValue)
            self.showMoreButton.setTitle(isExpanded ? cellStaticTitles.lessButtonTitle.rawValue : cellStaticTitles.moreButtonTitle.rawValue, for: .normal)
        } else {
            self.showMoreButton.isHidden = true
            setUpBottomConstraint(isButtonNeeded: isNeeded)
            self.mergesLabelDescription.numberOfLines = Int(constraintsForCell.numberOfLines.rawValue)
        }
    }
    
    private func setUpBottomConstraint(isButtonNeeded: Bool) {
        if isButtonNeeded {
            self.bottomCellNSLayoutConstraint.constant = constraintsForCell.buttonNeeded.rawValue
        } else {
            self.bottomCellNSLayoutConstraint.constant = constraintsForCell.noButtonNeeded.rawValue
        }
    }
    
    func getCellSize(with request: MergeRequest, isExpanded: Bool) -> CGFloat {
        var height: CGFloat = 0
        let names = self.getAuthorAndAssignTitles()
        
        let mergeRequestTitleHeight = TextHelper.getHeightForStringInLabel(with: request.title, width: mergesLabel.frame.width)
        let authorNameHeight = TextHelper.getHeightForStringInLabel(with: names.assign, width: authorLabel.frame.width)
        let assignToHeight = TextHelper.getHeightForStringInLabel(with: names.author, width: assignToLabel.frame.width)
        let authorDataHeight = TextHelper.getHeightForStringInLabel(with: request.author.name, width: authorNameLabel.frame.width)
        let assignDataHeight = TextHelper.getHeightForStringInLabel(with: request.assignee.name, width: assignToNameLabel.frame.width)
        let (mergeRequestDescriptionHeight, isButtonNeeded) = calculatingHeightForDescriptionLabel(with: request.description, isExpanded: isExpanded)
        
        height = ceil(mergeRequestTitleHeight) + max(authorNameHeight, assignToHeight) + max(authorDataHeight, assignDataHeight) + ceil(mergeRequestDescriptionHeight)
        
        height += self.cellOffsets(isNeeded: isButtonNeeded)
        
        return height
    }
    
    private func calculatingHeightForDescriptionLabel(with string: String, isExpanded: Bool) -> (CGFloat, Bool) {
         let mergeRequestDescriptionHeight = TextHelper.getHeightForStringInLabel(with: string, width: mergesLabelDescription.frame.width)
        if mergeRequestDescriptionHeight > mergesLabelDescription.font.lineHeight * 2 {
            if isExpanded {
                return (mergeRequestDescriptionHeight, true)
            }
            return (mergesLabelDescription.font.lineHeight * 2, true)
        }
        return (mergeRequestDescriptionHeight, false)
    }
    
    private func getAuthorAndAssignTitles() -> (author: String, assign: String) {
        return (cellStaticTitles.authorTitle.rawValue, cellStaticTitles.assignTitle.rawValue)
    }
    
    private func cellOffsets(isNeeded: Bool) -> CGFloat {
        var sum: CGFloat = 0
        
        if !isNeeded {
            setUpBottomConstraint(isButtonNeeded: isNeeded)
        } else {
            setUpBottomConstraint(isButtonNeeded: isNeeded)
        }
        
        for constraint in cellNSLayoutConstraints {
            sum += constraint.constant
        }
        return sum
    }
    
    class func identifier() -> String {
        return "ProjectsTableViewCell"
    }
    
    @IBAction func readMoreButtonAction(_ sender: UIButton) {
        delegate?.moreTapped(cell: self)
    }
    
}
