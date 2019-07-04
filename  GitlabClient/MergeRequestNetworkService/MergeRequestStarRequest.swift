//
//  MergeRequestStar.swift
//  GitlabClient
//
//  Created by User on 03/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestStarRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    let path: String
    
    var parameters: [(key: String, value: Any)]
    
    private enum StarKey: String {
        case star = "star"
        case unstar = "unstar"
    }
    
    init(method: HTTPMethod, projectId: Int, isStar: Bool) {
        self.HTTPMethod = method
        var path = Constants.Network.Path.api.rawValue + Constants.Network.Path.projects.rawValue + "/\(projectId)/"
        path += isStar ? StarKey.star.rawValue : StarKey.unstar.rawValue
        self.path = path
        self.parameters = []
    }
    
}
