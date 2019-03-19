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
    associatedtype Destination
    func navigateToScreen(with identifier: Destination, animated: Bool)
}

class Router: MainRouterType, ApplicationRouterType {
    

    private var factory: ViewControllerFactory
    static var rootVC: UINavigationController?
    static var authRootVC: UINavigationController?
    
    enum Destination: String {
        case oauth = "OAuthLogInViewController"
        case main = "MainViewController"
    }
    
     init(factory: ViewControllerFactory) {
        self.factory = factory
    }
    
    func navigateToScreen(with identifier: Destination, animated: Bool) {
        
        var vc = BaseViewController()
        
        switch identifier {
        case .oauth:
            vc = factory.createNewVc(with: .oauth)
            vc.router = self
            Router.authRootVC?.pushViewController(vc, animated: animated)
        case .main:
            vc = factory.createNewVc(with: .main)
            vc.router = self
            let mainNavigationVC = Router.rootVC
            mainNavigationVC?.pushViewController(vc, animated: animated)
        }
        
    }
    
    func initializeStartNavigationFromWindow(_ window: UIWindow?) {
        
        let mainViewController = factory.createNewVc(with: .main)
        let mainNavigationController = UINavigationController(rootViewController: mainViewController)
        window?.rootViewController = mainNavigationController
        
        mainViewController.router = self
        Router.rootVC = mainNavigationController
        
        let loginNavigationController = createAuthNavigation()
        mainNavigationController.present(loginNavigationController, animated: false, completion: nil)
    }
    
    func createAuthNavigation() -> UINavigationController {
        
        let loginViewController = factory.createNewVc(with: .login)
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        
        loginViewController.router = self
        Router.authRootVC = loginNavigationController

        return loginNavigationController
    }
    
}

extension Router : OAuthDidFinishLoginDelegate {
    
    func didFinishDownloading(with token: String) {
        
    }
    
    
}
