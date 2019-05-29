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
    
    init(with storage: StorageService) {
        self.storage = storage
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "MergeRequestEntity")
    }
}
