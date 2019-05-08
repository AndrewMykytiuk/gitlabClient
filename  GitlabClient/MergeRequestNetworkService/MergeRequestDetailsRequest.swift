//
//  MergeRequestDetailsRequest.swift
//  GitlabClient
//
//  Created by User on 07/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestDetailsRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    let path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, pathComponents: [String]) {
        self.HTTPMethod = method
        var requestPath = ""
        for component in pathComponents {
            requestPath.append(component + "/")
        }
        self.path = Constants.Network.Path.api.rawValue + requestPath.dropLast()
        self.parameters = [(key: Constants.Network.Authorize.Keys.stateKey.rawValue, value: Constants.Network.MergeRequest.stateOpenedValue.rawValue)]
    }
    
}
