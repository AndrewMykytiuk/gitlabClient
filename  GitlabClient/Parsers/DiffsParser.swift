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
    
    func setUpColorsForString(with state: MergeRequestChanges.FileState, diffs: String) -> NSAttributedString {
        let attributes = [NSAttributedString.Key.font : Constants.font]
        let attribute = NSMutableAttributedString(string: diffs, attributes: attributes as [NSAttributedString.Key : Any])
        
        switch state {
        case .new:
            setUpColorForFile(attribute, with: diffs, with: .added)
        case .deleted:
            setUpColorForFile(attribute, with: diffs, with: .deleted)
        case .modified:
            findAndHighliteText(with: [.added, .deleted], string: diffs, attribute: attribute)
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
    
    private func setUpColorForFile(_ attribute: NSMutableAttributedString, with string: String, with patternWithColor: PatternsWithColors) {
        let range = NSRange(location: 0, length: string.count)
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: patternWithColor.info.color, range: range)
    }
    
    private func setUpColorForString(_ attribute: NSMutableAttributedString, with range: NSRange, with color: UIColor) {
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
    }
}
