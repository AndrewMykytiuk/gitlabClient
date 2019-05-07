//
//  MergeRequestChangesViewController.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class MergeRequestChangesViewController: BaseViewController {
    
    @IBOutlet weak var MRChangesTextView: UITextView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private var mergeRequestChange: MergeRequestChanges?
    
//    private var id: Int?
//    private var iid: Int?
    
//    func configure(with mergeRequestService: MergeRequestService) {
//        self.mergeRequestService = mergeRequestService
//    }
//
    func configureMergeRequestChangesInfo(change: MergeRequestChanges) {
        self.mergeRequestChange = change
        self.navigationController?.title = change.newPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator(with: self.view)
        setUpDiffText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupActivityIndicator(with view: UIView) {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(activityIndicator)
        let horizontalConstraint = activityIndicator
            .centerXAnchor.constraint(equalTo: self.view.centerXAnchor)
        let verticalConstraint = activityIndicator
            .centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        view.addConstraint(horizontalConstraint)
        view.addConstraint(verticalConstraint)
    }
    
    private func setUpDiffText() {
        guard let change = mergeRequestChange else { return }
        MRChangesTextView.textContainerInset = UIEdgeInsets(top: 0, left: 0, bottom: -16, right: 0)
        MRChangesTextView.textContainer.lineFragmentPadding = 0
        setUpData(change: change)
    }
    
    private func setUpData(change: MergeRequestChanges) {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        let attribute = NSMutableAttributedString(string: change.diff, attributes: attributes as [NSAttributedString.Key : Any])
        let lines = change.diff.components(separatedBy: "\n")
        var numberOfLines: Int = 0
        var numberOfAddedLines: Int = 0
        
        switch change.state {
        case .new:
            let range = (change.diff as NSString).range(of: change.diff)
            attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: Constants.Colors.mainGreen.value, range: range)
        case .deleted:
            let range = (change.diff as NSString).range(of: change.diff)
            attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: Constants.Colors.mainRed.value, range: range)
        case .modified:
            for line in lines {
                numberOfLines = lines.count
                if line.first == "+"{
                    let range = (change.diff as NSString).range(of: line)
                    if !attribute.containsAttachments(in: range) {
                        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: Constants.Colors.mainGreen.value, range: range)
                        numberOfAddedLines = numberOfAddedLines + 1
                    }
                } else if line.first == "-" {
                    let range = (change.diff as NSString).range(of: line)
                    attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: UIColor.red, range: range)
                }
            }
        }
        
        
        print("numberOfLines: ",numberOfLines)
        print("numberOfAddedLines: ",numberOfLines)
        self.MRChangesTextView.attributedText = attribute
    }
    
}
