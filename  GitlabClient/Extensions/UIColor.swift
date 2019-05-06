//
//  UIColor.swift
//  GitlabClient
//
//  Created by User on 03/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

extension UIColor {
    static func colorWithRGB(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) -> UIColor {
        return UIColor(red:red/255, green:green/255, blue:blue/255, alpha:alpha)
    }
}
