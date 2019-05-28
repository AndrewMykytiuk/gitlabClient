//
//  ProjectStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class ProjectStorageService {
    
    let storage: StorageService?
    let mapper: ProjectMapper?
    
    init(with storage: StorageService, mapper: ProjectMapper) {
        self.storage = storage
        self.mapper = mapper
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "ProjectEntity")
    }
}
