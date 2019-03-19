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
        
        var code: String?
        
        do {
            let regex = try NSRegularExpression(pattern: Constants.pattern)
            let match = regex.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
            
            if let range = match?.range(at: 2) {
              code = String(Array(string)[range.location...(range.location + range.length - 1)])
            }
            
        } catch {
            return .error(ParsingError.wrongInstruments)
        }
        
        guard let temp = code else {
            return .error(ParsingError.wrongResult)
        }
        return .success(temp)
    }
    
    static func createURL(for operation: URLKind) -> Result<URL> {
        
        var components = NetworkManager.createBaseUrlComponents()
        components.path = operation.rawValue
        let queryItemClientID = URLQueryItem(name: "client_id", value: globalConstants.clientID.rawValue)
        
        switch operation {
        case .authorize:
            let queryItemRedirectURI = URLQueryItem(name: "redirect_uri", value: globalConstants.redirectURL.rawValue)
            let queryItemResponseType = URLQueryItem(name: "response_type", value: globalConstants.responseType.rawValue)
            let queryItemState = URLQueryItem(name: "state", value: globalConstants.state.rawValue)
            
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
    
    static func createAlert(message: String) -> UIAlertController {
        let alert = UIAlertController(title: "Something go wrong", message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
        
        return alert
    }
    
}
