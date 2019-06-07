//
//  MainViewController.swift
//  GitlabClient
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    
    @IBOutlet weak var noInfoInTableLabel: UILabel!
    @IBOutlet weak var projectsTableView: UITableView! {
        didSet {
            createProjectsCellPrototype()
            projectsTableView.refreshControl = refreshControl
        }
    }
    
    private var projectsService: ProjectService!
    private var projectsCell: ProjectsTableViewCell!
    private var projectsData: [Project] = []
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    private let refreshControl = UIRefreshControl()
    private var indexPathOfExpendedCell: [IndexPath] = []
    
    func configure(with projectsService: ProjectService) {
        self.projectsService = projectsService
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupActivityIndicator(with: self.view)
        setupRefreshControl()
        getData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        if projectsData.isEmpty {
            getData()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.projectsCell.frame = CGRect(origin: CGPoint.zero, size: projectsTableView.frame.size)
        self.projectsCell.layoutIfNeeded()
    }
    
    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshProjectsData(_:)), for: .valueChanged)
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
    
    @objc private func refreshProjectsData(_ sender: Any) {
        getData()
        activityIndicator.stopAnimating()
    }
    
    private func getData() {
        activityIndicator.startAnimating()
        projectsService.projectsInfo { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    welf.projectsData = data
                    welf.projectsTableView.isHidden = false
                    welf.projectsTableView.reloadData()
                    let isMergeRequestsExist = welf.hasMergeRequests(data)
                    welf.noInfoInTableLabel.isHidden = isMergeRequestsExist
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
    
    private func createProjectsCellPrototype() {
        let cell = self.projectsTableView.dequeueReusableCell(withIdentifier: ProjectsTableViewCell.identifier()) as? ProjectsTableViewCell
        if let tempCell = cell {
            projectsCell = tempCell
        }
    }
    
    private func hasMergeRequests(_ projects: [Project]) -> Bool {
        for project in projects {
            if !project.mergeRequest.isEmpty {
                return true
            }
        }
        return false
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if projectsData[section].mergeRequest.count > 0 {
           return projectsData[section].name
        } else {
            return nil
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return projectsData.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if projectsData.count > 0 {
            return projectsData[section].mergeRequest.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsTableViewCell.identifier(), for: indexPath) as? ProjectsTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + ProjectsTableViewCell.identifier())
        }
        
        cell.setup(with: projectsData[indexPath.section].mergeRequest[indexPath.row], isExpanded: indexPathOfExpendedCell.contains(indexPath))
        cell.delegate = self
        
        return cell
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            guard let welf = self else { return }
            if welf.projectsTableView != nil {
                welf.projectsTableView.reloadData()
            }
        }
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat.leastNonzeroMagnitude
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return projectsCell.getCellSize(with: projectsData[indexPath.section].mergeRequest[indexPath.row], isExpanded: indexPathOfExpendedCell.contains(indexPath))
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.router?.navigateToScreen(with: .mergeRequest(projectsData[indexPath.section].mergeRequest[indexPath.row]), animated: true)
        tableView.deselectRow(at: indexPath, animated: false)
    }
    
}

extension MainViewController: ProjectsTableViewCellDelegate {
    
    func moreTapped(cell: ProjectsTableViewCell) {
        guard let indexPath = projectsTableView.indexPath(for: cell) else { return }
        
        if  indexPathOfExpendedCell.contains(indexPath) {
            guard let index = indexPathOfExpendedCell.index(of: indexPath) else { return }
            indexPathOfExpendedCell.remove(at: index)
        } else {
            indexPathOfExpendedCell.append(indexPath)
        }
        
        self.projectsTableView.beginUpdates()
        self.projectsTableView.reloadRows(at: [indexPath], with: .automatic)
        self.projectsTableView.endUpdates()
    }
}

