//
//  ProjectsTableViewCell.swift
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
    @IBOutlet private weak var mergesLabelDescription: UILabel! {
        didSet {
            numberOfLinesHeight = mergesLabelDescription.font.lineHeight * CGFloat(numberOfLines)
        }
    }
    @IBOutlet private weak var authorOneLineLabel: UILabel!
    @IBOutlet private weak var assignToOneLineLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var assignToLabel: UILabel!
    @IBOutlet private weak var authorNameLabel: UILabel!
    @IBOutlet private weak var assignToNameLabel: UILabel!

    weak var delegate: ProjectsTableViewCellDelegate?
    private let numberOfLines: Int = 2
    private var numberOfLinesHeight: CGFloat = 0
    
    private enum cellStaticTitles: String {
        case authorTitle = "author"
        case assignTitle = "assign"
        case lessButtonTitle = "Show less"
        case moreButtonTitle = "Show more"
    }
    
    private enum constraintsForCell: CGFloat {
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
        self.authorOneLineLabel.text = request.author.name
        self.assignToOneLineLabel.text = request.assignee.name
        
        let mergeRequestDescriptionHeight = TextHelper.getHeightForStringInLabel(with: request.description, width: mergesLabelDescription.frame.width)
        let isButtonNeeded = mergeRequestDescriptionHeight > numberOfLinesHeight
        
        setupForButton(isNeeded: isButtonNeeded, isExpanded: isExpanded)
        self.mergesLabelDescription.text = request.description
        
        let _ = calculateSameLineForAuthorAndAssignee(authorName: request.author.name, assigneeName: request.assignee.name)
    }
    
    private func setupForButton(isNeeded: Bool, isExpanded: Bool) {
        self.showMoreButton.isHidden = !isNeeded
        setUpBottomConstraint(isButtonNeeded: isNeeded)
        self.mergesLabelDescription.numberOfLines = isExpanded ? 0 : numberOfLines
        self.showMoreButton.setTitle(isExpanded ? NSLocalizedString(cellStaticTitles.lessButtonTitle.rawValue, comment: "") : NSLocalizedString(cellStaticTitles.moreButtonTitle.rawValue, comment: ""), for: .normal)
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
        let authorNameHeight = TextHelper.getHeightForStringInLabel(with: names.author, width: authorLabel.frame.width)
        let assignToHeight = TextHelper.getHeightForStringInLabel(with: names.assign, width: assignToLabel.frame.width)
        let authorDataHeight = TextHelper.getHeightForStringInLabel(with: request.author.name, width: authorNameLabel.frame.width)
        let assignDataHeight = TextHelper.getHeightForStringInLabel(with: request.assignee.name, width: assignToNameLabel.frame.width)
        let (mergeRequestDescriptionHeight, isButtonNeeded) = calculatingHeightForDescriptionLabel(with: request.description, isExpanded: isExpanded)
        
        if calculateSameLineForAuthorAndAssignee(authorName: request.author.name, assigneeName: request.assignee.name) {
            height = ceil(mergeRequestTitleHeight) + max(authorNameHeight, assignToHeight) + ceil(mergeRequestDescriptionHeight)
        } else {
            height = ceil(mergeRequestTitleHeight) + max(authorNameHeight, assignToHeight) + max(authorDataHeight, assignDataHeight) + ceil(mergeRequestDescriptionHeight)
        }
        
        height += self.cellOffsets(isNeeded: isButtonNeeded)
        
        return height
    }
    
    private func calculateSameLineForAuthorAndAssignee(authorName: String, assigneeName: String) -> Bool {
        
        let authorDataHeight = TextHelper.getHeightForStringInLabel(with: authorName, width: authorOneLineLabel.frame.width)
        let assignDataHeight = TextHelper.getHeightForStringInLabel(with: assigneeName, width: assignToOneLineLabel.frame.width)
        
        authorOneLineLabel.isHidden = authorDataHeight > authorOneLineLabel.font.lineHeight
        assignToOneLineLabel.isHidden = assignDataHeight > assignToOneLineLabel.font.lineHeight
        
        if !authorOneLineLabel.isHidden && !assignToOneLineLabel.isHidden {
            authorNameLabel.isHidden = !assignToOneLineLabel.isHidden
            assignToNameLabel.isHidden = !assignToOneLineLabel.isHidden
            return !assignToOneLineLabel.isHidden
        } else {
            authorNameLabel.isHidden = false
            assignToNameLabel.isHidden = false
            return false
        }
        
    }
    
    private func calculatingHeightForDescriptionLabel(with string: String, isExpanded: Bool) -> (CGFloat, Bool) {
        let mergeRequestDescriptionHeight = TextHelper.getHeightForStringInLabel(with: string, width: mergesLabelDescription.frame.width)
        
        let isButtonNeeded = mergeRequestDescriptionHeight > numberOfLinesHeight
        
        if !isExpanded {
            return ( mergeRequestDescriptionHeight < numberOfLinesHeight ? mergeRequestDescriptionHeight : numberOfLinesHeight, isButtonNeeded)
        }
        
        return (mergeRequestDescriptionHeight, isButtonNeeded)
    }
    
    private func getAuthorAndAssignTitles() -> (author: String, assign: String) {
        return (NSLocalizedString(cellStaticTitles.authorTitle.rawValue, comment: ""), NSLocalizedString(cellStaticTitles.assignTitle.rawValue, comment: ""))
    }
    
    private func cellOffsets(isNeeded: Bool) -> CGFloat {
        var sum: CGFloat = 0
        
        setUpBottomConstraint(isButtonNeeded: isNeeded)
        
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
