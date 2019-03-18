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
        
        let params: [String: Any] = ["client_id": globalConstants.clientID.rawValue, "client_secret": globalConstants.clientSecret.rawValue, "code": code, "grant_type": globalConstants.grantType.rawValue, "redirect_uri": globalConstants.redirectURL.rawValue]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
