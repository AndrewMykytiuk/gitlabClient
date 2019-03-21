//
//  Errors.swift
//  GitlabClient
//
//  Created by User on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

enum ParsingError: Error {
    case wrongEnterData(_ data: Data)
    case wrongProccessing(_ string: String)
    case wrongInstrumentsFor(_ string: String)
    case emptyResult(_ string: String?)
}

enum NetworkError: Error {
    case invalidUrl(_ string: String)
    case invalidRequest(_ request: Request)
    case invalidReceivedData(_ data: Data)
}

enum FatalError: String, Error {
    case invalidStoryboardCreate = "Cannot create View storyboard"
}

