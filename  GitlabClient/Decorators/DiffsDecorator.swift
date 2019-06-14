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
    func performModelIntoItem(model: FileDiffsViewModel) -> [DiffItem]
}

class DiffsDecorator: DiffsDecoratorType {
    
    let addedColor = Constants.Colors.mainGreen.value
    let deletedColor = Constants.Colors.mainRed.value
    let attributes = [NSAttributedString.Key.font : Constants.font]
    
    func performModelIntoItem(model: FileDiffsViewModel) -> [DiffItem] {
        var items: [DiffItem]
        
        switch model.state {
        case .new:
            items = self.createItemsWith(strings: model.newContent, nonInARowStrings: model.nonInARowStrings, isNewContent: true)
        case .deleted:
            items = self.createItemsWith(strings: model.oldContent, nonInARowStrings: model.nonInARowStrings, isNewContent: false)
        case .modified:
            items = self.createItemsWith(strings: model.oldContent, nonInARowStrings: model.nonInARowStrings, isNewContent: false)
            items.append(contentsOf: self.createItemsWith(strings: model.newContent, nonInARowStrings: model.nonInARowStrings, isNewContent: true))
        }
        
        return items
    }
    
    private func createItemsWith(strings: [String]?, nonInARowStrings: [String]?, isNewContent: Bool) -> [DiffItem] {
        var items: [DiffItem] = []
        guard let strings = strings else { return [] }
        if let nonInARowStrings = nonInARowStrings {
        for string in strings {
            let inARowOrder = nonInARowStrings.contains(string)
            let item = DiffItem(nonInARowOrder: inARowOrder, string: string, isNew: isNewContent)
            items.append(item)
        }
        }
        return items
    }
    
}
