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
        }
    }
    
    private var projectsService: ProjectService!
    private var projectsCell: ProjectsTableViewCell!
    private var tableViewInfoDictionary: [Project:[MergeRequest]] = [:]
    private let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
    
    func configure(with projectsService: ProjectService) {
        self.projectsService = projectsService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        setupActivityIndicator(with: self.view)
        getData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.projectsCell.frame = CGRect(origin: CGPoint.zero, size: projectsTableView.frame.size)
        self.projectsCell.layoutIfNeeded()
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
    
    private func getData() {
        activityIndicator.startAnimating()
        projectsService?.getProjectsInfo { [weak self] (result) in
            guard let welf = self else { return }
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    welf.tableViewInfoDictionary = data
                    welf.activityIndicator.stopAnimating()
                    welf.projectsTableView.reloadData()
                case .error(let error):
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
            return Array(tableViewInfoDictionary)[section].key.name
        } else {
            return nil
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return tableViewInfoDictionary.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableViewInfoDictionary.count > 0 {
            return Array(tableViewInfoDictionary)[section].value.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProjectsTableViewCell.identifier(), for: indexPath) as? ProjectsTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + ProjectsTableViewCell.identifier())
        }
        if tableViewInfoDictionary.count > 0 {
            cell.setup(with: Array(tableViewInfoDictionary)[indexPath.section].value[indexPath.row])
        }
        
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return calculateCellHeight(with: indexPath)
    }
    
    private func calculateCellHeight(with indexPath: IndexPath) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        
        var height: CGFloat = 0
        
        let names = projectsCell.getStaticNames()
        
        if tableViewInfoDictionary.count > 0 {
            let request = Array(tableViewInfoDictionary)[indexPath.section].value[indexPath.row]
            let size = projectsCell.getLabelsSize(with:request)
            
            let mergeRequestTitleRect = NSString(string: request.title).boundingRect(
                with: CGSize(width: size.mergeRequest.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            let authorNameRect = NSString(string: names.author).boundingRect(
                with: CGSize(width: size.authorName.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            let assignToRect = NSString(string: names.assign).boundingRect(
                with: CGSize(width: size.assignName.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            let authorDataRect = NSString(string: request.authorName).boundingRect(
                with: CGSize(width: size.authorNameData.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            let assignDataRect = NSString(string: request.assigneeName).boundingRect(
                with: CGSize(width: size.assignNameData.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            let mergeRequestDescriptionRect = NSString(string: request.description).boundingRect(
                with: CGSize(width: size.mergeRequestDesription.width, height: CGFloat.greatestFiniteMagnitude),
                options: [.usesLineFragmentOrigin, .usesFontLeading],
                attributes: attributes as [NSAttributedString.Key : Any], context: nil)
            
            height = ceil(mergeRequestTitleRect.height) + max(authorNameRect.height, assignToRect.height) + max(authorDataRect.height, assignDataRect.height) + ceil(mergeRequestDescriptionRect.height)
            
            height += projectsCell.cellOffsets()
        }
        return height
    }
    
}

