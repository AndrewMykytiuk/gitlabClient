//
//  Constants.swift
//  GitlabClient
//
//  Created by User on 14/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

enum Constants {
    
    static let font = UIFont(name: "Verdana", size: CGFloat(17))
    
    enum Network: String {
        
        case baseUrl = "www.gitlab.dataart.com"
        case secureScheme = "https"
        case host = "gitlab.dataart.com"
        case clientID = "84318559ea36e249bd51365dca13ba9f937aa09442e67dc1c31c25a376adcafa"
        case clientSecret = "3808bf00f1e124ef8e4046e74d0c4eef83d88823aa6a2f7465c9647cace23794"
        case redirectURL = "https://gitlabclient.com/oauth/redirect"
        case responseType = "code"
        case grantType = "authorization_code"
        case state = "1234567"
        case accessToken = "access_token"
        
    }
    
    enum NetworkPath: String {
        case api = "/api/v4/"
        case profile = "user"
        case projects = "projects"
        case mergeRequest = "projects/"
    }
    
    enum ProjectRequestKeyValues: String {
        case membershipKey = "membership"
        case membershipYesKey = "yes"
    }
    
    enum MergeRequestKeyValues: String {
        case stateOpenedKey = "opened"
        case mergeRequestsKey = "/merge_requests"
    }
    
    enum AuthorizeKeyValues: String {
        case clientIDKey = "client_id"
        case redirectURLKey = "redirect_uri"
        case clientSecretKey = "client_secret"
        case grantTypeKey = "grant_type"
        case stateKey = "state"
        case responseTypeKey = "response_type"
    }
    
    enum AlertStrings: String {
        case title = "Error"
        case okButton = "OK"
    }
    
    enum RefreshControl: String {
        case projectsTableViewTitle = "ProjectsTableView.RefreshControl"
        case profileTableViewTitle = "ProfileTableView.RefreshControl"
        case mergeRequestsChangesTableViewTitle = "MergeRequestChangesTableView.RefreshControl"
    }
    
    enum TabBarItemNames {
    
        case main
        case profile
       
        var info: (index: Int, description: String) {
            switch self {
            case .profile:
                return (1, "Profile")
            case .main:
                return (0, "Feed")
            }
        }
        
    }
    
    enum DateFormatter: String {
        case dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ"
        case locale = "en_US_POSIX"
    }
    
    
}



