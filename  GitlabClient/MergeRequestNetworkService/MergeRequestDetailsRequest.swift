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
    
    init(method: HTTPMethod, path: [String]) {
        self.HTTPMethod = method
        var requestPast = ""
        for element in path {
            element == path.last ? requestPast.append(element) : requestPast.append(element + "/")
        }
        self.path = Constants.Network.Path.api.rawValue + requestPast
        self.parameters = [(key: Constants.Network.Authorize.Keys.stateKey.rawValue, value: Constants.Network.MergeRequest.stateOpenedValue.rawValue)]
    }
    
}
