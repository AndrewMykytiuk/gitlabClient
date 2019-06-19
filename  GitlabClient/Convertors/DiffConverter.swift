//
//  DiffConverter.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol DiffConverterType {
     func convertChangesToStrings(mergeRequestChange: MergeRequestChanges) -> [DiffCellViewModel]
}

class DiffConverter: DiffConverterType {
    
    let parser = DiffsParser()
    let decorator = DiffsDecorator()
    
    func convertChangesToStrings(mergeRequestChange: MergeRequestChanges) -> [DiffCellViewModel] {
        var models: [DiffCellViewModel] = []
        let model = parser.parseStringIntoModel(with: mergeRequestChange.diff)
        let items = decorator.transformModelIntoItem(model: model)
        for item in items {
            let diffCellViewModel = DiffCellViewModel(cellColor: item.color, hasHeader: false, hasFooter: item.nonInARowOrder, string: item.string)
            models.append(diffCellViewModel)
        }
        
        return models
    }
}
