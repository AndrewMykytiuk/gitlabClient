//
//  NetworkManager.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation


class NetworkManager {
    
    func sendRequest(_ request: Request, completion: @escaping(Result<Data>) -> Void) {
        
        var components = NetworkManager.createBaseUrlComponents()
        components.path = request.path
        
        for param in request.parameters {
            let queryItem = URLQueryItem(name: param.key, value: param.value as? String)
            components.queryItems?.append(queryItem)
        }
        
        guard let url = components.url else {
            return completion(.error(NetworkError.invalidUrl))}
        
        let session = URLSession.shared

        var tempRequest = URLRequest(url: url)
        tempRequest.httpMethod = request.HTTPMethod.rawValue
        
        tempRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        tempRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        let task = session.dataTask(with: tempRequest as URLRequest, completionHandler: { data, response, error in
            
            if let requiredError = error {
                return completion(.error(requiredError))
            }
            
            guard let data = data else {
                return completion(.error(NetworkError.invalidReceivedData))
            }
            return completion(.success(data))
        })
        task.resume()
        
    }
    
    static func dictionaryFromData(_ data: Data) -> Result<[String:Any]> {
        var dictionary: [String:Any] = [:]
        
        do {
            if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                dictionary = json
            }
        } catch let error {
            return .error(error)
        }
        return .success(dictionary)
    }
    
    static func createBaseUrlComponents() -> URLComponents {
        var components = URLComponents()
        
        components.scheme = globalConstants.secureScheme.rawValue
        components.host = globalConstants.host.rawValue
        components.queryItems = []
        
        return components
    }
    
}
