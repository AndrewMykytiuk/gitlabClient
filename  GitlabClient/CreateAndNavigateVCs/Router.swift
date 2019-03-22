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
    private var tabBarVC: UITabBarController?
    
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
        var profileViewController = factory.createNewVc(with: .profile)
        
        if let profileVC = profileViewController as? ProfileViewController {
            profileVC.delegate = self
            profileViewController = profileVC
        }
        
        let mainTabBarController = factory.createNewTabBarVC(with: mainViewController, profileViewController: profileViewController)
        
        let mainNavigationController = UINavigationController(rootViewController: mainTabBarController)
        window?.rootViewController = mainNavigationController
        
        mainViewController.router = self
        profileViewController.router = self
        self.rootVC = mainNavigationController
        self.tabBarVC = mainTabBarController
        
        let loginNavigationController = createAuthNavigation()
        mainNavigationController.present(loginNavigationController, animated: false, completion: nil)
    }
    
   private func createAuthNavigation() -> UINavigationController {
        
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

extension Router : ProfileViewControllerDelegate {
    
    func viewControllerLogOut(profileViewController: ProfileViewController) {
        let loginNavigationController = self.createAuthNavigation()
        self.tabBarVC?.selectedIndex = Constants.TabBarItemIndexes.main.rawValue
        DispatchQueue.main.async {
            self.rootVC?.present(loginNavigationController, animated: false, completion: nil)
        }
    }
    
}
