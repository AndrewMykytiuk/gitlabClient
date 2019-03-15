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
        
        var components = URLComponents()

        components.scheme = secureScheme
        components.host = host
        components.path = request.path
        components.queryItems = []
        
        for param in request.parameters {
            if let temp = param.value as? String {
                let queryItem = URLQueryItem(name: param.key, value: temp)
                components.queryItems?.append(queryItem)
            }
        }
        
        guard let url = components.url else {
            return completion(.error(NSError(domain: "Invalid URL", code: 400, userInfo: [:])))}
        
        let session = URLSession.shared

        var tempRequest = URLRequest(url: url)
        tempRequest.httpMethod = request.HTTPMethod.rawValue
        
        tempRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        tempRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        var dataR = Data()
        
        let task = session.dataTask(with: tempRequest as URLRequest, completionHandler: { data, response, error in
            
            if let requiredError = error {
                return completion(.error(requiredError))
            }
            
            guard data != nil else {
                return completion(.error(NSError(domain: "No data received", code: 404, userInfo: [:])))
            }
            
            dataR = data ?? Data()
            return completion(.success(dataR))
        })
        task.resume()
        
    }
    
}
