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
    func initializeStartNavigationFromWindow(_ window: UIWindow?)
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
           let authNavigationVC =  UIApplication.shared.delegate?.window??.rootViewController?.presentedViewController as? UINavigationController
//            let mainNavigation =  UIApplication.shared.delegate?.window??.rootViewController?.children.last as? UINavigationController
            authNavigationVC?.pushViewController(vc, animated: animated)
        case .main:
            vc = factory.createNewVc(with: .main)
            vc.router = self
            let mainNavigationVC = UIApplication.shared.delegate?.window??.rootViewController as? UINavigationController
            mainNavigationVC?.pushViewController(vc, animated: animated)
        }
        
    }
    
    func initializeStartNavigationFromWindow(_ window: UIWindow?) {
        
        let mainViewController = factory.createNewVc(with: .main)
        let loginViewController = factory.createNewVc(with: .login)
        
        mainViewController.router = self
        loginViewController.router = self
        
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = mainNavigationController
        
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        window?.rootViewController?.present(loginNavigationController, animated: false, completion: nil)
        //loginNavigationController.didMove(toParent: window?.rootViewController)
    }
    
}
