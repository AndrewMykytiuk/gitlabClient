//
//  LogInViewController.swift
//  RealProject
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

class LogInViewController: BaseViewController {

    @IBOutlet weak var logInButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLayoutSubviews() {
        logInButton.layer.cornerRadius = logInButton.frame.height / 2
    }
    
    @IBAction func loginButtonDidTouch(_ sender: UIButton) {
        self.router?.navigateToScreen(with: .oauth, animated: true)
    }
    
}

