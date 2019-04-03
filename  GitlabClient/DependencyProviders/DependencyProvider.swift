//
//  DependencyProvider.swift
//  GitlabClient
//
//  Created by User on 19/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol DependencyProviderType {
    var networkManager: NetworkManager { get }
    var keychainItem: KeychainItem { get }
}

class DependencyProvider: DependencyProviderType {
    
    lazy var networkManager: NetworkManager = {
        let networkManager = NetworkManager()
        switch keychainItem.readToken() {
        case .success(let string):
            networkManager.configure(token: string)
        case .error(_):
            networkManager.configure(token: nil)
        }
        
        return networkManager
    }()
    
    let keychainItem = KeychainItem()
}
