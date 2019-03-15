//
//  Result.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

enum Result<T> {
    case success(T)
    case error(Error)
}
