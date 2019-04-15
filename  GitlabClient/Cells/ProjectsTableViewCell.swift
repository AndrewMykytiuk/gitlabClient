//
//  NewsTableViewCell.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class ProjectsTableViewCell: UITableViewCell {

    @IBOutlet var cellNSLayoutConstraints: [NSLayoutConstraint]!
    
    @IBOutlet weak var mergesLabel: UILabel!
    @IBOutlet weak var mergesLabelDescription: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var assignToLabel: UILabel!
    @IBOutlet weak var authorNameLabel: UILabel!
    @IBOutlet weak var assignToNameLabel: UILabel!
    
    private enum tableViewCellTitles: String {
        case author = "author:"
        case assign = "assign to:"
    }
    
    func setup(with request: MergeRequest) {
        let localStrings = getStaticNames()
        
        self.mergesLabel.text = request.title
        self.mergesLabelDescription.text = request.description
        self.authorLabel.text = localStrings.author
        self.assignToLabel.text = localStrings.assign
        self.authorNameLabel.text = request.authorName
        self.assignToNameLabel.text = request.assigneeName
        
    }
    
    func getLabelsSize(with request: MergeRequest) -> ProjectsCellSize {
        if mergesLabel != nil {
            self.setup(with: request)
            return ProjectsCellSize(mergeRequest: (height: mergesLabel.frame.height, width: mergesLabel.frame.width), authorName: (height: authorLabel.frame.height, width: authorLabel.frame.width), assignName: (height: assignToLabel.frame.height, width: assignToLabel.frame.width), authorNameData: (height: authorNameLabel.frame.height, width: authorNameLabel.frame.width), assignNameData: (height: assignToNameLabel.frame.height, width: assignToNameLabel.frame.width), mergeRequestDesription: (height: mergesLabelDescription.frame.height, width: mergesLabelDescription.frame.width))
        } else {
            return ProjectsCellSize(mergeRequest: (height: 0, width: 0), authorName: (height: 0, width: 0), assignName: (height: 0, width: 0), authorNameData: (height: 0, width: 0), assignNameData: (height: 0, width: 0), mergeRequestDesription: (height: 0, width: 0))
        }
    }
    
    func getStaticNames() -> (author: String, assign: String) {
        return (tableViewCellTitles.author.rawValue, tableViewCellTitles.assign.rawValue)
    }
    
    func cellOffsets() -> CGFloat {
        var sum: CGFloat = 0
        for constraint in cellNSLayoutConstraints {
            sum += constraint.constant
        }
        return sum
    }
    
    class func identifier() -> String {
        return "ProjectsTableViewCell"
    }
    
    
}
