//
//  ViewControllerFactory.swift
//  RealProject
//
//  Created by User on 12/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import UIKit

protocol ViewControllerFactoryType {
    associatedtype Identifier
    func createNewVc(with identifier: Identifier) -> BaseViewController
}

class ViewControllerFactory: ViewControllerFactoryType {
    
    enum Identifier: String {
        case main = "OAuthLogInViewController"
        case login = "LogInViewController"
        case settings = ""
    }
    
    func createNewVc(with identifier: Identifier) -> BaseViewController {
        
        var vc = BaseViewController()
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        if let vcTemp = storyboard.instantiateViewController(withIdentifier: identifier.rawValue) as? BaseViewController {
        vc = vcTemp
        switch identifier {
        case .main:
            _ = 9
        case .settings:
            _ = 10
        case .login:
            _ = 11
        }
        }
        return vc
    }
 
}
