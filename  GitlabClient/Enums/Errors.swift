//
//  Errors.swift
//  GitlabClient
//
//  Created by User on 17/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

enum ParsingError: String, Error {
    case wrongEnterData = "wrongEnterData"
    case wrongProccessing = "wrongProccessing"
    case wrongInstruments = "wrongInstruments"
    case wrongResult = "wrongResult"
}

enum NetworkError: String, Error {
    case invalidUrl = "invalidUrl"
    case invalidRequest = "invalidRequest"
    case invalidReceivedData = "invalidReceivedData"
}
