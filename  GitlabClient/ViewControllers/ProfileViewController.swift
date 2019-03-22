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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }

    @IBAction func logOutButtonAction(_ sender: UIButton) {
        self.delegate?.viewControllerLogOut(profileViewController: self)
    }
    
}
