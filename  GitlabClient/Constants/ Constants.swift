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
        
        enum ProjectRequest: String {
            case membershipKey = "membership"
            case membershipYesValue = "yes"
        }
        
        enum MergeRequest: String {
            case stateOpenedValue = "merged"//"opened"
            case mergeRequestsKey = "merge_requests"
            case changesKey = "changes"
        }
        
        enum ApproveKey: String {
            case approve = "approve"
            case unapprove = "unapprove"
        }
        
        enum Authorize {
            
            enum Keys: String {
                case clientIDKey = "client_id"
                case redirectURLKey = "redirect_uri"
                case clientSecretKey = "client_secret"
                case grantTypeKey = "grant_type"
                case responseTypeKey = "response_type"
                case codeKey = "code"
                case stateKey = "state"
                case accessTokenKey = "access_token"
            }
            
            enum Values: String {
                case clientIDValue = "84318559ea36e249bd51365dca13ba9f937aa09442e67dc1c31c25a376adcafa"
                case clientSecretValue = "3808bf00f1e124ef8e4046e74d0c4eef83d88823aa6a2f7465c9647cace23794"
                case redirectURLValue = "https://gitlabclient.com/oauth/redirect"
                case grantTypeValue = "authorization_code"
                case stateValue = "1234567"
                case codeValue = "code"
            }
            
        }

        enum Path: String {
            case api = "/api/v4/"
            case profile = "user"
            case projects = "projects"
        }
        
    }
    
    enum LikeButtonImageNames: String {
        case approve = "icons8-thumbs-up-50.png"
        case disapprove = "icons8-thumbs-down-50.png"
    }
    
    enum AlertStrings: String {
        case title = "AlertHelper.ErrorTitle"
        case okButton = "AlertHelper.OKTitle"
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
    
    enum Colors {
        
        case mainRed
        case mainGreen
        case mainOrange
        
        var value: UIColor {
            switch self {
            case .mainRed:
                return UIColor.colorWithRGB(red: 250, green: 197, blue: 205, alpha: 1.0)
            case .mainGreen:
                return UIColor.colorWithRGB(red: 199, green: 240, blue: 210, alpha: 1.0)
            case .mainOrange:
                return UIColor.colorWithRGB(red: 229, green: 191, blue: 60, alpha: 1.0)
            }
        }
    }
    
    
}



