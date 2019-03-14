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
    
    enum Result {
        case success(String)
        case error(String)
    }
    
    func getAccessCode(from string: String) -> Result{
        var code = ""
        
        let regex = try? NSRegularExpression(pattern: "(code=)(.+?)&")
        let match = regex?.firstMatch(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        let nsStr = string as NSString
        
        code = nsStr.substring(with: match?.range(at: 2) ?? NSRange())
        
        if code.count <= 0 {
            return .error("Can't parse access code clearly")
        } else {
            return .success(code)
        }
        
    }
    
}
