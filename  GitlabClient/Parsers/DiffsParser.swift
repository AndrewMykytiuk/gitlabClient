//
//  DiffsParser.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol DiffsParserType: class {
    func parseChangesIntoModel(with changes: MergeRequestChanges) -> FileDiffsViewModel
}

class DiffsParser: DiffsParserType {
    
    private enum Patterns: String {
        
        case added = "^[+]\\D(.+)$"
        case deleted = "^[-]\\D(.+)$"
        
    }
    
    func parseChangesIntoModel(with changes: MergeRequestChanges) -> FileDiffsViewModel {
        
        var fileDiffsViewModel = findChanges(with: [.added, .deleted], string: changes.diff)
        let currentState = FileDiffsViewModel.Kind(with: changes.state)
        fileDiffsViewModel.state = currentState
        return fileDiffsViewModel
    }
    
    private func findChanges(with patterns: [Patterns], string: String) -> FileDiffsViewModel {
        
        var fileDiffsViewModel = FileDiffsViewModel(with: nil, oldContent: nil, newContentRanges: nil, oldContentRanges: nil)
        for pattern in patterns {
            var ranges: [NSRange] = []
            var strings: [String] = []
            let regex = try? NSRegularExpression(pattern: pattern.rawValue, options: [ .anchorsMatchLines])
            
            guard let matches = regex?.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string)) else { return fileDiffsViewModel }
            
            for match in matches {
                let range = match.range(at: 0)
                let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
                let string = String(stringArray)
                ranges.append(range)
                strings.append(string)
            }
            
            switch pattern {
            case .added:
                fileDiffsViewModel.newContentRanges = ranges
                fileDiffsViewModel.newContent = strings
            case .deleted:
                fileDiffsViewModel.oldContentRanges = ranges
                fileDiffsViewModel.oldContent = strings
            }
        }
        return fileDiffsViewModel
    }
    
}
