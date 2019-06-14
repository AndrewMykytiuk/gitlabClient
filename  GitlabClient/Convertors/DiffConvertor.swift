//
//  DiffConvertor.swift
//  GitlabClient
//
//  Created by User on 11/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation

class DiffConvertor {
    func convertChangesToStrings(mergeRequestChange: MergeRequestChanges) -> [DiffCellViewModel] {
        var models: [DiffCellViewModel] = []
        let parser = DiffsParser()
        let model = parser.parseStringIntoModel(with: mergeRequestChange.diff)
        let decorator = DiffsDecorator()
        let items = decorator.performModelIntoItem(model: model)
        for item in items {
            let cellColor = item.isNew ? Constants.Colors.mainGreen.value : Constants.Colors.mainRed.value
            let diffCellViewModel = DiffCellViewModel(cellColor: cellColor, hasHeader: false, hasFooter: item.nonInARowOrder, string: item.string)
            models.append(diffCellViewModel)
        }
        
        return models
    }
}
