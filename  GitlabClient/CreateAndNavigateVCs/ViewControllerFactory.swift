//
//  ViewControllerFactory.swift
//  RealProject
//
//  Created by User on 12/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryType {
    associatedtype ViewControllerIdentifier
    func createNewVc(with identifier: ViewControllerIdentifier) -> BaseViewController
}

class ViewControllerFactory: ViewControllerFactoryType {
    
    private let storyboard = UIStoryboard(name: "Main", bundle: nil)
    private let dependencyProvider: DependencyProvider
    
    enum ViewControllerIdentifier: String {
        case oauth = "OAuthLogInViewController"
        case login = "LogInViewController"
        case main = "MainViewController"
        case profile = "ProfileViewController"
        case mergeRequest = "MergeRequestViewController"
    }
    
    init(provider: DependencyProvider) {
        self.dependencyProvider = provider
    }
    
    func createNewVc(with identifier: ViewControllerIdentifier) -> BaseViewController {
        
        guard var vcTemp = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? BaseViewController else { fatalError(FatalError.invalidStoryboardCreate.rawValue) }
        
        switch identifier {
        case .main:
            if let mainViewController = vcTemp as? MainViewController {
                let projectsService = ProjectService(networkManager: dependencyProvider.networkManager)
                mainViewController.configure(with: projectsService)
                vcTemp = mainViewController
            }
        case .oauth:
            if let oAuthLogInViewController = vcTemp as? OAuthLogInViewController {
                let loginService = LoginService(networkManager: dependencyProvider.networkManager, keychainItem: dependencyProvider.keychainItem)
                oAuthLogInViewController.configure(with: loginService)
                
                vcTemp = oAuthLogInViewController
            }
        case .login:
            _ = 11
        case .profile:
            if let profileViewController = vcTemp as? ProfileViewController {
                let loginService = LoginService(networkManager: dependencyProvider.networkManager, keychainItem: dependencyProvider.keychainItem)
                let profileService = ProfileService(networkManager: dependencyProvider.networkManager)
                profileViewController.configure(with: loginService, profileService: profileService)
                vcTemp = profileViewController
            }
        case .mergeRequest:
            if let mergeRequestViewController = vcTemp as? MergeRequestViewController {
                let mergeRequestService = MergeRequestService(networkManager: dependencyProvider.networkManager)
                mergeRequestViewController.configure(with: mergeRequestService)
                vcTemp = mergeRequestViewController
            }
        }
        return vcTemp
    }
 
    func createNewTabBarVC(with mainViewController: UINavigationController, profileViewController: BaseViewController) -> UITabBarController {
        
        mainViewController.tabBarItem = UITabBarItem(title: Constants.TabBarItemNames.main.info.description, image: #imageLiteral(resourceName: "file-three-7.png"), tag: Constants.TabBarItemNames.main.info.index)
        profileViewController.tabBarItem = UITabBarItem(title: Constants.TabBarItemNames.profile.info.description, image: #imageLiteral(resourceName: "circle-user-7.png"), tag: Constants.TabBarItemNames.profile.info.index)
        
        let viewControllers = [mainViewController, profileViewController]
        
        let tapBarController = UITabBarController()
        tapBarController.viewControllers = viewControllers
        
        return tapBarController
    }
    
}
