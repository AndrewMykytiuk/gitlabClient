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
    
    @IBOutlet private weak var MRChangesTextView: UITextView!
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let horizontalOffset: CGFloat = 16
    private var fileTitle:String!
    private var mergeRequestChange: MergeRequestChanges!
    
    func configureMergeRequestChangesInfo(change: MergeRequestChanges) {
        self.mergeRequestChange = change
        self.fileTitle = change.newPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = fileTitle
        setupActivityIndicator(with: self.view)
        setUpTextView()
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
    
    private func setUpTextView() {
        MRChangesTextView.textContainerInset = UIEdgeInsets(top: 0, left: horizontalOffset, bottom: 0, right: horizontalOffset)
        MRChangesTextView.textContainer.lineFragmentPadding = 0
        let attributedString = setUpDiffText()
        MRChangesTextView.attributedText = attributedString
    }
    
    private func setUpDiffText() -> NSAttributedString {
        let decorator = DiffsDecorator(with: mergeRequestChange)
        let parser = DiffsParser()
        let state = decorator.changesFileState(), diffs = decorator.changesString()
        let attributedString = parser.setUpColorsForString(with: state, diffs: diffs)
        return attributedString
    }
    
}
