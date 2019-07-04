//
//  MergeRequestHelper.swift
//  GitlabClient
//
//  Created by User on 02/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class MergeRequestHelper {
    
    enum ImageKind: String {
        case like = "icons8-thumbs-up-50"
        case unlike = "icons8-thumbs-down-50"
    }
    
    class func createButtonForLikes<T: BaseViewController>(with action: String, for target: T, type: ImageKind) -> UIBarButtonItem {
        let button = UIBarButtonItem(image: UIImage(named: type.rawValue), style: .plain, target: target, action: Selector(action))
        return button
    }
}
