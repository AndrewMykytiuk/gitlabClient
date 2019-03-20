//
//  Request.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import WebKit

protocol Request {
    var HTTPMethod: HTTPMethod { get }
    var path: String { get }
    var parameters: [(key: String, value: Any)] { get set }
}

enum HTTPMethod: String {
    case POST = "POST"
    case GET = "GET"
    case DELETE = "DELETE"
    case PUT = "PUT"
}
