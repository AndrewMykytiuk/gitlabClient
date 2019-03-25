//
//  ProfileRequest.swift
//  GitlabClient
//
//  Created by User on 22/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct ProfileRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    var path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String, token: String) {
        self.HTTPMethod = method
        self.path = path
        
        let params: [String: Any] = [Constants.KeyValues.accessTokenKey.rawValue: token]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
