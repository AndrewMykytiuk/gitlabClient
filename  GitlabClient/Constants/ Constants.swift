//
//  Constants.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

enum Constants {
    
    enum Network: String {
        
        case secureScheme = "https"
        case host = "gitlab.dataart.com"
        case clientID = "84318559ea36e249bd51365dca13ba9f937aa09442e67dc1c31c25a376adcafa"
        case clientSecret = "3808bf00f1e124ef8e4046e74d0c4eef83d88823aa6a2f7465c9647cace23794"
        case redirectURL = "https://gitlabclient.com/oauth/redirect"
        case responseType = "code"
        case grantType = "authorization_code"
        case state = "1234567"
        
    }
    
    enum KeyValues: String {
        
        case clientIDKey = "client_id"
        case redirectURLKey = "redirect_uri"
        case responseTypeKey = "response_type"
        case stateKey = "state"
        case accessTokenKey = "access_token"
        case clientSecretKey = "client_secret"
        case grantTypeKey = "grant_type"
        
    }
    
    enum AlertStrings: String {
        case title = "Error"
        case okButton = "OK"
        
    }
    
}



