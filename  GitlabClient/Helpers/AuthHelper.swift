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
        
        var components = AuthHelper.createBaseUrlComponents()
        components.path = operation.rawValue
        let queryItemClientID = URLQueryItem(name: Constants.KeyValues.clientIDKey.rawValue, value: Constants.Network.clientID.rawValue)
        
        switch operation {
        case .authorize:
            let queryItemRedirectURI = URLQueryItem(name: Constants.KeyValues.redirectURLKey.rawValue, value: Constants.Network.redirectURL.rawValue)
            let queryItemResponseType = URLQueryItem(name: Constants.KeyValues.responseTypeKey.rawValue, value: Constants.Network.responseType.rawValue)
            let queryItemState = URLQueryItem(name: Constants.KeyValues.stateKey.rawValue, value: Constants.Network.state.rawValue)
            
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
    
    static func createBaseUrlComponents() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = Constants.Network.secureScheme.rawValue
        components.host = Constants.Network.host.rawValue
        components.queryItems = []
        
        return components
    }
}
