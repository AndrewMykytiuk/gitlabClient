//
//  Helper.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class AuthHelper { 
    
    private enum Constants {
        static let pattern = "(code=)(.+?)&"
    }
    
    internal enum URLKind: String {
        
        case authorize = "/oauth/authorize"
        case token = "/oauth/token"
        case redirect = "/oauth/redirect"
        
    }
    
    static func getAccessCode(from string: String) -> Result<String> {
        
        guard let regex = try? NSRegularExpression(pattern: Constants.pattern) else {
            return .error(ParsingError.wrongInstruments)
        }
        let match = regex.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        if let range = match?.range(at: 2) {
            let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
            let code = String(stringArray)
            return .success(code)
            
        }
        return .error(ParsingError.wrongResult)
    }
    
    static func createURL(for operation: URLKind) -> Result<URL> {
        
        var components = NetworkManager.createBaseUrlComponents()
        components.path = operation.rawValue
        let queryItemClientID = URLQueryItem(name: globalConstants.clientIDKey.rawValue, value: globalConstants.clientID.rawValue)
        
        switch operation {
        case .authorize:
            let queryItemRedirectURI = URLQueryItem(name: globalConstants.redirectURLKey.rawValue, value: globalConstants.redirectURL.rawValue)
            let queryItemResponseType = URLQueryItem(name: globalConstants.responseTypeKey.rawValue, value: globalConstants.responseType.rawValue)
            let queryItemState = URLQueryItem(name: globalConstants.stateKey.rawValue, value: globalConstants.state.rawValue)
            
            components.queryItems = [queryItemClientID, queryItemRedirectURI, queryItemResponseType, queryItemState]
        default:
            break
        }
        
        if let url = components.url {
            return .success(url)
        } else {
            return .error(NetworkError.invalidUrl)
        }
        
    }
    
}
