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
}

class DependencyProvider: DependencyProviderType {
    let networkManager = NetworkManager()
}
