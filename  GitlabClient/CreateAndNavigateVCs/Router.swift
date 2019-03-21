//
//  Router.swift
//  RealProject
//
//  Created by User on 12/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol ApplicationRouterType {
    func navigate(from window: UIWindow?)
}

protocol MainRouterType {
    associatedtype Destination
    func navigateToScreen(with identifier: Destination, animated: Bool)
}

class Router: MainRouterType, ApplicationRouterType {
    

    private let factory: ViewControllerFactory
    private var rootVC: UINavigationController?
    private var authRootVC: UINavigationController?
    
    enum Destination: String {
        case oauth = "OAuthLogInViewController"
        case main = "MainViewController"
    }
    
     init(factory: ViewControllerFactory) {
        self.factory = factory
    }
    
    func navigateToScreen(with identifier: Destination, animated: Bool) {
        
        switch identifier {
        case .oauth:
            let vc = factory.createNewVc(with: .oauth)
            vc.router = self
            if let authVC = vc as? OAuthLogInViewController {
                authVC.delegate = self
                self.authRootVC?.pushViewController(authVC, animated: animated)
            } else {
                self.authRootVC?.pushViewController(vc, animated: animated)
            }
        case .main:
            let vc = factory.createNewVc(with: .main)
            vc.router = self
            let mainNavigationVC = self.rootVC
            mainNavigationVC?.pushViewController(vc, animated: animated)
        }
        
    }
    
    func navigate(from window: UIWindow?) {
        
        let mainViewController = factory.createNewVc(with: .main)
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = mainNavigationController
        
        mainViewController.router = self
        self.rootVC = mainNavigationController
        
        let loginNavigationController = createAuthNavigation()
        mainNavigationController.present(loginNavigationController, animated: false, completion: nil)
    }
    
    func createAuthNavigation() -> UINavigationController {
        
        let loginViewController = factory.createNewVc(with: .login)
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        
        loginViewController.router = self
        self.authRootVC = loginNavigationController

        return loginNavigationController
    }
    
}

extension Router : OAuthLogInViewControllerDelegate {
    
    func viewControllerDidFinishLogin(oAuthViewController: OAuthLogInViewController) {
        DispatchQueue.main.async {
            self.rootVC?.dismiss(animated: true, completion: nil)
        }
    }
}
