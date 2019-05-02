//
//  ProjectRequest.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct ProjectRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    let path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String) {
        self.HTTPMethod = method
        self.path = path
        self.parameters = [(key: Constants.Network.ProjectRequest.membershipKey.rawValue, value: Constants.Network.ProjectRequest.membershipYesValue.rawValue)]
    }
    
}
