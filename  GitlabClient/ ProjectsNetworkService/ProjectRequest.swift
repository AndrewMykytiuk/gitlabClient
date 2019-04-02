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
    
    var path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, path: String) {
        self.HTTPMethod = method
        self.path = path
        let params: [String: Any] = [Constants.KeyValues.membershipKey.rawValue: Constants.KeyValues.membershipYesKey.rawValue]
        let sorted = params.sorted {$0.key < $1.key}
        self.parameters = sorted
    }
    
}
