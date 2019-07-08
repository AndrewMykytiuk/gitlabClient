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
    
    @IBOutlet private weak var mergeRequestTableView: UITableView! {
        didSet {
            createMergeRequestCellPrototype()
            mergeRequestTableView.refreshControl = refreshControl
        }
    }
    
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    private var mergeRequestService: MergeRequestService!
    private var mergeRequestCell: MergeRequestTableViewCell!
    private var changes: [MergeRequestChange] = []
    private var id: Int!
    private var iid: Int!
    private var fileName: String!
    private let converter: DiffConverterType = DiffConverter()
    private var toolbarLikeView: ToolbarViewLikeButton?
    private var isLikeButtonPressed: Bool = false
    
    func configure(with mergeRequestService: MergeRequestService) {
        self.mergeRequestService = mergeRequestService
    }
    
    func setUpMergeRequestInfo(id: Int, iid: Int, fileName: String) {
        self.id = id
        self.iid = iid
        self.fileName = fileName
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator(with: self.view)
        setupRefreshControl()
        mergeRequestData()
        setUpXIBsFiles()
        self.title = fileName
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.mergeRequestCell.frame = CGRect(origin: CGPoint.zero, size: mergeRequestTableView.frame.size)
        self.mergeRequestCell.layoutIfNeeded()
    }
    
    private func setUpXIBsFiles() {
        
        guard let view = Bundle.main.loadNibNamed("ToolbarViewForLikeButton", owner: self, options: nil)?.first as? ToolbarViewLikeButton else { return }
        view.delegate = self
        view.setLikeButton()
        self.toolbarLikeView = view

        view.frame = CGRect(x: 0, y: 90, width: self.view.bounds.width, height: 50)
        view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        self.view.addSubview(view)
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshMergeRequestsData(_:)), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
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
    
    private func mergeRequestData() {
        activityIndicator.startAnimating()
        mergeRequestService.mergeRequestChanges(id: id, iid: iid) { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let changes):
                    welf.changes = changes
                    welf.mergeRequestTableView.reloadData()
                case .error(let error):
                    let delayTime = welf.refreshControl.isRefreshing ? 1.0 : 0.0
                    DispatchQueue.main.asyncAfter(deadline: .now() + delayTime) {
                        let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                        welf.present(alert, animated: true)
                    }
                }
                welf.refreshControl.endRefreshing()
                welf.activityIndicator.stopAnimating()
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
        mergeRequestData()
        activityIndicator.stopAnimating()
    }
    
    private func setUpCell(_ cell: MergeRequestTableViewCell, with change: MergeRequestChange) -> MergeRequestTableViewCell {
        
        let color: UIColor
        
        switch change.state {
        case .new:
            color = Constants.Colors.mainGreen.value
        case .deleted:
            color = Constants.Colors.mainRed.value
        case .modified:
            color = Constants.Colors.mainOrange.value
        }
        
        let model = MergeRequestChangesViewModel(with: change.newPath, color: color)
        
        cell.setup(with: model)
        
        return cell
    }
    
    private func selectRow(with indexPath: IndexPath) {
        let models = converter.viewModels(from: changes[indexPath.row])
        self.router?.navigateToScreen(with: .mergeRequestChanges(models: models, title: changes[indexPath.row].newPath), animated: true)
    }
    
}

extension MergeRequestViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return changes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MergeRequestTableViewCell.identifier(), for: indexPath) as? MergeRequestTableViewCell else {
            fatalError(GitLabError.Cell.invalidIdentifier.rawValue + MergeRequestTableViewCell.identifier())
        }
        let change = changes[indexPath.row]
        return setUpCell(cell, with: change)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            guard let welf = self else { return }
            if welf.mergeRequestTableView != nil {
                welf.mergeRequestTableView.reloadData()
            }
        }
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return mergeRequestCell.cellSize(with: changes[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectRow(with: indexPath)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
}

extension MergeRequestViewController: LikeButtonToolbarViewDelegate {
    
    func likeButtonPressed() {
        toolbarLikeView?.buttonAppear(with: isLikeButtonPressed)
    }
    
}
