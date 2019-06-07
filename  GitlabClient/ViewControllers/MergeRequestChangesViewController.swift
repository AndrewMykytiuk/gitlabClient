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
    
    @IBOutlet weak var mergeRequestChangesTableView: UITableView! {
        didSet {
            createMergeRequestChangesCellPrototype()
        }
    }
    
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let horizontalOffset: CGFloat = 16
    private var fileTitle:String!
    private var mergeRequestChange: MergeRequestChanges!
    private var mergeRequestChangesCell: MergeRequestChangesTableViewCell!
    private var attributedStrings: [NSAttributedString]!
    
    func configureMergeRequestChangesInfo(change: MergeRequestChanges) {
        self.mergeRequestChange = change
        self.fileTitle = change.newPath
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = fileTitle
        setupActivityIndicator(with: self.view)
        setUpDiffText()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mergeRequestChangesCell.frame = CGRect(origin: CGPoint.zero, size: mergeRequestChangesTableView.frame.size)
        self.mergeRequestChangesCell.layoutIfNeeded()
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
    
    private func createMergeRequestChangesCellPrototype() {
        let cell = self.mergeRequestChangesTableView.dequeueReusableCell(withIdentifier: MergeRequestChangesTableViewCell.identifier()) as? MergeRequestChangesTableViewCell
        if let tempCell = cell {
            mergeRequestChangesCell = tempCell
        }
    }
    
    private func setUpDiffText(){
        let parser = DiffsParser()
        let model = parser.parseChangesIntoModel(with: mergeRequestChange)
        let decorator = DiffsDecorator()
        let diffStrings = decorator.performModel(model: model)
        self.attributedStrings = diffStrings
    }
    
}

extension MergeRequestChangesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return attributedStrings.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MergeRequestChangesTableViewCell.identifier(), for: indexPath) as? MergeRequestChangesTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + MergeRequestChangesTableViewCell.identifier())
        }
        let attributedString = attributedStrings[indexPath.row]
        cell.setup(with: attributedString)
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            guard let welf = self else { return }
            if welf.mergeRequestChangesTableView != nil {
                welf.mergeRequestChangesTableView.reloadData()
            }
        }
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mergeRequestChangesCell.cellSize(with: attributedStrings[indexPath.row])
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}
