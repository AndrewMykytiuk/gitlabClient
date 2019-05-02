//
//  URLHelper.swift
//  GitlabClient
//
//  Created by User on 15/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class URLHelper {
    
    static func createBaseAuthUrlComponents() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = Constants.Network.secureScheme.rawValue
        components.host = Constants.Network.host.rawValue
        components.queryItems = []
        
        return components
    }
    
}
