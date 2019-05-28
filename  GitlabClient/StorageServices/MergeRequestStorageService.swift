//
//  MergeRequestStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class MergeRequestStorageService {
    
    let storage: StorageService?
    let mapper: MergeRequestMapper?
    
    init(with storage: StorageService, mapper: MergeRequestMapper) {
        self.storage = storage
        self.mapper = mapper
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "MergeRequestEntity")
    }
}
