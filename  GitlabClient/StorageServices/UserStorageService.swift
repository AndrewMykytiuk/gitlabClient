//
//  UserStorageService.swift
//  GitlabClient
//
//  Created by User on 27/04/2019.
//  Copyright © 2019 MPTechnologies. All rights reserved.
//

import Foundation
import CoreData

class UserStorageService {
    
    let storage: StorageService?
    let mapper: UserMapper?
    
    init(with storage: StorageService, mapper: UserMapper) {
        self.storage = storage
        self.mapper = mapper
    }
    
    func createFetchRequest() -> NSFetchRequest<NSFetchRequestResult> {
        return NSFetchRequest<NSFetchRequestResult>(entityName: "UserEntity")
    }
}
