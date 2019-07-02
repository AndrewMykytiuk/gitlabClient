//
//  DiffConverter.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

protocol DiffConverterType {
    func viewModels(from change: MergeRequestChange) -> [DiffCellViewModel]
}

class DiffConverter: DiffConverterType {
    
    private let parser = DiffsParser()
    private let decorator = DiffsDecorator()
    
    func viewModels(from change: MergeRequestChange) -> [DiffCellViewModel] {
        var models: [DiffCellViewModel] = []
        let model = parser.parseStringIntoModel(with: change.diff)
        let items = decorator.transformModelIntoItems(model: model)
        for item in items {
            let diffCellViewModel = DiffCellViewModel(cellColor: item.color, hasHeader: false, hasFooter: item.nonInARowOrder, string: item.string)
            models.append(diffCellViewModel)
        }
        
        return models
    }
}
