//
//  LoginRequest.swift
//  GitlabClient
//
//  Created by User on 15/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct LoginRequest: Request {
   
    var HTTPMethod: HTTPMethod
    
     var path: String
    
     var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String, code: String) {
        self.HTTPMethod = method
        self.path = path
        
        let params: [String: Any] = ["client_id": clientID, "client_secret": clientSecret, "code": code, "grant_type": grantType, "redirect_uri": redirectURL]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
    //var parameters: [String : Any]
    
}
