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
    }
    
    init(provider: DependencyProvider) {
        self.dependencyProvider = provider
    }
    
    func createNewVc(with identifier: ViewControllerIdentifier) -> BaseViewController {
        
        guard var vcTemp = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? BaseViewController else { fatalError(FatalError.invalidStoryboardCreate.rawValue) }
        
        switch identifier {
        case .main:
            _ = 9
        case .oauth:
            if let oAuthLogInViewController = vcTemp as? OAuthLogInViewController {
                oAuthLogInViewController.loginManager = LoginService(networkManager: dependencyProvider.networkManager, keychainItem: dependencyProvider.keychainItem)
                
                vcTemp = oAuthLogInViewController
            }
        case .login:
            _ = 11
        }
        return vcTemp
    }
 
}
