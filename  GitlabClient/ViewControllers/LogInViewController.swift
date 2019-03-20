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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
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
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        logInButton.isEnabled = false
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            
            self.activityIndicator.stopAnimating()
            self.logInButton.isEnabled = true
            
            self.router?.navigateToScreen(with: .oauth, animated: true)
        }
    }
    
}

