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
        
        let params: [String: Any] = [Constants.Network.Authorize.Keys.clientIDKey.rawValue: Constants.Network.Authorize.Values.clientIDValue.rawValue,
        Constants.Network.Authorize.Keys.clientSecretKey.rawValue: Constants.Network.Authorize.Values.clientSecretValue.rawValue,
        Constants.Network.Authorize.Keys.codeKey.rawValue: code,
        Constants.Network.Authorize.Keys.grantTypeKey.rawValue: Constants.Network.Authorize.Values.grantTypeValue.rawValue, Constants.Network.Authorize.Keys.redirectURLKey.rawValue: Constants.Network.Authorize.Values.redirectURLValue.rawValue]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
