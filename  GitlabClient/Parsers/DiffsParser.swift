//
//  DiffsParser.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

class DiffsParser {
    
    private enum PatternsWithColors {
        
        case added
        case deleted
        
        var info: (pattern: String, color: UIColor) {
            switch self {
            case .added:
                return ("^[+]\\D(.+)$", Constants.Colors.mainGreen.value)
            case .deleted:
                return ("^[-]\\D(.+)$", Constants.Colors.mainRed.value)
            }
        }
        
    }
    
    init() {
        
    }
    
    func setUpColorsForString(with change: MergeRequestChanges) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font : Constants.font]
        let attribute = NSMutableAttributedString(string: change.diff, attributes: attributes as [NSAttributedString.Key : Any])
        
        switch change.state {
        case .new:
            findAndHighliteText(with: [.added], string: change.diff, attribute: attribute)
        case .deleted:
            findAndHighliteText(with: [.deleted], string: change.diff, attribute: attribute)
        case .modified:
            findAndHighliteText(with: [.added, .deleted], string: change.diff, attribute: attribute)
        }
        return attribute
    }
    
    private func findAndHighliteText(with patternsWithColor: [PatternsWithColors], string: String, attribute: NSMutableAttributedString) {
        for patternWithColor in patternsWithColor {
            
            let regex = try? NSRegularExpression(pattern: patternWithColor.info.pattern, options: [ .anchorsMatchLines])
            
            guard let matches = regex?.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string)) else { return }
            
            for match in matches {
                let range = match.range(at: 0)
                setUpColorForString(attribute, with: range, with: patternWithColor.info.color)
            }
        }
    }
    
    private func setUpColorForString(_ attribute: NSMutableAttributedString, with range: NSRange, with color: UIColor) {
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
    }
}
