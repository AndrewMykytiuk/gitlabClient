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
    private var data: [String?] = []
    private var labels: [String] = []
    
    func configure(with loginService: LoginService, profileService: ProfileService) {
        self.loginService = loginService
        self.profileService = profileService
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        
        profileService?.getUser { (result) in
            switch result {
            case .success(let user):
                self.setup(with: user)
                DispatchQueue.main.async {
                    self.profileTableView.reloadData()
                }
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                self.present(alert, animated: true)
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
        self.data.append(user.email)
        self.data.append(user.location)
        self.data.append(user.skype)
        self.data.append(user.linkedin)
        self.data.append(user.twitter)
        self.data.append(user.websiteUrl)
        
        self.labels.append(tableViewLabels.email.rawValue)
        self.labels.append(tableViewLabels.location.rawValue)
        self.labels.append(tableViewLabels.skype.rawValue)
        self.labels.append(tableViewLabels.linkdn.rawValue)
        self.labels.append(tableViewLabels.twitter.rawValue)
        self.labels.append(tableViewLabels.website.rawValue)
        
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
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ProfileTableViewCell", for: indexPath) as? ProfileTableViewCell else {
            fatalError("The dequeued cell is not an instance of ProfileTableViewCell.")
        }
            cell.infoLabel.text = labels[indexPath.row]
            cell.dataLabel.text = data[indexPath.row]
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let attributes = [NSAttributedString.Key.font:UIFont(name: "Symbol", size: 17)]
        let string = data[indexPath.row]
        
        guard let text = string, text.count > 0 else  {
            return 0
        }
        
        let rect = NSString(string: text).boundingRect(
            with: CGSize(width: tableView.frame.width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        let height = 8 + rect.height + 8
        
        return height
    }
    
    
}
