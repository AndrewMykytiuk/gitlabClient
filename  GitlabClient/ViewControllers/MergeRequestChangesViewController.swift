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
    
    private enum PatternsWithColors {
        
        case added
        case deleted
        
        var info: (pattern: String, color: UIColor) {
            switch self {
            case .added:
                return ("^[+]\\D(.+)$", Constants.Colors.mainGreen.value)
            case .deleted:
                return ("^[-]\\D(.+)$", Constants.Colors.mainRed.value)
            }
        }
        
    }
    
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
        MRChangesTextView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        MRChangesTextView.textContainer.lineFragmentPadding = 0
        setUpData(change: change)
    }
    
    private func setUpData(change: MergeRequestChanges) {
        let attributes = [NSAttributedString.Key.font : Constants.font]
        let attribute = NSMutableAttributedString(string: change.diff, attributes: attributes as [NSAttributedString.Key : Any])
        
        switch change.state {
        case .new:
            setUpColorForView(self.view, with: .mainGreen)
        case .deleted:
            setUpColorForView(self.view, with: .mainRed)
        case .modified:
            findAndHighliteText(with: .added, string: change.diff, attribute: attribute)
            findAndHighliteText(with: .deleted, string: change.diff, attribute: attribute)
        }
        self.MRChangesTextView.attributedText = attribute
    }
    
    private func findAndHighliteText(with patternsWithColors: PatternsWithColors, string: String, attribute: NSMutableAttributedString) {
        let regex = try? NSRegularExpression(pattern: patternsWithColors.info.pattern, options: [ .anchorsMatchLines])
        
        guard let matches = regex?.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string)) else { return }
        
        for match in matches {
            let range = match.range(at: 0)
            setUpColorForString(attribute, with: range, with: patternsWithColors.info.color)
        }
    }
    
    private func setUpColorForString(_ attribute: NSMutableAttributedString, with range: NSRange, with color: UIColor) {
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
    }
    
    private func setUpColorForView(_ view: UIView, with color: Constants.Colors) {
        view.backgroundColor = color.value
    }
    
}
