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
    private var mainRootVC: UINavigationController?
    private let keychainItem: KeychainItem
    
    enum Destination {
        case oauthController
        case mainController
        case mergeRequestController(MergeRequest)
    }
    
    init(factory: ViewControllerFactory,
         keychainItem: KeychainItem) {
        self.factory = factory
        self.keychainItem = keychainItem
    }
    
    func navigateToScreen(with identifier: Destination, animated: Bool) {
        
        switch identifier {
        case .oauthController:
            let vc = factory.createNewVc(with: .oauth)
            vc.router = self
            if let authVC = vc as? OAuthLogInViewController {
                authVC.delegate = self
                self.authRootVC?.pushViewController(authVC, animated: animated)
            } else {
                self.authRootVC?.pushViewController(vc, animated: animated)
            }
        case .mainController:
            let vc = factory.createNewVc(with: .main)
            vc.router = self
            let mainNavigationVC = self.mainRootVC
            mainNavigationVC?.pushViewController(vc, animated: animated)
        case .mergeRequestController(let request):
            let vc = factory.createNewVc(with: .mergeRequest)
            vc.router = self
            if let mergeRequestVC = vc as? MergeRequestViewController {
                mergeRequestVC.setUpMergeRequestInfo(id: request.projectId, iid: request.iid)
                self.tabBarVC?.hidesBottomBarWhenPushed = false
                self.mainRootVC?.pushViewController(mergeRequestVC, animated: true)
            }
        }
    }
    
    func navigate(from window: UIWindow?) {
        
        
        let mainViewController = factory.createNewVc(with: .main)
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        var profileViewController = factory.createNewVc(with: .profile)
        
        if let profileVC = profileViewController as? ProfileViewController {
            profileVC.delegate = self
            profileViewController = profileVC
        }
        
        let mainTabBarController = factory.createNewTabBarVC(with: mainNavigationController, profileViewController: profileViewController)
        
        let mainTabBarNavigationController = UINavigationController(rootViewController: mainTabBarController)
        window?.rootViewController = mainTabBarNavigationController
        
        mainViewController.router = self
        profileViewController.router = self
        self.rootVC = mainTabBarNavigationController
        self.tabBarVC = mainTabBarController
        self.mainRootVC = mainNavigationController
        
        switch keychainItem.readToken() {
        case .success:
            break
        case .error:
            let loginNavigationController = createAuthNavigation()
            mainTabBarNavigationController.present(loginNavigationController, animated: false, completion: nil)
        }
        
        mainTabBarNavigationController.isNavigationBarHidden = true
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
    
    func viewControllerDidFinishWithError(oAuthViewController: OAuthLogInViewController) {
        DispatchQueue.main.async {
            self.authRootVC?.popToRootViewController(animated: false)
        }
    }
    
}

extension Router : ProfileViewControllerDelegate {
    
    func viewControllerLogOut(profileViewController: ProfileViewController) {
        let loginNavigationController = self.createAuthNavigation()
        DispatchQueue.main.async {
            self.rootVC?.present(loginNavigationController, animated: false, completion: nil)
            self.tabBarVC?.selectedIndex = Constants.TabBarItemNames.main.info.index
        }
    }
    
}
