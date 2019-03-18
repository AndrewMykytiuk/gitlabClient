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
        
        let params: [String: Any] = [globalConstants.clientIDKey.rawValue: globalConstants.clientID.rawValue,
        globalConstants.clientSecretKey.rawValue: globalConstants.clientSecret.rawValue,
        globalConstants.responseType.rawValue: code,
        globalConstants.grantTypeKey.rawValue: globalConstants.grantType.rawValue, globalConstants.redirectURLKey.rawValue: globalConstants.redirectURL.rawValue]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
