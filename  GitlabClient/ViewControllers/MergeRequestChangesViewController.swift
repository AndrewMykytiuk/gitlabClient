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
    private let footerHeight: CGFloat = 10
    private let footerTitle = "•••"
    private var fileTitle:String!
    private var mergeRequestChangesCell: MergeRequestChangesTableViewCell!
    private var diffModels: [DiffCellViewModel]!
    
    func configureMergeRequestChangesInfo(models: [DiffCellViewModel], string: String) {
        self.diffModels = models
        self.fileTitle = string
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = fileTitle
        setupActivityIndicator(with: self.view)
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
    
    private func createViewForFooter(with width: CGFloat, section: Int) -> UIView? {
        if diffModels[section].hasFooter {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: width, height: footerHeight))
        let footerLabel = UILabel(frame: CGRect(x: 0, y: 0, width: width, height: footerHeight))
        footerLabel.text = footerTitle
        footerLabel.font = Constants.font
        footerLabel.textAlignment = .center
        view.addSubview(footerLabel)
        return view
        } else {
            return nil
        }
    }
    
}

extension MergeRequestChangesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return diffModels.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MergeRequestChangesTableViewCell.identifier(), for: indexPath) as? MergeRequestChangesTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + MergeRequestChangesTableViewCell.identifier())
        }
        cell.setup(with: diffModels[indexPath.section].string, color: diffModels[indexPath.section].cellColor)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return createViewForFooter(with: tableView.frame.width, section: section)
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
        return mergeRequestChangesCell.cellSize(with: diffModels[indexPath.section].string)
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}
