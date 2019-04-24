//
//  MergeRequestViewController.swift
//  GitlabClient
//
//  Created by User on 23/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class MergeRequestViewController: BaseViewController {
    
    @IBOutlet weak var mergeRequestTableView: UITableView! {
        didSet {
            createMergeRequestCellPrototype()
        }
    }
    
    private var mergeRequestService: MergeRequestService!
    private var mergeRequestCell: MergeRequestTableViewCell!
    private var changes: [MergeRequestChanges] = []
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    private var id: Int?
    private var iid: Int?
    
    func configure(with mergeRequestService: MergeRequestService) {
        self.mergeRequestService = mergeRequestService
    }
    
    func setUpMergeRequestInfo(id: Int, iid: Int) {
        self.id = id
        self.iid = iid
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator(with: self.view)
        setupRefreshControl()
        getMergeRequestData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    private func setupRefreshControl() {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        refreshControl.addTarget(self, action: #selector(refreshMergeRequestsData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor(red:226/256, green:71/256, blue:72/256, alpha:1.0)
        refreshControl.attributedTitle = NSAttributedString(string: NSLocalizedString(Constants.RefreshControl.title.rawValue, comment: ""), attributes: attributes as [NSAttributedString.Key : Any])
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
    
    private func getMergeRequestData() {
        guard let id = id, let iid = iid else { return }
        activityIndicator.startAnimating()
        mergeRequestService.getMergeRequestChanges(id: id, iid: iid) { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let changes):
                    welf.activityIndicator.stopAnimating()
                    if changes.count > 0 {
                    welf.changes = changes
                    welf.mergeRequestTableView.reloadData()
                    }
                case .error(let error):
                    welf.activityIndicator.stopAnimating()
                    let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                    welf.present(alert, animated: true)
                }
            }
        }
    }
    
    private func createMergeRequestCellPrototype() {
        let cell = self.mergeRequestTableView.dequeueReusableCell(withIdentifier: MergeRequestTableViewCell.identifier()) as? MergeRequestTableViewCell
        if let tempCell = cell {
            mergeRequestCell = tempCell
        }
    }
    
    @objc private func refreshMergeRequestsData(_ sender: Any) {
        getMergeRequestData()
        activityIndicator.stopAnimating()
    }
    
}

extension MergeRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MergeRequestTableViewCell.identifier(), for: indexPath) as? MergeRequestTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + MergeRequestTableViewCell.identifier())
        }
        
        cell.setup(with: changes[indexPath.row])
        
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: newCollection.accessibilityFrame.size, with: coordinator)
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            guard let welf = self else { return }
            if welf.mergeRequestTableView != nil {
                welf.mergeRequestTableView.reloadData()
            }
        }
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mergeRequestCell.getCellSize(with: changes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}
