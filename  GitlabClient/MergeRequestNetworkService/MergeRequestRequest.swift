//
//  MergeRequest.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    let path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String) {
        self.HTTPMethod = method
        self.path = path
        self.parameters = [(key: Constants.Network.Authorize.Keys.stateKey.rawValue, value: Constants.Network.MergeRequest.stateOpenedValue.rawValue)]
    }
    
}
