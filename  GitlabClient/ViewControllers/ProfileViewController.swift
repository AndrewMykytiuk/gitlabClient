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
    @IBOutlet weak var profileTableView: UITableView!
    
    weak var delegate: ProfileViewControllerDelegate?
    private var loginService: LoginService!
    private var profileService: ProfileService!
    private var userData: [ProfileItemViewModel]?
    
    func configure(with loginService: LoginService, profileService: ProfileService) {
        self.loginService = loginService
        self.profileService = profileService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        profileService?.getUser { [weak self] (result) in
            guard let welf = self else { return }
            switch result {
            case .success(let user):
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
    
    func setup (with user:User) {
        if let data = try? Data(contentsOf: user.avatarUrl) {
        DispatchQueue.main.async {
            self.avatarImage.image = UIImage(data: data)
            self.nameLabel.text = user.name
            self.statusLabel.text = user.bio
        }}
        
        let email = ProfileItemViewModel.init(title: tableViewLabels.email.rawValue, description: user.email)
        let location = ProfileItemViewModel.init(title: tableViewLabels.location.rawValue, description: user.location)
        let skype = ProfileItemViewModel.init(title: tableViewLabels.skype.rawValue, description: user.skype)
        let linkedin = ProfileItemViewModel.init(title: tableViewLabels.linkdn.rawValue, description: user.linkedin)
        let twitter = ProfileItemViewModel.init(title: tableViewLabels.twitter.rawValue, description: user.twitter)
        let website = ProfileItemViewModel.init(title: tableViewLabels.website.rawValue, description: user.websiteUrl)
        
        userData?.append(email); userData?.append(location); userData?.append(skype);
        userData?.append(linkedin); userData?.append(twitter); userData?.append(website)
        
        
        
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
    
    private enum tableViewLabels: String {
        case email = "Email"
        case location = "Location"
        case skype = "Skype"
        case linkdn = "Linkedin"
        case twitter = "Twitter"
        case website = "Website"
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ProfileTableViewCell.identifier, for: indexPath) as? ProfileTableViewCell else {
            fatalError(FatalError.invalidCellCreate.rawValue + ProfileTableViewCell.identifier)
        }
        cell.titleLabel.text = userData?[indexPath.row].title
        cell.descriptionLabel.text = userData?[indexPath.row].description
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont(name: Constants.Fonts.symbol.info.name, size: Constants.Fonts.symbol.info.size)]
        let string = userData?[indexPath.row].description
        
        guard let text = string, text.count > 0 else {
            return 0
        }
        
        let rect = NSString(string: text).boundingRect(
            with: CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        let height = ProfileTableViewCell.cellOffset + rect.height + ProfileTableViewCell.cellOffset
        
        return height
    }
    
    
}
