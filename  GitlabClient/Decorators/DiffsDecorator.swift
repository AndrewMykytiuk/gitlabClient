//
//  DiffsDecorator.swift
//  GitlabClient
//
//  Created by User on 05/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import UIKit

protocol DiffsDecoratorType {
    func transformModelIntoItem(model: FileDiffsViewModel) -> [DiffItem]
}

class DiffsDecorator: DiffsDecoratorType {
    
    let addedColor = Constants.Colors.mainGreen.value
    let deletedColor = Constants.Colors.mainRed.value
    let attributes = [NSAttributedString.Key.font : Constants.font]
    
    func transformModelIntoItem(model: FileDiffsViewModel) -> [DiffItem] {
        var items: [DiffItem]
        
        switch model.state {
        case .new:
            items = self.createItemsWith(strings: model.newContent, nonInARowStrings: model.nonInARowStrings, color: addedColor)
        case .deleted:
            items = self.createItemsWith(strings: model.oldContent, nonInARowStrings: model.nonInARowStrings, color: deletedColor)
        case .modified:
            items = self.createItemsWith(strings: model.oldContent, nonInARowStrings: model.nonInARowStrings, color: deletedColor)
            items.append(contentsOf: self.createItemsWith(strings: model.newContent, nonInARowStrings: model.nonInARowStrings, color: addedColor))
        }
        
        return items
    }
    
    private func createItemsWith(strings: [String]?, nonInARowStrings: [String]?, color: UIColor) -> [DiffItem] {
        var items: [DiffItem] = []
        guard let strings = strings else { return [] }
        if let nonInARowStrings = nonInARowStrings {
        for string in strings {
            let inARowOrder = nonInARowStrings.contains(string)
            let item = DiffItem(nonInARowOrder: inARowOrder, string: string, color: color)
            items.append(item)
        }
        }
        return items
    }
    
}
