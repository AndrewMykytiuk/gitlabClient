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
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var locationTF: UITextField!
    @IBOutlet weak var skypeTF: UITextField!
    @IBOutlet weak var linkedinTF: UITextField!
    @IBOutlet weak var twitterTF: UITextField!
    @IBOutlet weak var websiteUrlTF: UITextField!
    
    weak var delegate: ProfileViewControllerDelegate?
    private var loginService: LoginService!
    private var profileService: ProfileService!
    
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
            case .error(let error):
                let alert = AlertHelper.createErrorAlert(message: error.localizedDescription, handler: nil)
                self.present(alert, animated: true)
            }
        }
        
    }
    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        avatarImage.layer.cornerRadius = avatarImage.frame.height / 2
//    }
    
    func setup (with user:User) {
        if let data = try? Data(contentsOf: user.avatarUrl) {
        DispatchQueue.main.async {
            self.avatarImage.image = UIImage(data: data)
        }
        }
        DispatchQueue.main.async {
            self.nameLabel.text = user.name
            self.statusLabel.text = user.bio
            self.emailTF.text = user.email
            self.locationTF.text = user.location
            self.skypeTF.text = user.skype
            self.linkedinTF.text = user.linkedin
            self.twitterTF.text = user.twitter
            self.websiteUrlTF.text = user.websiteUrl
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
