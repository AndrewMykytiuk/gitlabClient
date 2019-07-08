//
//  MergeRequestApproveRequest.swift
//  GitlabClient
//
//  Created by User on 03/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

struct MergeRequestApproveRequest: Request {
    
    let HTTPMethod: HTTPMethod
    
    let path: String
    
    var parameters: [(key: String, value: Any)]
    
    init(method: HTTPMethod, projectId: Int, iid: Int,  isApprove: Bool) {
        self.HTTPMethod = method
        var path = Constants.Network.Path.api.rawValue + Constants.Network.Path.projects.rawValue + "/\(projectId)/" + Constants.Network.MergeRequest.mergeRequestsKey.rawValue + "/\(iid)/"
        path += isApprove ? Constants.Network.ApproveKey.approve.rawValue : Constants.Network.ApproveKey.unapprove.rawValue
        self.path = path
        self.parameters = []
    }
    
}
