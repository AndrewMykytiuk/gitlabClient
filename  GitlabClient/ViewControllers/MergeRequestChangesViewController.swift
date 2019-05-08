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
        MRChangesTextView.textContainerInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        MRChangesTextView.textContainer.lineFragmentPadding = 0
        setUpData(change: change)
    }
    
    private func setUpData(change: MergeRequestChanges) {
        let attributes = [NSAttributedString.Key.font : Constants.font]
        let attribute = NSMutableAttributedString(string: change.diff, attributes: attributes as [NSAttributedString.Key : Any])
        let lines = change.diff.components(separatedBy: "\n")
        
        switch change.state {
        case .new:
            setUpColorForView(self.view, with: Constants.Colors.mainGreen)
        case .deleted:
            setUpColorForView(self.view, with: Constants.Colors.mainRed)
        case .modified:
//            for line in lines {
//                let range = (change.diff as NSString).range(of: line)
//                if line.first == "+" {
//                        setUpColorForString(attribute, with: range, with: Constants.Colors.mainGreen)
//                } else if line.first == "-" {
//                    setUpColorForString(attribute, with: range, with: Constants.Colors.mainRed)
//                }
//            }
            let ranges = choosingSelectedTextRange(str: change.diff)
            for addedRange in ranges.0 {
                setUpColorForString(attribute, with: addedRange, with: Constants.Colors.mainGreen)
            }
            for deletedRange in ranges.1 {
                setUpColorForString(attribute, with: deletedRange, with: Constants.Colors.mainRed)
            }
            
        }
        
        self.MRChangesTextView.attributedText = attribute
    }
    
    private func setUpColorForString(_ attribute: NSMutableAttributedString, with range: NSRange, with color: Constants.Colors) {
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color.value, range: range)
    }
    
    private func setUpColorForView(_ view: UIView, with color: Constants.Colors) {
        view.backgroundColor = color.value
    }
    
    private func choosingSelectedTextRange(str: String) -> ([NSRange], [NSRange]) {
        guard let regex = try? NSRegularExpression(pattern: "(\n\\S)") else { return ([], []) }
        let match = regex.firstMatch(in: str, options: [], range: NSRange(str.startIndex..., in: str))
        
        let matches = regex.matches(in: str, options: [], range: NSRange(str.startIndex..., in: str))
        var strings: [String] = []
        var startRange: NSRange? = nil
        var endRange = NSRange()
        var startDeletedRange: NSRange? = nil
        var endDeletedRange = NSRange()
        var ranges:([NSRange], [NSRange]) = ([], [])
        for m in matches {
            let range = m.range(at: 0)
            let stringArray = (Array(str)[range.location...(range.location + range.length - 1)])
            strings.append(String(stringArray))
            
            if String(stringArray) == "/n-" {
                endRange = m.range(at: 0)
                startDeletedRange = m.range(at: 0)
                if m == matches.last {
                    endDeletedRange = m.range(at: 0)
                }
                
            } else if String(stringArray) == "/n+" {
                endDeletedRange = m.range(at: 0)
                startRange = m.range(at: 0)
                
                if m.range.location == matches.last?.range.location {
                    endRange = m.range(at: 0)
                }
            }
            
            if startRange == nil {
                guard let startDeletedRange = startDeletedRange else { return ([], []) }
                 ranges.1.append(NSRange(location: startDeletedRange.location, length: (endDeletedRange.location - startDeletedRange.location) + (endDeletedRange.length + startDeletedRange.length)))
            } else if startDeletedRange == nil {
                guard let startRange = startRange else { return ([], []) }
                ranges.0.append(NSRange(location: startRange.location, length: (endRange.location - startRange.location) + (endRange.length + startRange.length)))
            }
           
        }
//        return NSRange(location: startRange.location, length: (endRange.location - startRange.location) + (endRange.length + startRange.length))
        return ranges
    }
    
}
