//
//  DiffsParser.swift
//  GitlabClient
//
//  Created by User on 28/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol DiffsParserType {
    func parseStringIntoModel(with string: String) -> FileDiffsViewModel
}

class DiffsParser: DiffsParserType {
    
    private enum Patterns: String {
        case added = "^[+]\\D(.+)$"
        case deleted = "^[-]\\D(.+)$"
    }
    
    func parseStringIntoModel(with string: String) -> FileDiffsViewModel {
        let fileDiffsViewModel = findChanges(with: [.added, .deleted], string: string)
        return fileDiffsViewModel
    }
    
    private func findChanges(with patterns: [Patterns], string: String) -> FileDiffsViewModel {
        
        var fileDiffsViewModel = FileDiffsViewModel(with: nil, oldContent: nil, nonInARowStrings: nil)
        for pattern in patterns {

            let ranges = self.findedRanges(with: pattern, string: string)
            let strings = ranges.map({self.substringFromStringAndRange($0, and: string)})
            
            let nonInARowRanges = self.wrongOrderRanges(ranges: ranges)
            let nonInARowStrings = nonInARowRanges.map({self.substringFromStringAndRange($0, and: string)})
            fileDiffsViewModel.nonInARowStrings = nonInARowStrings
            
            switch pattern {
            case .added:
                fileDiffsViewModel.newContent = strings
            case .deleted:
                fileDiffsViewModel.oldContent = strings
            }
        }
        
        if let newContent = fileDiffsViewModel.newContent, let oldContent = fileDiffsViewModel.oldContent, !newContent.isEmpty && !oldContent.isEmpty {
            fileDiffsViewModel.state = .modified
        }
        
        return fileDiffsViewModel
    }
    
    private func wrongOrderRanges(ranges: [NSRange]) -> [NSRange] {
        var rangesWithFooter: [NSRange] = []
        for i in 0...ranges.count {
            if i+1 < ranges.count {
                if (ranges[i].location + ranges[i].length + 1) != ranges[i+1].location {
                    rangesWithFooter.append(ranges[i])
                }
            }
        }
        return rangesWithFooter
    }
    
    private func substringFromStringAndRange(_ range: NSRange, and string: String) -> String {
        let stringArray = (Array(string)[range.location...(range.location + range.length - 1)])
        let string = String(stringArray)
        return string
    }
    
    private func findedRanges(with pattern: Patterns, string: String) -> [NSRange] {
        var ranges: [NSRange] = []
        let regex = try? NSRegularExpression(pattern: pattern.rawValue, options: [ .anchorsMatchLines])
        
        guard let matches = regex?.matches(in: string, options: [], range: NSRange(string.startIndex..., in: string)) else { return [] }
        
        for match in matches {
            let range = match.range(at: 0)
            ranges.append(range)
        }
        return ranges
    }
    
}
