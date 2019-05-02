//
//  StringHelper.swift
//  GitlabClient
//
//  Created by User on 16/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class TextHelper {
    
    private enum ConstantExpressions {
        static let pattern = "((https|http)://)((\\w|-)+)(([.]|[/])((\\w|-)+))+"
    }
    
    static func urlsInString(with string: String) ->Result<[String]> {
        
        guard let regex = try? NSRegularExpression(pattern: ConstantExpressions.pattern) else {
            return .error(ParsingError.wrongInstrumentsFor(ConstantExpressions.pattern))
        }
        
        let matches = regex.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string))
        
        var code: [String] = []
        
        for match in matches {
            let range = match.range(at: 0)
            let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
            code.append(String(stringArray))
        }
        
        return .success(code)
        
    }
    
    static func getHeightForStringInLabel(with string: String, width: CGFloat) -> CGFloat {
        let attributes = [NSAttributedString.Key.font: Constants.font]
        
        let rect = NSString(string: string).boundingRect(
            with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attributes as [NSAttributedString.Key : Any], context: nil)
        
        return rect.height
    }
    
    static func getHeightForNSAttributedStringInLabel(with string: NSAttributedString, width: CGFloat) -> CGFloat {
        
        let rect = NSMutableAttributedString(attributedString: string).boundingRect(with: CGSize(width: width, height: CGFloat.greatestFiniteMagnitude), options: [.usesLineFragmentOrigin, .usesFontLeading,], context: nil)
        
        return rect.height
    }
    
}
