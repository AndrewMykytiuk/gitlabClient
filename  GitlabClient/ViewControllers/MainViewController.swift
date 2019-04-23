//
//  MainViewController.swift
//  GitlabClient
//
//  Created by User on 18/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {
    
    @IBOutlet weak var projectsTableView: UITableView! {
        didSet {
            createProjectsCellPrototype()
            projectsTableView.refreshControl = refreshControl
        }
    }
    
    private var projectsService: ProjectService!
    private var projectsCell: ProjectsTableViewCell!
    private var tableViewInfoDictionary: [(key: Project, value: [MergeRequest])] = []
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
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.projectsCell.frame = CGRect(origin: CGPoint.zero, size: projectsTableView.frame.size)
        self.projectsCell.layoutIfNeeded()
    }
    
    private func setupRefreshControl() {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        refreshControl.addTarget(self, action: #selector(refreshProjectsData(_:)), for: .valueChanged)
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
    
    @objc private func refreshProjectsData(_ sender: Any) {
        getData()
         activityIndicator.stopAnimating()
    }
    
    private func getData() {
        activityIndicator.startAnimating()
        projectsService.getProjectsInfo { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    welf.tableViewInfoDictionary = data
                    welf.refreshControl.endRefreshing()
                    welf.activityIndicator.stopAnimating()
                    welf.projectsTableView.reloadData()
                case .error(let error):
                    welf.refreshControl.endRefreshing()
                    welf.activityIndicator.stopAnimating()
                    let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                    welf.present(alert, animated: true)
                    
                }
            }
        }
    }
    
    private func createProjectsCellPrototype() {
        let cell = self.projectsTableView.dequeueReusableCell(withIdentifier: ProjectsTableViewCell.identifier()) as? ProjectsTableViewCell
        if let tempCell = cell {
            projectsCell = tempCell
        }
    }
    
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if tableViewInfoDictionary.count > 0 {
            return tableViewInfoDictionary[section].key.name
        } else {
            return nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewInfoDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewInfoDictionary.count > 0 {
            return tableViewInfoDictionary[section].value.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsTableViewCell.identifier(), for: indexPath) as? ProjectsTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + ProjectsTableViewCell.identifier())
        }
        
        cell.setup(with: tableViewInfoDictionary[indexPath.section].value[indexPath.row], isExpanded: indexPathOfExpendedCell.contains(indexPath))
        cell.delegate = self
        
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: newCollection.accessibilityFrame.size, with: coordinator)
        
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
        return projectsCell.getCellSize(with: tableViewInfoDictionary[indexPath.section].value[indexPath.row], isExpanded: indexPathOfExpendedCell.contains(indexPath))
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

