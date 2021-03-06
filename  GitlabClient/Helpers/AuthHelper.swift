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
    
    private enum ConstantExpressions {
        static let pattern = "(code=)(.+?)&"
    }
    
    enum URLKind: String {
        
        case authorize = "/oauth/authorize"
        case token = "/oauth/token"
        case redirect = "/oauth/redirect"
        
    }
    
    static func getAccessCode(from string: String) -> Result<String> {
        
        guard let regex = try? NSRegularExpression(pattern: ConstantExpressions.pattern) else {
            return .error(ParsingError.wrongInstrumentsFor(ConstantExpressions.pattern))
        }
        let match = regex.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        if let range = match?.range(at: 2) {
            let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
            let code = String(stringArray)
            return .success(code)
            
        }
        return .error(ParsingError.emptyResult(match?.range.description))
    }
    
    static func createURL(for operation: URLKind) -> Result<URL> {
        
        var components = URLHelper.createBaseAuthUrlComponents()
        components.path = operation.rawValue
        let queryItemClientID = URLQueryItem(name: Constants.Network.Authorize.Keys.clientIDKey.rawValue, value: Constants.Network.Authorize.Values.clientIDValue.rawValue)
        
        switch operation {
        case .authorize:
            let queryItemRedirectURI = URLQueryItem(name: Constants.Network.Authorize.Keys.redirectURLKey.rawValue, value: Constants.Network.Authorize.Values.redirectURLValue.rawValue)
            let queryItemResponseType = URLQueryItem(name: Constants.Network.Authorize.Keys.responseTypeKey.rawValue, value: Constants.Network.Authorize.Values.codeValue.rawValue)
            let queryItemState = URLQueryItem(name: Constants.Network.Authorize.Keys.stateKey.rawValue, value: Constants.Network.Authorize.Values.stateValue.rawValue)
            
            components.queryItems = [queryItemClientID, queryItemRedirectURI, queryItemResponseType, queryItemState]
        default:
            break
        }
        
        if let url = components.url {
            return .success(url)
        } else {
            return .error(NetworkError.invalidUrl(components.description))
        }
        
    }
}
