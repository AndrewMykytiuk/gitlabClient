//
//  AlertHelper.swift
//  GitlabClient
//
//  Created by User on 21/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class AlertHelper {
    
    static func createErrorAlert(message: String, handler: ((UIAlertAction) -> Void)? = nil) -> UIAlertController {
        
        let title = NSLocalizedString(Constants.AlertStrings.title.rawValue, comment: "")
        let buttonTitle = NSLocalizedString(Constants.AlertStrings.okButton.rawValue, comment: "")
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: buttonTitle, style: .default, handler: handler))
        
        return alert
    }
    
}
