//
//  ProfileViewController.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol ProfileViewControllerDelegate: class {
    func viewControllerLogOut(profileViewController: ProfileViewController)
}

class ProfileViewController: BaseViewController {
    
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var profileTableView: UITableView! {
        didSet {
            createProfileCellPrototype()
        }
    }
    
    weak var delegate: ProfileViewControllerDelegate?
    private var loginService: LoginService!
    private var profileService: ProfileService!
    private var userData: [ProfileItemViewModel] = []
    private var profileCell: ProfileTableViewCell!
    
    
    func configure(with loginService: LoginService, profileService: ProfileService) {
        self.loginService = loginService
        self.profileService = profileService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        getUser()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.profileCell.frame = CGRect(origin: CGPoint.zero, size: profileTableView.frame.size)
        self.profileCell.layoutIfNeeded()
    }
    
    private func setup (with user:User) {
        if let data = try? Data(contentsOf: user.avatarUrl) {
        DispatchQueue.main.async {
            self.avatarImage.image = UIImage(data: data)
            self.nameLabel.text = user.name
            self.statusLabel.text = user.bio
        }}
        
        let email = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.email.rawValue, comment: ""), description: user.email)
        let location = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.location.rawValue, comment: ""), description: user.location)
        let skype = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.skype.rawValue, comment: ""), description: user.skype)
        let linkedin = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.linkdn.rawValue, comment: ""), description: user.linkedin)
        let twitter = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.twitter.rawValue, comment: ""), description: user.twitter)
        let website = ProfileItemViewModel(title: NSLocalizedString(tableViewTitles.website.rawValue, comment: ""), description: user.websiteUrl)
        
        userData.append(email)
        userData.append(location)
        userData.append(skype)
        userData.append(linkedin)
        userData.append(twitter)
        userData.append(website)
        
    }
    
    private func createProfileCellPrototype() {
        let cell = self.profileTableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier()) as? ProfileTableViewCell
        if let tempCell = cell {
            profileCell = tempCell
        }
    }
    
    private func getUser() {
        profileService?.getUser { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let user):
                welf.userData.removeAll()
                welf.setup(with: user)
                DispatchQueue.main.async {
                    welf.profileTableView.reloadData()
                }
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                welf.present(alert, animated: true)
            }
        }
    }

    @IBAction func logOutButtonAction(_ sender: UIButton) {
        
        loginService.logout { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success:
                welf.delegate?.viewControllerLogOut(profileViewController: welf)
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                welf.present(alert, animated: true)
            }
        }
        
    }
    
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    
    private enum tableViewTitles: String {
        case email = "Email"
        case location = "Location"
        case skype = "Skype"
        case linkdn = "Linkedin"
        case twitter = "Twitter"
        case website = "Website"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier(), for: indexPath) as? ProfileTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + ProfileTableViewCell.identifier())
        }
        
        cell.setup(with: userData[indexPath.row])
        
        return cell
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: newCollection.accessibilityFrame.size, with: coordinator)
        
        let completionHandler: ((UIViewControllerTransitionCoordinatorContext) -> Void) = { [weak self] (context) in
            guard let welf = self else { return }
            if welf.profileTableView != nil {
                welf.profileTableView.reloadData()
            }
        }
        coordinator.animate(alongsideTransition: completionHandler, completion: completionHandler)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        
        let titleString = userData[indexPath.row].title
        let descriptionString = userData[indexPath.row].description
        let size = profileCell.getLabelsSize(with: userData[indexPath.row])
        
        guard let descriptionText = descriptionString, descriptionText.count > 0 else {
            return 0
        }
        guard titleString.count > 0 else {
            return 0
        }
        
        let titleRect = NSString(string: titleString).boundingRect(
            with: CGSize(width: size.titleWidth, height: size.titleHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        let descriptionRect = NSString(string: descriptionText).boundingRect(
            with: CGSize(width: size.descriptionWidth, height: size.descriptionHeight),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        return max(descriptionRect.height, titleRect.height) + profileCell.verticalOffsets()
    }
    
    
}
