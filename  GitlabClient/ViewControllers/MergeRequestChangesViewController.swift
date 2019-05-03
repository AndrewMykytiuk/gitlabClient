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
        
        self.MRChangesTextView.text = change.diff
    }
    
//    private func getMergeRequestData() {
//        guard let id = id, let iid = iid else { return }
//        activityIndicator.startAnimating()
//        mergeRequestService.getMergeRequestChanges(id: id, iid: iid) { [weak self] (result) in
//            guard let welf = self else { return }
//            DispatchQueue.main.async {
//                switch result {
//                case .success(let changes):
//                    if changes.count > 0 {
//                        welf.changes = changes
//                        welf.mergeRequestTableView.reloadData()
//                    }
//                case .error(let error):
//                    let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
//                    welf.present(alert, animated: true)
//                }
//                welf.refreshControl.endRefreshing()
//                welf.activityIndicator.stopAnimating()
//            }
//        }
//    }
    
}
