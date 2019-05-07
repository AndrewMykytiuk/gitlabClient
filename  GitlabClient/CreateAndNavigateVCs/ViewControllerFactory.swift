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
    
    enum ViewControllerIdentifier {
        case oauth
        case login
        case main
        case profile
        case mergeRequest(MergeRequest)
        case mergeRequestChanges(MergeRequestChanges)
        
        var value: String {
            switch self {
            case .oauth:
                return "OAuthLogInViewController"
            case .login:
                return "LogInViewController"
            case .main:
                return "MainViewController"
            case .profile:
                return "ProfileViewController"
            case .mergeRequest:
                return "MergeRequestViewController"
            case .mergeRequestChanges:
                return "MergeRequestChangesViewController"
            }
        }
    }
    
    init(provider: DependencyProvider) {
        self.dependencyProvider = provider
    }
    
    func createNewVc(with identifier: ViewControllerIdentifier) -> BaseViewController {
        
        guard var vcTemp = storyboard.instantiateViewController(withIdentifier: identifier.value) as? BaseViewController else { fatalError(FatalError.invalidStoryboardCreate.rawValue) }
        
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
        case .mergeRequest(let request):
            if let mergeRequestViewController = vcTemp as? MergeRequestViewController {
                let mergeRequestService = MergeRequestService(networkManager: dependencyProvider.networkManager)
                mergeRequestViewController.configure(with: mergeRequestService)
                mergeRequestViewController.setUpMergeRequestInfo(id: request.projectId, iid: request.iid)
                vcTemp = mergeRequestViewController
            }
        case .mergeRequestChanges(let change):
            if let mergeRequestChangesViewController = vcTemp as? MergeRequestChangesViewController {
                mergeRequestChangesViewController.configureMergeRequestChangesInfo(change: change)
                vcTemp = mergeRequestChangesViewController
            }
        }
        return vcTemp
    }
 
    func createNewTabBarVC(with mainViewController: UINavigationController, profileViewController: BaseViewController) -> UITabBarController {
        
        mainViewController.tabBarItem = UITabBarItem(title: Constants.TabBarItemNames.main.info.description, image: UIImage(named: "file-three-7"), tag: Constants.TabBarItemNames.main.info.index)
        profileViewController.tabBarItem = UITabBarItem(title: Constants.TabBarItemNames.profile.info.description, image: UIImage(named: "circle-user-7"), tag: Constants.TabBarItemNames.profile.info.index)
        
        let viewControllers = [mainViewController, profileViewController]
        
        let tapBarController = UITabBarController()
        tapBarController.viewControllers = viewControllers
        
        return tapBarController
    }
    
}
