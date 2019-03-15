//
//  Helper.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    enum Constants {
        static let pattern = "(code=)(.+?)&"
    }
    
    enum URLKind: String {
        
        case authorize = "/oauth/authorize"
        case token = "/oauth/token"
        case redirect = "/oauth/redirect"
        
    }
    
    func getAccessCode(from string: String) -> Result<String> {
        
        let regex = try? NSRegularExpression(pattern: Constants.pattern)
        let match = regex?.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        let nsStr = string as NSString
        
        var code = ""
        code = nsStr.substring(with: match?.range(at: 2) ?? NSRange())
        
        if code.count <= 0 {
            return .error(NSError(domain: "Parse go wrong", code: 404, userInfo: [:])) 
        } else {
            return .success(code)
        }
        
    }
    
    func createURL(for operation: URLKind) -> URL {
        
        var components = URLComponents()
        
        components.scheme = secureScheme
        components.host = host
        components.path = operation.rawValue
        let queryItemClientID = URLQueryItem(name: "client_id", value: clientID)
        
        switch operation {
        case .authorize:
            
            let queryItemRedirectURI = URLQueryItem(name: "redirect_uri", value: redirectURL)
            let queryItemResponseType = URLQueryItem(name: "response_type", value: responseType)
            let queryItemState = URLQueryItem(name: "state", value: state)
            
            components.queryItems = [queryItemClientID, queryItemRedirectURI, queryItemResponseType, queryItemState]
        default:
            break
        }
        
        if let url = components.url {
            return url
        } else {
            return URL(fileURLWithPath: baseURL)
        }
        
    }
    
    func dictionaryFromData(_ data: Data) -> Result<[String:Any]> {
        var dictionary: [String:Any] = [:]
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                print(json)
                dictionary = json
            }
        } catch let error {
            return .error(error)
        }
        return .success(dictionary)
    }
    
}
