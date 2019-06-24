//
//  NetworkManager.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import SystemConfiguration

class NetworkManager {
    
    private var token: String?
    private let reachability = SCNetworkReachabilityCreateWithName(nil, Constants.Network.baseUrl.rawValue)
    
    func configure(token: String?) {
        self.token = token
    }
    
    func sendRequest(_ request: Request, completion: @escaping Completion<Data>) {
        
        var components = URLHelper.createBaseAuthUrlComponents()
        components.path = request.path
        
        for param in request.parameters {
            let queryItem = URLQueryItem(name: param.key, value: param.value as? String)
            components.queryItems?.append(queryItem) }
        
        if token != nil {
            let queryItem = URLQueryItem(name: Constants.Network.Authorize.Keys.accessTokenKey.rawValue, value: token)
            components.queryItems?.append(queryItem)
        }
        
        guard let url = components.url else {
            return completion(.error(NetworkError.invalidUrl(components.description)))}
        
        let session = URLSession.shared

        var tempRequest = URLRequest(url: url)
        tempRequest.httpMethod = request.HTTPMethod.rawValue
        
        tempRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        tempRequest.addValue("application/json", forHTTPHeaderField: "Accept")
        
        tempRequest.timeoutInterval = .init(10)
        
        
        checkReachability { (reachability) in
            if reachability {
                
                let task = session.dataTask(with: tempRequest as URLRequest, completionHandler: { data, response, error in
                    
                    if let requiredError = error {
                        return completion(.error(requiredError))
                    }
                    
                    guard let data = data else {
                        return completion(.error(ParsingError.emptyResult(response?.description)))
                    }
                    return completion(.success(data))
                })
                task.resume()
            } else {
                return completion(.error(GitLabError.Network.reachability))
        }
    }
   
    }
    
    func checkReachability(completion: @escaping (Bool) -> Void) {
        
        let queue = DispatchQueue.main
        var isReachable = false
        
        guard let tempReachability = reachability else { return completion(isReachable) }
        
        var flags = SCNetworkReachabilityFlags()
        
        queue.async {
            SCNetworkReachabilityGetFlags(tempReachability, &flags)
            isReachable = flags.contains(.reachable)
            return completion(isReachable)
        }
    }
    
}
