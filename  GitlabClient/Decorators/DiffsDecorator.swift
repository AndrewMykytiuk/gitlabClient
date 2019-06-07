//
//  DiffsDecorator.swift
//  GitlabClient
//
//  Created by User on 05/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol DiffsDecoratorType: class {
    func performModel(model: FileDiffsViewModel) -> [NSMutableAttributedString]
}

class DiffsDecorator: DiffsDecoratorType {
    
    let addedColor = Constants.Colors.mainGreen.value
    let deletedColor = Constants.Colors.mainRed.value
    let attributes = [NSAttributedString.Key.font : Constants.font]
    
    func performModel(model: FileDiffsViewModel) -> [NSMutableAttributedString] {
        var attributes: [NSMutableAttributedString] = []
        switch model.state {
        case .new:
            guard let strings = model.newContent else { return [] }
            let addedStrings = strings.map({setUpColorForFile(with: $0, with: addedColor)})
            attributes.append(contentsOf: addedStrings)
        case .deleted:
            guard let strings = model.oldContent else { return [] }
            let deletedAttributes = strings.map({setUpColorForFile(with: $0, with: deletedColor)})
            attributes.append(contentsOf: deletedAttributes)
        case .modified:
            guard let addedStrings = model.newContent else { return [] }
            let addedAttributes = addedStrings.map({setUpColorForFile(with: $0, with: addedColor)})
            guard let deletedStrings = model.oldContent else { return addedAttributes }
            let deletedAttributes = deletedStrings.map({setUpColorForFile(with: $0, with: deletedColor)})
            attributes.append(contentsOf: addedAttributes)
            attributes.append(contentsOf: deletedAttributes)
        }
        return attributes
    }
    
    private func setUpColorForFile(with string: String, with color: UIColor) -> NSMutableAttributedString {
        let attribute = NSMutableAttributedString(string: string, attributes: attributes as [NSAttributedString.Key : Any])
        let range = NSRange(location: 0, length: string.count)
        attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
        return attribute
    }
//
//    private func setUpColorForString(_ attribute: NSMutableAttributedString, with ranges: [NSRange]?, with color: UIColor) {
//        guard let rangeArray = ranges else { return }
//        for range in rangeArray {
//            attribute.addAttribute(NSAttributedString.Key.backgroundColor, value: color, range: range)
//        }
//    }
    
}
