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
    
    weak var delegate: ProfileViewControllerDelegate?
    private var loginService: LoginService!
    private var profileService: ProfileService!
    
    func configure(with loginService: LoginService, profileService: ProfileService) {
        self.loginService = loginService
        self.profileService = profileService
    }
    
    override func loadView() {
        super.loadView()
        
        profileService?.getUser { (result) in
            switch result {
            case .success:
                _ = 12
            case .error:
                break
            }
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
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
