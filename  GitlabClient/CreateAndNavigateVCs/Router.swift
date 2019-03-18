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
    func navigateFromWindow(_ window: UIWindow?)
}

protocol MainRouterType {
    associatedtype Identifier
    func navigateToScreen(with identifier: Identifier, animated: Bool)
}

class Router: MainRouterType, ApplicationRouterType {
    
    private var factory: ViewControllerFactory
    
    internal enum Identifier: String {
        case oauth = "OAuthLogInViewController"
        case main = "MainViewController"
    }
    
     init(factory: ViewControllerFactory) {
        self.factory = factory
    }
    
    func navigateToScreen(with identifier: Identifier, animated: Bool) {
        
        var vc = BaseViewController()
        
        switch identifier {
        case .oauth:
            vc = factory.createNewVc(with: .oauth)
            vc.router = self
        case .main:
            vc = factory.createNewVc(with: .main)
            vc.router = self
        }
        
       let mainNavigation = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
        mainNavigation?.pushViewController(vc, animated: animated)
    }
    
    func navigateFromWindow(_ window: UIWindow?) {
        
        let rootViewController = factory.createNewVc(with: .login)
        rootViewController.router = self
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
    }
    
}
