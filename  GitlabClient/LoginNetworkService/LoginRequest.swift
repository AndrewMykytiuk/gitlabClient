//
//  LoginRequest.swift
//  GitlabClient
//
//  Created by User on 15/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct LoginRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    var path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String, code: String) {
        self.HTTPMethod = method
        self.path = path
        
        let params: [String: Any] = [Constants.AuthorizeKeyValues.clientIDKey.rawValue: Constants.Network.clientID.rawValue,
        Constants.AuthorizeKeyValues.clientSecretKey.rawValue: Constants.Network.clientSecret.rawValue,
        Constants.Network.responseType.rawValue: code,
        Constants.AuthorizeKeyValues.grantTypeKey.rawValue: Constants.Network.grantType.rawValue, Constants.AuthorizeKeyValues.redirectURLKey.rawValue: Constants.Network.redirectURL.rawValue]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
